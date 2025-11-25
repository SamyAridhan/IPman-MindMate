package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 1. Import Model
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/counselor")
public class CounselorController {

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("role", "counselor"); // 2. Set Role
        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    public String showSchedule(Model model) {
        model.addAttribute("role", "counselor"); // 2. Set Role
        return "counselor/schedule"; 
    }

    @GetMapping("/content")
    public String manageContent(Model model) {
        model.addAttribute("role", "counselor"); // 2. Set Role
        return "counselor/content-manager";
    }

    @GetMapping("/content/new")
    public String showCreateContentForm() {
        // Redirects don't need the model attribute because 
        // the browser starts a new request to the target URL.
        return "redirect:/counselor/content";
    }
}