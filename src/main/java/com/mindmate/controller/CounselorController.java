package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/counselor")
public class CounselorController {

    @GetMapping("/dashboard")
    public String showDashboard() {
        return "counselor/dashboard";
    }

    // --- ADD THIS MISSING METHOD ---
    @GetMapping("/schedule")
    public String showSchedule() {
        return "counselor/schedule"; 
    }
    // -------------------------------

    @GetMapping("/content")
    public String manageContent() {
        return "counselor/content-manager";
    }
}