package com.mindmate.controller;

import com.mindmate.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AnalyticsService analyticsService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("role", "admin");
        
        // Get real-time analytics from service
        Map<String, Object> analytics = analyticsService.getCurrentAnalytics();
        model.addAllAttributes(analytics);
        
        return "admin/dashboard";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("role", "admin");
        return "admin/profile";
    }

    // Forum moderation (keep your existing implementation)
    @GetMapping("/forum-moderation")
    public String forumModeration(Model model) {
        model.addAttribute("role", "admin");
        // Your existing forum moderation code...
        return "admin/forum-moderation";
    }
}