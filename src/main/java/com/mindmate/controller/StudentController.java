package com.mindmate.controller;

import org.apache.logging.log4j.message.Message;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // Added this import
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("role", "student");
        return "student/dashboard";
    }

    //assessment module handled by AssessmentController

    // --- Content/Library Module ---
    @GetMapping("/library")
    public String contentLibrary(Model model) {
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    // FIX 1: Handle "Read More" (Single Article View)
    @GetMapping("/library/view")
    public String viewContent(Model model) {
        model.addAttribute("role", "student");
        return "student/content-view"; 
    }

    // --- Forum Module Handled in ForumController---
    

    // --- Telehealth Module ---
    @GetMapping("/telehealth") // Matches the Header Link
    public String telehealthBook(Model model) {
        model.addAttribute("role", "student");
        return "student/telehealth-book";
    }
    
    @GetMapping("/telehealth/book") // Catch-all for cleaner URLs
    public String telehealthBookAlt(Model model) {
        model.addAttribute("role", "student");
        return "student/telehealth-book";
    }

    // FIX 2: Handle "Confirm Booking" (Form Submit)
    @PostMapping("/telehealth/book")
    public String processBooking() {
        // Logic to save appointment would go here
        return "redirect:/student/telehealth/my-appointments";
    }

    // FIX 3: The "Success" Page (My Appointments)
    @GetMapping("/telehealth/my-appointments")
    public String telehealthMyAppointments(Model model) {
        model.addAttribute("role", "student");
        return "student/telehealth-my-appointments";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("role", "student");
        return "student/profile"; // Create this JSP placeholder
    }

}