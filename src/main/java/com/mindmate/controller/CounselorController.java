package com.mindmate.controller;

import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.model.Appointment;
import com.mindmate.model.Content;
import com.mindmate.model.Counselor;
import com.mindmate.util.SessionHelper; // ✅ Using Helper

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/counselor")
public class CounselorController {

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    // Static Content Store (Mock)
    private static final Map<Long, Content> CONTENT_STORE = new LinkedHashMap<>();
    private static final AtomicLong CONTENT_ID_COUNTER = new AtomicLong(1);

    static {
        CONTENT_STORE.put(1L, new Content(1L, "Stress Management 101", "Article", "Learn effective stress-coping strategies", ""));
        CONTENT_STORE.put(2L, new Content(2L, "Mindfulness Meditation", "Video", "15-minute guided meditation", ""));
        CONTENT_ID_COUNTER.set(3);
    }

    /**
     * Retrieves logged-in counselor using SessionHelper.
     */
    private Counselor getLoggedInCounselor(HttpSession session) {
        Long userId = SessionHelper.getUserId(session); // ✅ Clean & Consistent
        if (userId == null || !"counselor".equals(SessionHelper.getRole(session))) {
            return null;
        }
        return counselorDAO.findById(userId);
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("user", SessionHelper.getUserName(session)); // ✅ Using Helper

        // Fetch & Filter Appointments
        List<Appointment> allAppointments = appointmentDAO.findAll();
        List<Appointment> myAppointments = allAppointments.stream()
                .filter(a -> a.getCounselorName() != null && a.getCounselorName().contains(counselor.getName()))
                .collect(Collectors.toList());

        // Stats
        LocalDate today = LocalDate.now();
        long todayCount = myAppointments.stream().filter(a -> a.getDate().isEqual(today)).count();
        long pendingCount = myAppointments.stream().filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING).count();

        model.addAttribute("todayCount", todayCount);
        model.addAttribute("pendingCount", pendingCount);
        
        model.addAttribute("todayAppointments", myAppointments.stream()
                .filter(a -> a.getDate().isEqual(today))
                .collect(Collectors.toList()));
                
        model.addAttribute("pendingAppointments", myAppointments.stream()
                .filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING)
                .limit(3)
                .collect(Collectors.toList()));

        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    public String showSchedule(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");

        List<Appointment> allAppointments = appointmentDAO.findAll();
        List<Appointment> myAppointments = allAppointments.stream()
                .filter(a -> a.getCounselorName() != null && a.getCounselorName().contains(counselor.getName()))
                .collect(Collectors.toList());

        model.addAttribute("pendingAppointments", myAppointments.stream()
                .filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING)
                .collect(Collectors.toList()));

        model.addAttribute("todayAppointments", myAppointments.stream()
                .filter(a -> a.getDate().isEqual(LocalDate.now()))
                .collect(Collectors.toList()));

        model.addAttribute("selectedDate", LocalDate.now().toString());

        return "counselor/schedule";
    }

    @PostMapping("/appointment/approve")
    @Transactional
    public String approveAppointment(@RequestParam Long appointmentId, HttpSession session) {
        if (getLoggedInCounselor(session) == null) return "redirect:/login";

        Appointment apt = appointmentDAO.findById(appointmentId);
        if (apt != null) {
            apt.setStatus(Appointment.AppointmentStatus.CONFIRMED);
            appointmentDAO.update(apt);
        }
        return "redirect:/counselor/schedule";
    }

    @PostMapping("/appointment/deny")
    @Transactional
    public String denyAppointment(@RequestParam Long appointmentId, HttpSession session) {
        if (getLoggedInCounselor(session) == null) return "redirect:/login";

        Appointment apt = appointmentDAO.findById(appointmentId);
        if (apt != null) {
            apt.setStatus(Appointment.AppointmentStatus.CANCELLED);
            appointmentDAO.update(apt);
        }
        return "redirect:/counselor/schedule";
    }

    @GetMapping("/content")
    public String manageContent(Model model, HttpSession session) {
        if (getLoggedInCounselor(session) == null) return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("contents", new ArrayList<>(CONTENT_STORE.values()));
        return "counselor/content-manager";
    }

    @PostMapping("/content/create")
    public String createOrUpdateContent(
            @RequestParam String title,
            @RequestParam String contentType,
            @RequestParam String description,
            @RequestParam String content,
            @RequestParam(required = false) Long editingId,
            HttpSession session) {
        
        if (getLoggedInCounselor(session) == null) return "redirect:/login";

        if (editingId != null) {
            Content existing = CONTENT_STORE.get(editingId);
            if (existing != null) {
                existing.setTitle(title);
                existing.setType(contentType);
                existing.setDescription(description);
                existing.setContent(content);
            }
        } else {
            long id = CONTENT_ID_COUNTER.getAndIncrement();
            Content c = new Content(id, title, contentType, description, content);
            CONTENT_STORE.put(id, c);
        }
        return "redirect:/counselor/content";
    }

    @PostMapping("/content/delete")
    public String deleteContent(@RequestParam Long id, HttpSession session) {
        if (getLoggedInCounselor(session) == null) return "redirect:/login";
        CONTENT_STORE.remove(id);
        return "redirect:/counselor/content";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("counselor", counselor);
        return "counselor/profile";
    }
}