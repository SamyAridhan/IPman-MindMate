package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap; // Added import for HashMap
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class ForumController {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy");

    // 🔥 CORRECTED: Mock Post Data Structure using HashMap for > 10 key-value pairs 🔥
    private final List<Map<String, Object>> mockPosts = Arrays.asList(
        // Post 1
        new HashMap<String, Object>() {{ 
            put("id", 1); 
            put("title", "How to manage stress during exams?"); 
            put("content", "I feel overwhelmed with upcoming finals. Any non-meditation tips?"); 
            put("author", "AnonUser1"); 
            put("timestamp", LocalDateTime.now().minusHours(3).format(FORMATTER)); 
            put("category", "anxiety"); 
            put("categoryName", "Anxiety Support"); 
            put("replies", 8); 
            put("likes", 12); 
            put("views", 150); 
            put("supportLevel", "high"); 
            put("coachingRequested", false); 
            put("helpfulCount", 2);
            put("isFlagged", false);
        }},
        
        // Post 2
        new HashMap<String, Object>() {{ 
            put("id", 2); 
            put("title", "Coping with anxiety - sharing experiences"); 
            put("content", "I had a panic attack today and need to talk. Feeling completely alone right now."); 
            put("author", "AnonUser2"); 
            put("timestamp", LocalDateTime.now().minusDays(1).format(FORMATTER)); 
            put("category", "anxiety"); 
            put("categoryName", "Anxiety Support"); 
            put("replies", 15); 
            put("likes", 25); 
            put("views", 400); 
            put("supportLevel", "urgent"); 
            put("coachingRequested", true); 
            put("helpfulCount", 5);
            put("isFlagged", false);
        }},

        // Post 3
        new HashMap<String, Object>() {{ 
            put("id", 3); 
            put("title", "Tips for better sleep"); 
            put("content", "Struggling to fall asleep, what are your best techniques for relaxation?"); 
            put("author", "AnonUser3"); 
            put("timestamp", LocalDateTime.now().minusDays(3).format(FORMATTER)); 
            put("category", "general"); 
            put("categoryName", "General Support"); 
            put("replies", 4); 
            put("likes", 5); 
            put("views", 80); 
            put("supportLevel", "medium"); 
            put("coachingRequested", false); 
            put("helpfulCount", 1);
            put("isFlagged", false);
        }},
               
        // Post 4
        new HashMap<String, Object>() {{ 
            put("id", 4); 
            put("title", "Building self-confidence"); 
            put("content", "Just wanted to share a small win today! I spoke up in class. It gets better!"); 
            put("author", "AnonUser4"); 
            put("timestamp", LocalDateTime.now().minusDays(5).format(FORMATTER)); 
            put("category", "general"); 
            put("categoryName", "General Support"); 
            put("replies", 12); 
            put("likes", 30); 
            put("views", 220); 
            put("supportLevel", "positive"); 
            put("coachingRequested", false); 
            put("helpfulCount", 3);
            put("isFlagged", false);
        }}
    );
    // -------------------------------------------------------------------------

    // Inside ForumController.java (Add this helper method)

    // Helper method to find a post by ID
    private Map<String, Object> findPostById(int postId) {
        return mockPosts.stream()
                .filter(post -> (Integer) post.get("id") == postId)
                .findFirst()
                .orElse(null);
    }
    // --- Forum Module ---
    @GetMapping("/forum")
    public String forumList(
        @RequestParam(value = "sortBy", defaultValue = "recent") String sortBy,
        @RequestParam(value = "searchQuery", required = false) String searchQuery,
        Model model
    ) {
        // Start with the full list of mock posts (or fetch from the database)
        List<Map<String, Object>> posts = new ArrayList<>(mockPosts);

        // 1. Apply Search Filter (if searchQuery is present)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.toLowerCase();
            posts.removeIf(post -> 
                !((String) post.get("title")).toLowerCase().contains(query) &&
                !((String) post.get("content")).toLowerCase().contains(query)
            );
        }
        
        // 2. Apply Sorting Logic (as you had it)
        posts.sort((postA, postB) -> {
            switch (sortBy) {
                case "popular":
                    return ((Integer) postB.get("likes")).compareTo((Integer) postA.get("likes"));
                case "helpful":
                    return ((Integer) postB.get("helpfulCount")).compareTo((Integer) postA.get("helpfulCount"));
                case "active":
                    return ((Integer) postB.get("replies")).compareTo((Integer) postA.get("replies"));
                case "recent":
                default:
                    // Use the timestamp string for comparison
                    return ((String) postB.get("timestamp")).compareTo((String) postA.get("timestamp"));
            }
        });

        // 🔥 3. Calculate Category Counts and Define Category List (FIX for missing categories) 🔥
        Map<String, Long> categoryCounts = posts.stream() // Use the filtered 'posts' list for accurate counts
                .collect(Collectors.groupingBy(post -> (String) post.get("category"), Collectors.counting()));

        List<Map<String, Object>> forumCategories = Arrays.asList(
            Map.of("id", "all", "name", "All Topics", "count", (long) posts.size(), "color", "bg-blue-100 text-blue-800"),
            Map.of("id", "anxiety", "name", "Anxiety Support", "count", categoryCounts.getOrDefault("anxiety", 0L), "color", "bg-purple-100 text-purple-800"),
            Map.of("id", "general", "name", "General Support", "count", categoryCounts.getOrDefault("general", 0L), "color", "bg-green-100 text-green-800")
        );
        model.addAttribute("forumCategories", forumCategories);

        // 4. Identify Urgent Posts for Sidebar
        List<Map<String, Object>> urgentPosts = posts.stream()
                .filter(post -> "urgent".equals(post.get("supportLevel")))
                .collect(Collectors.toList());
        model.addAttribute("urgentPosts", urgentPosts);
        
        // 5. Pass lists and parameters to the view
        model.addAttribute("posts", posts);
        model.addAttribute("currentSort", sortBy);
        model.addAttribute("currentSearch", searchQuery);
        model.addAttribute("role", "student"); // Important for chatbot

        return "student/forum-list";
    }

    // Inside ForumController.java (Add this new method)

@PostMapping("/forum/flag")
@ResponseBody 
public Map<String, Object> flagPost(@RequestParam("postId") int postId) {
    Map<String, Object> post = findPostById(postId);

    if (post == null) {
        return Map.of("error", 404);
    }
    
    // Set the post as flagged in the mock data structure
    post.put("isFlagged", true);
    
    // In a real application, you would log this, email an admin, or queue a task.
    System.out.println("--- POST " + postId + " FLAGGED for review. ---");
    
    // Return the new flagged status to update the button color on the client
    return Map.of("success", true, "isFlagged", post.get("isFlagged"));
}

    @GetMapping("/forum/thread")
    public String forumThread(Model model) {
        model.addAttribute("role", "student");
        return "student/forum-thread";
    }
}