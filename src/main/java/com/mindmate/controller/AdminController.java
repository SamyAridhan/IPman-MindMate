package com.mindmate.controller;

import com.mindmate.model.SystemAnalytics;
import com.mindmate.util.SessionHelper; // ✅ Using Helper
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.SystemAnalyticsDAO;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
        
        model.addAttribute("role", "admin");
        return "admin/forum-moderation";
    }
}