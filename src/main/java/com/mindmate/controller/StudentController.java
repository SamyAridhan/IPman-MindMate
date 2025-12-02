package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.UUID;

@Controller
@RequestMapping("/student")
public class StudentController {

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        model.addAttribute("role", "student");
        
        // Get booked appointments from session
        @SuppressWarnings("unchecked")
        List<Map<String, String>> bookedAppointments = 
            (List<Map<String, String>>) session.getAttribute("bookedAppointments");
        
        if (bookedAppointments == null) {
            bookedAppointments = new ArrayList<>();
        }

        for (Map<String, String> app : bookedAppointments) {
            if (app.get("id") == null) {
                app.put("id", UUID.randomUUID().toString());
            }
        }

        session.setAttribute("bookedAppointments", bookedAppointments);
        
        model.addAttribute("bookedAppointments", bookedAppointments);
        
        return "student/dashboard";
    }

    // --- Content/Library Module ---
    @GetMapping("/library")
    public String contentLibrary(Model model) {
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    @GetMapping("/library/view")
    public String viewContent(Model model) {
        model.addAttribute("role", "student");
        return "student/content-view"; 
    }

    // --- Telehealth Module ---
    @GetMapping("/telehealth")
    public String telehealthBook(Model model) {
        model.addAttribute("role", "student");
        
        // Mock counselors data
        List<Map<String, Object>> counselors = Arrays.asList(
            createCounselor("1", "Dr. Sarah Johnson", "Mental Health Counseling", "4.5", "5 years", "High"),
            createCounselor("2", "Dr. Michael Chen", "Mental Health Counseling", "4.6", "6 years", "Medium"),
            createCounselor("3", "Dr. Emily Rodriguez", "Mental Health Counseling", "4.7", "7 years", "Low")
        );
        
        model.addAttribute("counselors", counselors);
        
        return "student/telehealth-book";
    }
    
    private Map<String, Object> createCounselor(String id, String name, String specialization, 
                                                  String rating, String experience, String availability) {
        Map<String, Object> counselor = new HashMap<>();
        counselor.put("id", id);
        counselor.put("name", name);
        counselor.put("specialization", specialization);
        counselor.put("rating", rating);
        counselor.put("experience", experience);
        counselor.put("availability", availability);
        // Generate avatar initials
        String[] nameParts = name.split(" ");
        String avatar = nameParts[0].substring(0, 1) + nameParts[nameParts.length - 1].substring(0, 1);
        counselor.put("avatar", avatar);
        return counselor;
    }

    @PostMapping("/telehealth/book")
    public String processBooking(
            @RequestParam("counselorId") String counselorId,
            @RequestParam("counselorName") String counselorName,
            @RequestParam("date") String date,
            @RequestParam("time") String time,
            @RequestParam("sessionType") String sessionType,
            HttpSession session) {
        
        // Get existing appointments or create new list
        @SuppressWarnings("unchecked")
        List<Map<String, String>> bookedAppointments = 
            (List<Map<String, String>>) session.getAttribute("bookedAppointments");
        
        if (bookedAppointments == null) {
            bookedAppointments = new ArrayList<>();
        }
        
        // Create new appointment
        Map<String, String> appointment = new HashMap<>();
        appointment.put("id", UUID.randomUUID().toString());
        appointment.put("counselorId", counselorId);
        appointment.put("counselorName", counselorName);
        appointment.put("date", date);
        appointment.put("time", time);
        appointment.put("sessionType", sessionType);
        appointment.put("status", "confirmed");
        
        bookedAppointments.add(appointment);
        session.setAttribute("bookedAppointments", bookedAppointments);
        
        return "redirect:/student/dashboard";
    }

    @PostMapping("/telehealth/cancel")
    public String cancelAppointment(@RequestParam("appointmentId") String appointmentId, HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Map<String, String>> bookedAppointments = 
            (List<Map<String, String>>) session.getAttribute("bookedAppointments");
            
        if (bookedAppointments != null) {
            // Remove the appointment with the matching ID
            bookedAppointments.removeIf(app -> 
                app.get("id") != null && app.get("id").equals(appointmentId)
            );
            session.setAttribute("bookedAppointments", bookedAppointments);
        }
        
        return "redirect:/student/dashboard";
    }

    @GetMapping("/telehealth/my-appointments")
    public String telehealthMyAppointments(Model model, HttpSession session) {
        model.addAttribute("role", "student");
        
        @SuppressWarnings("unchecked")
        List<Map<String, String>> bookedAppointments = 
            (List<Map<String, String>>) session.getAttribute("bookedAppointments");
        
        if (bookedAppointments == null) {
            bookedAppointments = new ArrayList<>();
        }
        
        model.addAttribute("bookedAppointments", bookedAppointments);
        
        return "student/telehealth-my-appointments";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("role", "student");
        return "student/profile"; // Create this JSP placeholder
    }

}