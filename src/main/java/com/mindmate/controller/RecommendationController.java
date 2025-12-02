package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/student/recommendation") 
public class RecommendationController {
    @GetMapping
    public String viewRecommendation(@RequestParam("id") String resourceId, Model model) {
        
        // 1. Log the click for debugging/tracking
        System.out.println("Recommendation Clicked ID: " + resourceId);

        // 2. Fetch and prepare resource data based on the ID
        String title = "Resource Not Found";
        String content = "Please return to the main resources page.";
        String embedHtml = ""; // Use this for video or embedded content

        if ("mindfulness-beginners".equals(resourceId)) {
            title = "Mindfulness for Beginners: Guided Session";
            content = "A 15-minute introductory session to reduce stress and improve focus.";
            // Placeholder YouTube embed (replace with a real, safe embed code)
            embedHtml = "<iframe width='100%' height='400' src='https://www.youtube.com/embed/exampleMindfulnessVideo' frameborder='0' allowfullscreen></iframe>";
        
        } else if ("sleep-hygiene-tips".equals(resourceId)) {
            title = "Top 5 Sleep Hygiene Tips Article";
            content = "Simple steps you can take tonight to dramatically improve your sleep quality. Focus on light, temperature, and routine.";
            embedHtml = "<div class='text-lg p-4 bg-muted/50 rounded-lg'>Article Content Goes Here...</div>";

        } else if ("breathing-exercises-quick".equals(resourceId)) {
            title = "Quick 4-7-8 Breathing Technique";
            content = "A simple, powerful exercise for immediate anxiety relief. Inhale for 4, hold for 7, exhale for 8.";
            embedHtml = "<div class='text-xl text-center p-8 bg-primary/10 rounded-lg'>Follow the rhythm: 4-7-8</div>";

        }
        
        // 3. Add the fetched data to the model for the JSP view
        model.addAttribute("resourceTitle", title);
        model.addAttribute("resourceContent", content);
        model.addAttribute("embedHtml", embedHtml);
        
        // 4. Return the view name
        return "student/ai-resource"; 
    }
}