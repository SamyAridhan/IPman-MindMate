package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // Added this import
import org.springframework.web.bind.annotation.RequestMapping;

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

    // --- Assessment Module ---
    @GetMapping("/assessment")
    public String assessmentList(Model model) {
        model.addAttribute("role", "student");
        return "student/assessment-list";
    }

    @GetMapping("/assessment/take")
    public String assessmentQuestions(Model model) {
        model.addAttribute("role", "student");
        return "student/assessment-questions";
    }

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

    // --- Forum Module ---
    @GetMapping("/forum")
    public String forumList(Model model) {
        model.addAttribute("role", "student");
        List<String> forumThreads = Arrays.asList(
            "How to manage stress during exams?",
            "Coping with anxiety - sharing experiences",
            "Tips for better sleep",
            "Building self-confidence"
        );
        model.addAttribute("forumThreads", forumThreads);
        return "student/forum-list";
    }

    @GetMapping("/forum/thread")
    public String forumThread(Model model) {
        model.addAttribute("role", "student");
        return "student/forum-thread";
    }

    // --- Chatbot Module ---
    @GetMapping("/chatbot")
    public String chatbot(Model model) {
        model.addAttribute("role", "student");
        return "student/chatbot";
    }

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
}