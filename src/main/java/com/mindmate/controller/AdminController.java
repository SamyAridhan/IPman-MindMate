//src\main\java\com\mindmate\controller\AdminController.java
package com.mindmate.controller;

import com.mindmate.model.SystemAnalytics;
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.SystemAnalyticsDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller for admin dashboard and system management.
 * Contains analytics business logic embedded.
 * * @author Samy (A23CS0246) - Analytics Module
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private SystemAnalyticsDAO analyticsDAO;

    /**
     * Displays admin dashboard with system analytics.
     * Business logic for analytics calculation embedded here.
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("role", "admin");
        
        // Business Logic: Calculate analytics inline
        long totalUsers = studentDAO.count();
        long totalAppointments = appointmentDAO.count();
        
        // Mock data for incomplete modules
        long activeUsers = 856L;  // TODO: Calculate from recent activity
        int assessmentsTaken = 3421;  // TODO: From AssessmentDAO
        int forumPosts = 1089;        // TODO: From ForumDAO
        
        // Add to model
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalAppointments", totalAppointments);
        model.addAttribute("activeUsers", activeUsers);
        model.addAttribute("assessmentsTaken", assessmentsTaken);
        model.addAttribute("forumPosts", forumPosts);
        
        return "admin/dashboard";
    }

    /**
     * Saves current analytics snapshot to database.
     */
    @GetMapping("/analytics/snapshot")
    @Transactional
    public String saveSnapshot() {
        
        // Business Logic: Create and save snapshot
        SystemAnalytics snapshot = new SystemAnalytics();
        snapshot.setTotalUsers((int) studentDAO.count());
        snapshot.setActiveUsers(856);  // Mock
        snapshot.setAssessmentsTaken(3421);  // Mock
        snapshot.setForumPosts(1089);  // Mock
        
        analyticsDAO.save(snapshot);
        
        return "redirect:/admin/dashboard?snapshotsaved=true";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("role", "admin");
        return "admin/profile";
    }

    // Keep your existing forum moderation methods...
    @GetMapping("/forum-moderation")
    public String forumModeration(Model model) {
        model.addAttribute("role", "admin");
        // Your existing forum code...
        return "admin/forum-moderation";
    }
}