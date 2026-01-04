package com.mindmate.controller;

import com.mindmate.dao.ForumDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class ForumController {

    @Autowired
    private ForumDAO forumDAO;
    
    @Autowired
    private StudentDAO studentDAO;

    @GetMapping("/forum")
    public String forumList(
        @RequestParam(value = "sortBy", defaultValue = "recent") String sortBy,
        @RequestParam(value = "searchQuery", required = false) String searchQuery,
        @RequestParam(value = "category", required = false) String categoryFilter, 
        @RequestParam(value = "view", required = false) String view, // Added for My Posts
        Model model,
        HttpSession session
    ) {
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }
    
        // Get current User Info
        Long loggedInUserIdLong = SessionHelper.getUserId(session);
        Integer currentUserId = (loggedInUserIdLong != null) ? loggedInUserIdLong.intValue() : null;
        String currentUserName = SessionHelper.getUserName(session);

        // 1. Fetch posts
        List<ForumPost> rawAllPosts = forumDAO.getAllPosts(sortBy, searchQuery, currentUserId);
        
        // 2. DEDUPLICATE & Mark Ownership
        Map<Integer, ForumPost> uniquePostsMap = new LinkedHashMap<>();
        for (ForumPost p : rawAllPosts) {
            // Check if current user owns this post
            if (p.getAuthor() != null && p.getAuthor().equals(currentUserName)) {
                p.setIsOwner(true);
            }
            uniquePostsMap.put(p.getId(), p);
        }
        
        List<ForumPost> allUniquePosts = new ArrayList<>(uniquePostsMap.values());
        
        // 3. Filter Logic
        List<ForumPost> posts = allUniquePosts;

        // View filter (My Posts vs All)
        if ("my-posts".equals(view)) {
            posts = posts.stream()
                    .filter(p -> p.getAuthor() != null && p.getAuthor().equals(currentUserName))
                    .collect(Collectors.toList());
        } 
        // Category filter (Only if not in "My Posts" view)
        else if (categoryFilter != null && !categoryFilter.isEmpty() && !"all".equalsIgnoreCase(categoryFilter)) {
            posts = posts.stream()
                    .filter(p -> categoryFilter.equalsIgnoreCase(p.getCategory()))
                    .collect(Collectors.toList());
        }
    
        // 4. Calculate category counts
        Map<String, Long> counts = calculateCategoryCounts(allUniquePosts);
    
        // 5. Map categories for Sidebar
        List<Map<String, Object>> forumCategories = Arrays.asList(
            createCategoryMap("all", "All Topics", (long) allUniquePosts.size(), "bg-gray-100 text-gray-800"),
            createCategoryMap("General Support", "General Support", counts.get("General Support"), "bg-green-100 text-green-800"),
            createCategoryMap("Anxiety Support", "Anxiety Support", counts.get("Anxiety Support"), "bg-purple-100 text-purple-800"),
            createCategoryMap("Depression Support", "Depression Support", counts.get("Depression Support"), "bg-blue-100 text-blue-800"),
            createCategoryMap("Stress Management", "Stress Management", counts.get("Stress Management"), "bg-orange-100 text-orange-800"),
            createCategoryMap("Sleep Issues", "Sleep Issues", counts.get("Sleep Issues"), "bg-indigo-100 text-indigo-800"),
            createCategoryMap("Relationships", "Relationships", counts.get("Relationships"), "bg-pink-100 text-pink-800"),
            createCategoryMap("Academic Pressure", "Academic Pressure", counts.get("Academic Pressure"), "bg-yellow-100 text-yellow-800")
        );
    
        model.addAttribute("posts", posts);
        model.addAttribute("forumCategories", forumCategories);
        model.addAttribute("currentSort", sortBy);
        model.addAttribute("currentSearch", searchQuery);
        model.addAttribute("selectedCategory", categoryFilter); 
        
        return "student/forum-list";
    }

    @PostMapping("/forum/delete")
    @ResponseBody
    public Map<String, Object> deletePost(@RequestParam("postId") int postId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        String currentUserName = SessionHelper.getUserName(session);

        ForumPost post = forumDAO.getPostById(postId);
        
        // Security check: Only author can delete
        if (post != null && post.getAuthor().equals(currentUserName)) {
            try {
                forumDAO.deletePost(postId);
                response.put("success", true);
            } catch (Exception e) {
                response.put("success", false);
                response.put("error", e.getMessage());
            }
        } else {
            response.put("success", false);
            response.put("error", "Unauthorized");
        }
        return response;
    }

    @PostMapping("/forum/interact")
    @ResponseBody
    public Map<String, Object> recordInteraction(
            @RequestParam("postId") int postId, 
            @RequestParam("type") String type,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        Long userIdLong = SessionHelper.getUserId(session);
        if (userIdLong == null) {
            response.put("success", false);
            return response;
        }
        int userId = userIdLong.intValue();

        ForumPost post = forumDAO.getPostById(postId);
        if (post == null) {
            response.put("success", false);
            return response;
        }

        boolean isActive = false;
        int newCount = 0;

        if ("like".equals(type)) {
            Set<Integer> likes = post.getLikedUserIds();
            if (likes.contains(userId)) {
                likes.remove(userId);
                isActive = false;
            } else {
                likes.add(userId);
                isActive = true;
            }
            post.setLikes(likes.size());
            newCount = post.getLikes();
        } 
        else if ("helpful".equals(type)) {
            Set<Integer> helpful = post.getHelpfulUserIds();
            if (helpful.contains(userId)) {
                helpful.remove(userId);
                isActive = false;
            } else {
                helpful.add(userId);
                isActive = true;
            }
            post.setHelpfulCount(helpful.size());
            newCount = post.getHelpfulCount();
        }

        forumDAO.saveOrUpdate(post);
        
        response.put("success", true);
        response.put("isActive", isActive);
        response.put("newCount", newCount);
        return response;
    }

    @PostMapping("/forum/flag")
    @ResponseBody
    public Map<String, Object> flagPost(@RequestParam("postId") int postId, HttpSession session) {
        Long userIdLong = SessionHelper.getUserId(session);
        if (userIdLong == null) return Map.of("success", false);
        
        ForumPost post = forumDAO.getPostById(postId);
        if (post != null) {
            post.getFlaggedUserIds().add(userIdLong.intValue());
            post.setFlagged(true);
            forumDAO.saveOrUpdate(post);
            return Map.of("success", true);
        }
        return Map.of("success", false);
    }

    @GetMapping("/forum/thread")
    public String forumThread(@RequestParam("id") int id, Model model, HttpSession session) {
        if (!SessionHelper.isLoggedIn(session)) return "redirect:/login";

        ForumPost post = forumDAO.getPostById(id);
        if (post == null) return "redirect:/student/forum?error=PostNotFound";

        Long userIdLong = SessionHelper.getUserId(session);
        String currentUserName = SessionHelper.getUserName(session);

        if (userIdLong != null) {
            int uid = userIdLong.intValue();
            post.setLikedByCurrentUser(post.getLikedUserIds().contains(uid));
            post.setHelpfulByCurrentUser(post.getHelpfulUserIds().contains(uid));
            post.setFlaggedByCurrentUser(post.getFlaggedUserIds().contains(uid));
            
            // Mark ownership for single thread view as well
            if (post.getAuthor().equals(currentUserName)) {
                post.setIsOwner(true);
            }
        }

        model.addAttribute("post", post);
        return "student/forum-thread"; 
    }

    private Map<String, Long> calculateCategoryCounts(List<ForumPost> posts) {
        Map<String, Long> counts = new HashMap<>();
        List<String> validNames = Arrays.asList(
            "General Support", "Anxiety Support", "Depression Support", 
            "Stress Management", "Sleep Issues", "Relationships", "Academic Pressure"
        );
        validNames.forEach(name -> counts.put(name, 0L));
    
        for (ForumPost p : posts) {
            if (p.getCategory() == null) continue;
            String postCat = p.getCategory().trim();
            for (String officialName : validNames) {
                if (officialName.equalsIgnoreCase(postCat)) {
                    counts.put(officialName, counts.get(officialName) + 1);
                    break; 
                }
            }
        }
        return counts;
    }

    private Map<String, Object> createCategoryMap(String id, String name, Long count, String color) {
        return Map.of("id", id, "name", name, "count", count != null ? count : 0L, "color", color);
    }

    @PostMapping("/forum/create")
    public String createPost(
        @RequestParam("title") String title,
        @RequestParam("story") String content,
        @RequestParam("category") String category,
        @RequestParam(value = "anonymous", required = false) Boolean isAnonymous,
        HttpSession session
    ) {
        if (!SessionHelper.isLoggedIn(session)) return "redirect:/login";
        String author = SessionHelper.getUserName(session);
        ForumPost newPost = new ForumPost(title, content, category, author, (isAnonymous != null && isAnonymous));
        forumDAO.saveOrUpdate(newPost);
        return "redirect:/student/forum";
    }

    @PostMapping("/forum/thread/reply")
    public String postReply(
        @RequestParam("postId") int postId, 
        @RequestParam("reply") String content,
        @RequestParam(value = "parentId", required = false) Integer parentId,
        @RequestParam(value = "anonymous", required = false) Boolean isAnonymous,
        HttpSession session
    ) {
        if (!SessionHelper.isLoggedIn(session)) return "redirect:/login";
        String author = SessionHelper.getUserName(session);
        ForumPost post = forumDAO.getPostById(postId);
        ForumReply parent = (parentId != null) ? forumDAO.getReplyById(parentId) : null;
        ForumReply newReply = new ForumReply(content, author, post, parent, (isAnonymous != null && isAnonymous));
        forumDAO.saveReply(newReply); 
        return "redirect:/student/forum/thread?id=" + postId;
    }

    // NEW: Fetch post data for the edit modal
    @GetMapping("/forum/get")
    @ResponseBody
    public ForumPost getPostJson(@RequestParam("postId") int postId) {
        return forumDAO.getPostById(postId);
    }

    // NEW: Handle the actual update
    @PostMapping("/forum/update")
    public String updatePost(
        @RequestParam("postId") int postId,
        @RequestParam("title") String title,
        @RequestParam("story") String content,
        @RequestParam("category") String category,
        @RequestParam(value = "anonymous", required = false) Boolean isAnonymous,
        HttpSession session
    ) {
        String currentUserName = SessionHelper.getUserName(session);
        ForumPost existingPost = forumDAO.getPostById(postId);

        // Security check: Only author can update
        if (existingPost != null && existingPost.getAuthor().equals(currentUserName)) {
            existingPost.setTitle(title);
            existingPost.setContent(content);
            existingPost.setCategory(category);
            existingPost.setAnonymous(isAnonymous != null && isAnonymous);
            forumDAO.saveOrUpdate(existingPost);
        }
        return "redirect:/student/forum";
    }
}