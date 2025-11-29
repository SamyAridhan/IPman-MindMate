package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 1. Import Model
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("role", "admin"); // 2. Set Role to 'admin'
        return "admin/dashboard";
    }

    @GetMapping("/profile")
public String profile(Model model) {
    model.addAttribute("role", "admin");
    return "admin/profile"; // Create placeholder
}

@GetMapping("/forum-moderation")
public String forumModeration(Model model) {
    model.addAttribute("role", "admin");
    return "admin/forum-moderation"; // Create placeholder
}
}