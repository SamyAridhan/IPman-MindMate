package com.mindmate.controller;

import com.mindmate.model.Content;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@Controller
@RequestMapping("/counselor")
public class CounselorController {

    // Simple in-memory store. Not for production.
    private static final Map<Long, Content> STORE = new LinkedHashMap<>();
    private static final AtomicLong ID_COUNTER = new AtomicLong(1);

    static {
        // seed some demo content
        STORE.put(1L, new Content(1L, "Stress Management 101", "Article",
                "Learn effective stress-coping strategies for students", ""));
        STORE.put(2L, new Content(2L, "Mindfulness Meditation Guide", "Video",
                "15-minute guided meditation for anxiety relief", ""));
        STORE.put(3L,
                new Content(3L, "Sleep Hygiene", "Article", "Interactive module on building better sleep habits", ""));
        STORE.put(4L,
                new Content(4L, "Understanding Anxiety", "Article", "What causes anxiety and how to manage it", ""));
        STORE.put(5L, new Content(5L, "Building Resilience", "Article",
                "Develop emotional resilience for long-term wellbeing", ""));
        ID_COUNTER.set(6);
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("role", "counselor");
        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    public String showSchedule(Model model) {
        model.addAttribute("role", "counselor");
        return "counselor/schedule";
    }

    @GetMapping("/content")
    public String manageContent(Model model) {
        model.addAttribute("role", "counselor");
        List<Content> list = new ArrayList<>(STORE.values());
        model.addAttribute("contents", list);
        return "counselor/content-manager";
    }

    @PostMapping("/content/create")
    public String createOrUpdateContent(@RequestParam String title,
            @RequestParam String contentType,
            @RequestParam String description,
            @RequestParam String content,
            @RequestParam(required = false) Long editingId) {
        if (editingId != null) {
            Content existing = STORE.get(editingId);
            if (existing != null) {
                existing.setTitle(title);
                existing.setType(contentType);
                existing.setDescription(description);
                existing.setContent(content);
            }
        } else {
            long id = ID_COUNTER.getAndIncrement();
            Content c = new Content(id, title, contentType, description, content);
            STORE.put(id, c);
        }
        return "redirect:/counselor/content";
    }

    @PostMapping("/content/delete")
    public String deleteContent(@RequestParam Long id) {
        STORE.remove(id);
        return "redirect:/counselor/content";
    }

    @GetMapping("/profile")
public String profile(Model model) {
    model.addAttribute("role", "counselor");
    return "counselor/profile"; // Create placeholder
}
}