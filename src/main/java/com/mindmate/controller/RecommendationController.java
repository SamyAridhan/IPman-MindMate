package com.mindmate.controller;

import com.mindmate.model.RecommendationResource; // Still needed for structured data
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
        
        System.out.println("Recommendation Clicked ID: " + resourceId);

        // Define the Resource object that will hold the content
        RecommendationResource resource;

        // 🌟 ALL RESOURCE MAPPING LOGIC IS NOW DIRECTLY IN THIS METHOD
        if ("mindfulness-beginners".equals(resourceId)) {
            // Video Resource: Uses Success/Green badge style
            resource = new RecommendationResource(
                "Mindfulness for Beginners: Guided Session",
                "A 15-minute introductory session to reduce stress and improve focus. Use headphones for the best experience.",
                "<iframe width='100%' height='400' src='https://www.youtube.com/embed/exampleMindfulnessVideo' frameborder='0' allowfullscreen class='rounded-lg shadow-md'></iframe>",
                "Video Session",
                "badge-success" 
            );
        
        } else if ("sleep-hygiene-tips".equals(resourceId)) {
            // Article Resource: Uses Accent Blue outline style
            resource = new RecommendationResource(
                "Top 5 Sleep Hygiene Tips Article",
                "Simple steps you can take tonight to dramatically improve your sleep quality. Focus on light, temperature, and routine.",
                "<div class='text-base p-4 bg-muted rounded-lg border border-border notification-card'><h4>💡 Key Takeaways:</h4><ul><li>Maintain a consistent bedtime.</li><li>Avoid screens one hour before sleep.</li><li>Keep your room cool and dark.</li></ul></div>",
                "Article",
                "badge-outline-blue" 
            );

        } else if ("breathing-exercises-quick".equals(resourceId)) {
            // Exercise Resource: Uses Primary/Ring style
            resource = new RecommendationResource(
                "Quick 4-7-8 Breathing Technique",
                "A simple, powerful exercise for immediate anxiety relief. Inhale for 4, hold for 7, exhale for 8. Repeat for 3 cycles.",
                "<div class='text-xl text-center p-8 bg-primary/10 rounded-lg border border-ring progress-bar-fill blue-accent'>🧘 Follow the rhythm: Inhale 4 / Hold 7 / Exhale 8</div>",
                "Quick Exercise",
                "session-card pink-accent" 
            );

        } else {
            // Default Not Found Resource
            resource = new RecommendationResource(
                "Resource Not Found",
                "Please return to the main resources page.",
                "<div class='notification-card bg-destructive/10 text-destructive-foreground'>Error: Invalid resource ID.</div>",
                "Error",
                "badge-destructive"
            );
        }

        // Add the entire structured resource object to the model
        model.addAttribute("resource", resource);
        
        return "student/ai-resource"; 
    }
}