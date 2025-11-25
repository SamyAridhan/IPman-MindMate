package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "student/dashboard";
    }

    @GetMapping("/assessment")
    public String assessmentList() {
        return "student/assessment-list";
    }

    @GetMapping("/assessment/take")
    public String assessmentQuestions() {
        return "student/assessment-questions";
    }

    @GetMapping("/library")
    public String contentLibrary() {
        return "student/content-library";
    }

    @GetMapping("/forum")
    public String forumList(Model model) {
        // Add dummy forum threads to the model
        List<String> forumThreads = Arrays.asList(
            "How to manage stress during exams?",
            "Coping with anxiety - sharing experiences",
            "Tips for better sleep",
            "Building self-confidence",
            "Dealing with peer pressure"
        );
        model.addAttribute("forumThreads", forumThreads);
        return "student/forum-list";
    }

    @GetMapping("/forum/thread")
    public String forumThread() {
        return "student/forum-thread";
    }

    @GetMapping("/chatbot")
    public String chatbot() {
        return "student/chatbot";
    }

    @GetMapping("/telehealth")
    public String telehealthBook() {
        return "student/telehealth-book";
    }

    @GetMapping("/telehealth/my-appointments")
    public String telehealthMyAppointments() {
        return "student/telehealth-my-appointments";
    }
}

