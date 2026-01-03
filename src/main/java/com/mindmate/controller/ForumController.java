package com.mindmate.controller;

import com.mindmate.dao.ForumDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import com.mindmate.model.Student;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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
        Model model,
        HttpSession session
    ) {
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }
    
        // 1. Fetch all posts (for deduplication and counting)
        List<ForumPost> rawAllPosts = forumDAO.getAllPosts(sortBy, searchQuery);
        
        // ✅ DEBUG: Print raw count
        System.out.println("🔍 DEBUG: rawAllPosts size = " + rawAllPosts.size());
        
        // 2. ✅ DEDUPLICATE using LinkedHashMap to preserve order and ensure uniqueness by ID
        Map<Integer, ForumPost> uniquePostsMap = new LinkedHashMap<>();
        for (ForumPost p : rawAllPosts) {
            uniquePostsMap.put(p.getId(), p);
        }
        
        // ✅ DEBUG: Print deduplicated count
        System.out.println("🔍 DEBUG: uniquePostsMap size = " + uniquePostsMap.size());
        
        // 3. Convert back to list for filtering
        List<ForumPost> allUniquePosts = new ArrayList<>(uniquePostsMap.values());
        
        // 4. Filter by category if selected
        List<ForumPost> posts = allUniquePosts;
        if (categoryFilter != null && !categoryFilter.isEmpty() && !"all".equalsIgnoreCase(categoryFilter)) {
            posts = allUniquePosts.stream()
                    .filter(p -> categoryFilter.equalsIgnoreCase(p.getCategory()))
                    .collect(Collectors.toList());
        }
    
        // 5. Calculate category counts from ALL unique posts (not filtered by search)
        Map<String, Long> counts = calculateCategoryCounts(allUniquePosts);
    
        // 6. Map categories for the Sidebar
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
    
        // 7. Urgent posts
        List<ForumPost> urgentPosts = allUniquePosts.stream()
                .filter(p -> "Academic Pressure".equalsIgnoreCase(p.getCategory()) || p.isFlagged()) 
                .limit(3)
                .collect(Collectors.toList());
    
        model.addAttribute("posts", posts);
        model.addAttribute("forumCategories", forumCategories);
        model.addAttribute("urgentPosts", urgentPosts);
        model.addAttribute("currentSort", sortBy);
        model.addAttribute("currentSearch", searchQuery);
        model.addAttribute("selectedCategory", categoryFilter); 
        
        return "student/forum-list";
    }

    // ✅ NEW: Helper method to calculate category counts
    private Map<String, Long> calculateCategoryCounts(List<ForumPost> posts) {
        Map<String, Long> counts = new HashMap<>();
        List<String> validNames = Arrays.asList(
            "General Support", "Anxiety Support", "Depression Support", 
            "Stress Management", "Sleep Issues", "Relationships", "Academic Pressure"
        );
        
        // Initialize counts at 0
        validNames.forEach(name -> counts.put(name, 0L));
    
        for (ForumPost p : posts) {
            if (p.getCategory() == null) continue;
            
            String postCat = p.getCategory().toLowerCase().trim();
            for (String officialName : validNames) {
                String officialLower = officialName.toLowerCase();
                if (officialLower.contains(postCat) || postCat.contains(officialLower)) {
                    counts.put(officialName, counts.get(officialName) + 1);
                    break; 
                }
            }
        }
        
        return counts;
    }

    private Map<String, Object> createCategoryMap(String id, String name, Long count, String color) {
        return Map.of("id", id, "name", name, "count", count, "color", color);
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
    
        String currentUser = SessionHelper.getUserName(session); 
    
        if (currentUser == null) {
            Long userId = SessionHelper.getUserId(session);
            if (userId != null) {
                Student student = studentDAO.findById(userId);
                if (student != null) {
                    currentUser = student.getName();
                }
            }
        }
        
        if (currentUser == null) currentUser = "Anonymous Member";
    
        boolean anonymousValue = (isAnonymous != null && isAnonymous);
    
        ForumPost newPost = new ForumPost(title, content, category, currentUser, anonymousValue);
        forumDAO.saveOrUpdate(newPost);
    
        return "redirect:/student/forum";
    }

    @PostMapping("/forum/interact")
    @ResponseBody
    public Map<String, Object> recordInteraction(@RequestParam("postId") int postId, @RequestParam("type") String type) {
        ForumPost post = forumDAO.getPostById(postId);
        if (post == null) return Map.of("error", "Post not found");

        if ("like".equals(type)) {
            post.setLikes(post.getLikes() + 1);
        } else if ("helpful".equals(type)) {
            post.setHelpfulCount(post.getHelpfulCount() + 1);
        }

        forumDAO.saveOrUpdate(post);
        return Map.of("likes", post.getLikes(), "helpfulCount", post.getHelpfulCount());
    }

    @GetMapping("/forum/thread")
    public String forumThread(@RequestParam("id") int id, Model model, HttpSession session) {
        if (!SessionHelper.isLoggedIn(session)) {
            return "redirect:/login";
        }

        ForumPost post = forumDAO.getPostById(id);
        
        if (post == null) {
            return "redirect:/student/forum?error=PostNotFound";
        }

        model.addAttribute("post", post);
        model.addAttribute("role", "student");

        return "student/forum-thread"; 
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

        String currentUser = SessionHelper.getUserName(session);
        if (currentUser == null) {
            Student student = studentDAO.findById(SessionHelper.getUserId(session));
            currentUser = (student != null) ? student.getName() : "Unknown User";
        }

        ForumPost post = forumDAO.getPostById(postId);
        ForumReply parent = (parentId != null) ? forumDAO.getReplyById(parentId) : null;
        
        boolean anonValue = (isAnonymous != null && isAnonymous);
        ForumReply newReply = new ForumReply(content, currentUser, post, parent, anonValue);
        
        forumDAO.saveReply(newReply); 

        return "redirect:/student/forum/thread?id=" + postId;
    }
}