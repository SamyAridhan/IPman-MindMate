//src\main\java\com\mindmate\controller\CounselorController.java
package com.mindmate.controller;

import com.mindmate.model.Content;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/counselor")
public class CounselorController {

    // Content store
    private static final Map<Long, Content> STORE = new LinkedHashMap<>();
    private static final AtomicLong ID_COUNTER = new AtomicLong(1);

    // Appointments store
    private static final List<Map<String, Object>> APPOINTMENTS = new ArrayList<>();
    private static final AtomicLong APPOINTMENT_ID = new AtomicLong(1);

    static {
        // Seed content
        STORE.put(1L, new Content(1L, "Stress Management 101", "Article",
                "Learn effective stress-coping strategies for students", ""));
        STORE.put(2L, new Content(2L, "Mindfulness Meditation Guide", "Video",
                "15-minute guided meditation for anxiety relief", ""));
        STORE.put(3L, new Content(3L, "Sleep Hygiene", "Article", 
                "Interactive module on building better sleep habits", ""));
        STORE.put(4L, new Content(4L, "Understanding Anxiety", "Article", 
                "What causes anxiety and how to manage it", ""));
        STORE.put(5L, new Content(5L, "Building Resilience", "Article",
                "Develop emotional resilience for long-term wellbeing", ""));
        ID_COUNTER.set(6);

        // Seed appointments
        APPOINTMENTS.add(createAppointment(
            "2025-11-22",
            "15:30",
            "pending",
            "First session - social anxiety",
            "Sarah Chen"
        ));
        
        APPOINTMENTS.add(createAppointment(
            "2025-11-25",
            "10:00",
            "pending",
            "Crisis intervention follow-up",
            "Michael Torres"
        ));
        
        APPOINTMENTS.add(createAppointment(
            "2025-11-29",
            "14:00",
            "pending",
            "group session",
            "Anxiety Support Group"
        ));
        
        APPOINTMENTS.add(createAppointment(
            "2025-12-02",
            "09:00",
            "confirmed",
            "Individual session",
            "Emily Johnson"
        ));
    }

    private static Map<String, Object> createAppointment(String date, String time, 
                                                          String status, String notes, String studentName) {
        Map<String, Object> apt = new HashMap<>();
        apt.put("id", String.valueOf(APPOINTMENT_ID.getAndIncrement()));
        apt.put("date", date);
        apt.put("time", time);
        apt.put("status", status);
        apt.put("notes", notes);
        apt.put("studentName", studentName);
        return apt;
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("role", "counselor");
        
        // Calculate today's appointments
        String today = LocalDate.now().toString();
        long todayCount = APPOINTMENTS.stream()
            .filter(apt -> today.equals(apt.get("date")))
            .count();
        
        // Calculate pending requests
        long pendingCount = APPOINTMENTS.stream()
            .filter(apt -> "pending".equals(apt.get("status")))
            .count();
        
        // Get today's appointments
        List<Map<String, Object>> todayAppointments = APPOINTMENTS.stream()
            .filter(apt -> today.equals(apt.get("date")))
            .collect(Collectors.toList());
        
        // Get pending appointments (limit to 3 for dashboard)
        List<Map<String, Object>> pendingAppointments = APPOINTMENTS.stream()
            .filter(apt -> "pending".equals(apt.get("status")))
            .limit(3)
            .collect(Collectors.toList());
        
        model.addAttribute("todayCount", todayCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("todayAppointments", todayAppointments);
        model.addAttribute("pendingAppointments", pendingAppointments);
        
        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    public String showSchedule(Model model) {
        model.addAttribute("role", "counselor");
        
        // Get all pending appointments
        List<Map<String, Object>> pendingAppointments = APPOINTMENTS.stream()
            .filter(apt -> "pending".equals(apt.get("status")))
            .collect(Collectors.toList());
        
        // Get today's appointments
        String today = LocalDate.now().toString();
        List<Map<String, Object>> todayAppointments = APPOINTMENTS.stream()
            .filter(apt -> today.equals(apt.get("date")))
            .collect(Collectors.toList());
        
        model.addAttribute("pendingAppointments", pendingAppointments);
        model.addAttribute("todayAppointments", todayAppointments);
        model.addAttribute("selectedDate", today);
        
        return "counselor/schedule";
    }

    @PostMapping("/appointment/approve")
    public String approveAppointment(@RequestParam String appointmentId) {
        APPOINTMENTS.stream()
            .filter(apt -> appointmentId.equals(apt.get("id")))
            .findFirst()
            .ifPresent(apt -> apt.put("status", "confirmed"));
        
        return "redirect:/counselor/schedule";
    }

    @PostMapping("/appointment/deny")
    public String denyAppointment(@RequestParam String appointmentId) {
        APPOINTMENTS.stream()
            .filter(apt -> appointmentId.equals(apt.get("id")))
            .findFirst()
            .ifPresent(apt -> apt.put("status", "cancelled"));
        
        return "redirect:/counselor/schedule";
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
        return "counselor/profile";
    }
}