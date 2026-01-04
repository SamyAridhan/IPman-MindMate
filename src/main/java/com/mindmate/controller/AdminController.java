//src\main\java\com\mindmate\controller\AdminController.java
package com.mindmate.controller;

import com.mindmate.model.SystemAnalytics;
import com.mindmate.util.SessionHelper; // ✅ Using Helper
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.SystemAnalyticsDAO;
import com.mindmate.dao.ForumDAO;
import com.mindmate.model.ForumPost;
import com.mindmate.model.ModerationStats;

import jakarta.servlet.http.HttpSession;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private SystemAnalyticsDAO analyticsDAO;

    @Autowired
    private ForumDAO forumDAO;

    /**
     * Checks if current user is an authorized Admin.
     */
    private boolean isAdmin(HttpSession session) {
        return SessionHelper.isLoggedIn(session) && "admin".equals(SessionHelper.getRole(session));
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session)); // ✅ Using Helper
        
        long totalUsers = studentDAO.count();
        long totalAppointments = appointmentDAO.count();
        
        // Mock data
        long activeUsers = 856L;
        int assessmentsTaken = 3421;
        int forumPosts = 1089;
        
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalAppointments", totalAppointments);
        model.addAttribute("activeUsers", activeUsers);
        model.addAttribute("assessmentsTaken", assessmentsTaken);
        model.addAttribute("forumPosts", forumPosts);
        
        return "admin/dashboard";
    }

    @GetMapping("/analytics/snapshot")
    @Transactional
    public String saveSnapshot(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        SystemAnalytics snapshot = new SystemAnalytics();
        snapshot.setTotalUsers((int) studentDAO.count());
        snapshot.setActiveUsers(856);
        snapshot.setAssessmentsTaken(3421);
        snapshot.setForumPosts(1089);
        
        analyticsDAO.save(snapshot);
        
        return "redirect:/admin/dashboard?snapshotsaved=true";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        return "admin/profile";
    }

    @GetMapping("/forum-moderation")
    public String forumModeration(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";


            // ✅ FIX: Set these so the header knows we are an admin
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));

        // 1. Fetch current flagged posts
        List<ForumPost> flaggedPosts = forumDAO.getFlaggedPosts();
        
        // 2. Fetch the HISTORICAL stats from the moderation_stats table
        ModerationStats stats = forumDAO.getModerationStats();
        
        model.addAttribute("flaggedPosts", flaggedPosts);
        model.addAttribute("flaggedCount", flaggedPosts.size());
        
        // 3. Pass the actual database values to the JSP
        model.addAttribute("approvedCount", stats.getApprovedCount());
        model.addAttribute("deletedCount", stats.getDeletedCount());
        
        return "admin/forum-moderation";
    }
    
    @PostMapping("/forum/approve")
    public String approvePost(@RequestParam("postId") int postId) {

        ForumPost post = forumDAO.getPostById(postId);
        if (post != null) {
            post.setFlagged(false);
            post.getFlaggedUserIds().clear();
            forumDAO.saveOrUpdate(post);
            
            // Persistent Increment
            forumDAO.incrementApprovedCount(); 
        }
        return "redirect:/admin/forum-moderation";
    }

    @PostMapping("/forum/delete")
    public String deletePost(@RequestParam("postId") int postId) {
        forumDAO.deletePost(postId);
        
        // Persistent Increment
        forumDAO.incrementDeletedCount(); 
        return "redirect:/admin/forum-moderation";
    }

    @GetMapping("/forum/view")
    public String viewFlaggedPost(@RequestParam("postId") int postId, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        // ✅ FIX: Set these so the header knows we are an admin
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));

        ForumPost post = forumDAO.getPostById(postId);
        if (post == null) return "redirect:/admin/forum-moderation";

        model.addAttribute("post", post);
        return "admin/forum-moderation-detail";
    }
}