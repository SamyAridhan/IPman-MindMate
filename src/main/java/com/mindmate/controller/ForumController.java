package com.mindmate.controller;

import com.mindmate.dao.ForumDAO;
import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class ForumController {

    @Autowired
    private ForumDAO forumDAO;

    @GetMapping("/forum")
    public String forumList(
        @RequestParam(value = "sortBy", defaultValue = "recent") String sortBy,
        @RequestParam(value = "searchQuery", required = false) String searchQuery,
        @RequestParam(value = "category", defaultValue = "all") String categoryFilter,
        Model model,
        HttpSession session
    ) {
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }

        // Fetch posts from DAO
        List<ForumPost> posts = forumDAO.getAllPosts(sortBy, searchQuery);

        // Filter by category if selected
        if (!"all".equals(categoryFilter)) {
            posts = posts.stream()
                    .filter(p -> categoryFilter.equalsIgnoreCase(p.getCategory()))
                    .collect(Collectors.toList());
        }

        // Get all posts once to calculate sidebar counts efficiently
        List<ForumPost> allPosts = forumDAO.getAllPosts("recent", null);
        Map<String, Long> counts = allPosts.stream()
                .filter(p -> p.getCategory() != null)
                .collect(Collectors.groupingBy(p -> p.getCategory().toLowerCase(), Collectors.counting()));

        // sidebar categories
        List<Map<String, Object>> forumCategories = Arrays.asList(
            Map.of("id", "all", "name", "All Topics", "count", (long) allPosts.size(), "color", "bg-blue-100 text-blue-800"),
            Map.of("id", "Anxiety", "name", "Anxiety Support", "count", counts.getOrDefault("anxiety", 0L), "color", "bg-purple-100 text-purple-800"),
            Map.of("id", "General", "name", "General Support", "count", counts.getOrDefault("general", 0L), "color", "bg-green-100 text-green-800")
        );

        // Urgent posts (e.g., categorized as "Anxiety" or specifically flagged)
        List<ForumPost> urgentPosts = allPosts.stream()
                .filter(p -> "Anxiety".equalsIgnoreCase(p.getCategory())) 
                .limit(3)
                .collect(Collectors.toList());

        model.addAttribute("posts", posts);
        model.addAttribute("forumCategories", forumCategories);
        model.addAttribute("urgentPosts", urgentPosts);
        model.addAttribute("currentSort", sortBy);
        model.addAttribute("currentSearch", searchQuery);
        
        return "student/forum-list";
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

        String currentUser = (String) session.getAttribute("username");
        boolean anonymousValue = (isAnonymous != null && isAnonymous);

        // Create and save
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
    // 1. Security Check
    if (!SessionHelper.isLoggedIn(session)) {
        return "redirect:/login";
    }

    // 2. Fetch the specific post from the database using your DAO
    ForumPost post = forumDAO.getPostById(id);
    
    if (post == null) {
        return "redirect:/student/forum?error=PostNotFound";
    }

    // 3. Add the post object to the model so the JSP can display it
    model.addAttribute("post", post);
    model.addAttribute("role", "student");

    // 4. Return the path to your JSP file (Ensure this matches your folder structure)
    return "student/forum-thread"; 
}

@PostMapping("/forum/thread/reply")
public String postReply(
    @RequestParam("postId") int postId, 
    @RequestParam("reply") String content,
    HttpSession session
) {
    if (!SessionHelper.isLoggedIn(session)) return "redirect:/login";
    String currentUser = (String) session.getAttribute("username");
    
    // 1. Get the parent post
    ForumPost post = forumDAO.getPostById(postId);
    
    // 2. Create the reply and link it to the post
    ForumReply newReply = new ForumReply(content, currentUser, post);
    
    // 3. Save the reply explicitly
    forumDAO.saveReply(newReply); 

    return "redirect:/student/forum/thread?id=" + postId;
}
}