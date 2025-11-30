package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody; 

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    // 1. 🔥 MOCK DATA STRUCTURE (Using standard HashMap for null-safe values) 🔥
    private final List<Map<String, Object>> mockPosts = new ArrayList<>(Arrays.asList(
        // Post 1: Approved 
        createPost("1", "Tips for stress relief", "Take deep breaths.", false, null, true, "AnonUser1", "2025-11-20"),
        
        // Post 2: Flagged (Hate speech)
        createPost("2", "Inappropriate comment", "This comment contains offensive language.", true, "Hate speech", false, "JohnDoe", "2025-11-25"),

        // Post 3: Flagged (Self-harm concern)
        createPost("3", "Need serious help", "Feeling hopeless and overwhelmed.", true, "Self-harm concern", true, "AnonUser3", "2025-11-29")
    ));

    // Helper method to create a HashMap with null-safe values (to prevent NPE from Map.of())
    private Map<String, Object> createPost(String id, String title, String content, boolean isFlagged, String flagReason, boolean isAnonymous, String author, String createdAt) {
        // Use Map.of() for non-null items, then convert to HashMap
        // to safely put the potentially null 'flag_reason'.
        Map<String, Object> post = new java.util.HashMap<>(Map.of(
            "id", id, 
            "title", title, 
            "content", content, 
            "is_flagged", isFlagged, 
            "is_anonymous", isAnonymous, 
            "author", author, 
            "created_at", createdAt
        ));
        // This is safe even if flagReason is null
        post.put("flag_reason", flagReason); 
        return post;
    }

    // Helper method to find a post by ID in the mock list
    private Map<String, Object> findPostById(String postId) {
        return mockPosts.stream()
                .filter(post -> postId.equals(post.get("id")))
                .findFirst()
                .orElse(null);
    }
    
    //---------------------------------------------------------

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("role", "admin");
        return "admin/dashboard";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("role", "admin");
        return "admin/profile";
    }

    // --- Admin Moderation View ---
    @GetMapping("/forum-moderation")
    public String forumModeration(Model model) {
        
        model.addAttribute("role", "admin");
        List<Map<String, Object>> allPosts = mockPosts;
        
        // Filter flagged posts for the table
        List<Map<String, Object>> flaggedPosts = allPosts.stream()
            .filter(post -> (Boolean) post.get("is_flagged"))
            .collect(Collectors.toList());

        // Calculate stats
        int totalPosts = allPosts.size();
        int totalFlagged = flaggedPosts.size();
        
        // Add required model attributes for the JSP
        model.addAttribute("posts", allPosts); 
        model.addAttribute("flaggedPosts", flaggedPosts);
        model.addAttribute("totalApprovedPosts", totalPosts - totalFlagged);
        
        return "admin/forum-moderation"; // Your JSP page
    }

    // --- Admin Actions (Approve/Unflag) ---
    @PostMapping("/forum/approve")
    public String approvePost(@RequestParam("postId") String postId) {
        Map<String, Object> post = findPostById(postId);
        if (post != null) {
            // Since mockPosts are now HashMaps, we can modify them
            post.put("is_flagged", false);
            post.put("flag_reason", null);
        }
        return "redirect:/admin/moderation/forum";
    }

    // --- Admin Actions (Delete) ---
    @PostMapping("/forum/delete")
    public String deletePost(@RequestParam("postId") String postId) {
        // Remove the post from the mock list
        mockPosts.removeIf(post -> postId.equals(post.get("id")));
        
        return "redirect:/admin/moderation/forum";
    }
}