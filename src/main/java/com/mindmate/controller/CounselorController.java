package com.mindmate.controller;

import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.model.Appointment;
import com.mindmate.model.Content;
import com.mindmate.model.Counselor;
import com.mindmate.util.SessionHelper; 

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static final Logger log = LoggerFactory.getLogger(CounselorController.class);

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    // Static Content Store
    private static final Map<Long, Content> CONTENT_STORE = new LinkedHashMap<>();
    private static final AtomicLong CONTENT_ID_COUNTER = new AtomicLong(1);

    static {
        CONTENT_STORE.put(1L, new Content(1L, "Stress Management 101", "Article", "Learn effective stress-coping strategies", ""));
        CONTENT_STORE.put(2L, new Content(2L, "Mindfulness Meditation", "Video", "15-minute guided meditation", ""));
        CONTENT_ID_COUNTER.set(3);
    }

    private Counselor getLoggedInCounselor(HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null || !"counselor".equals(SessionHelper.getRole(session))) {
            return null;
        }
        return counselorDAO.findById(userId);
    }

    @GetMapping("/dashboard")
    @Transactional
    public String showDashboard(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("user", SessionHelper.getUserName(session));

        // 1. Fetch Today's Date
        LocalDate today = LocalDate.now();

        // 2. Fetch Raw List for Today
        List<Appointment> allToday = appointmentDAO.findByCounselorAndDate(counselor, today);

        // 3. ✅ FILTER: Only show Upcoming/Actionable (Confirmed or Pending)
        // We exclude Cancelled, Denied, Acknowledged, and Completed from the Dashboard view
        List<Appointment> actionableToday = allToday.stream()
                .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CONFIRMED || 
                             a.getStatus() == Appointment.AppointmentStatus.PENDING)
                .collect(Collectors.toList());

        // Force initialize Student data
        for (Appointment apt : actionableToday) {
            if (apt.getStudent() != null) apt.getStudent().getName();
        }

        // 4. Update Metrics to match the filtered view
        // "Today's Appointments" count now reflects only what is on the user's plate
        model.addAttribute("todayCount", actionableToday.size());
        
        // "Pending Requests" (Global count, not just today)
        // Using findByCounselorAndStatus to get the accurate count for this specific counselor
        List<Appointment> allPending = appointmentDAO.findByCounselorAndStatus(counselor, Appointment.AppointmentStatus.PENDING);
        model.addAttribute("pendingCount", allPending.size());

        model.addAttribute("todayAppointments", actionableToday);

        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    @Transactional
    public String showSchedule(Model model, HttpSession session, 
                               @RequestParam(required = false) String date) {
        
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");

        // 1. Determine Date
        LocalDate selectedDate;
        if (date != null && !date.isEmpty()) {
            selectedDate = LocalDate.parse(date);
        } else {
            selectedDate = LocalDate.now();
        }

        // 2. Fetch Pending (Global)
        List<Appointment> pendingAppointments = appointmentDAO.findByCounselorAndStatus(
                counselor, Appointment.AppointmentStatus.PENDING);

        // 3. Fetch Selected Date Appointments (ALL Statuses shown here for history)
        List<Appointment> dailyAppointments = appointmentDAO.findByCounselorAndDate(
                counselor, selectedDate);

        // Force initialize
        for (Appointment apt : pendingAppointments) {
            if (apt.getStudent() != null) apt.getStudent().getName();
        }
        for (Appointment apt : dailyAppointments) {
            if (apt.getStudent() != null) apt.getStudent().getName();
        }

        model.addAttribute("pendingAppointments", pendingAppointments);
        model.addAttribute("todayAppointments", dailyAppointments);
        model.addAttribute("selectedDate", selectedDate);

        return "counselor/schedule";
    }

    @PostMapping("/appointment/approve")
    @Transactional
    public String approveAppointment(@RequestParam Long appointmentId, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            
            if (apt != null && 
                apt.getCounselor() != null && 
                apt.getCounselor().getId().equals(counselor.getId()) &&
                apt.getStatus() == Appointment.AppointmentStatus.PENDING) {
                
                apt.setStatus(Appointment.AppointmentStatus.CONFIRMED);
                appointmentDAO.update(apt);
                log.info("Counselor {} approved Appointment {}", counselor.getId(), appointmentId);
            }
        } catch (Exception e) {
            log.error("Error approving appointment", e);
        }
        // Redirect back to the referring page (Dashboard or Schedule) if possible, or default to schedule
        // For simplicity, let's redirect to schedule as it handles dates better
        return "redirect:/counselor/schedule"; 
    }

    @PostMapping("/appointment/deny")
    @Transactional
    public String denyAppointment(
            @RequestParam Long appointmentId, 
            @RequestParam(required = false) String reason, 
            HttpSession session) {
        
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            
            if (apt != null && 
                apt.getCounselor() != null && 
                apt.getCounselor().getId().equals(counselor.getId()) &&
                apt.getStatus() == Appointment.AppointmentStatus.PENDING) {
                
                apt.setStatus(Appointment.AppointmentStatus.DENIED);
                apt.setDenialReason(reason != null ? reason : "No reason provided");
                appointmentDAO.update(apt);
                log.info("Counselor {} denied Appointment {}", counselor.getId(), appointmentId);
            }
        } catch (Exception e) {
            log.error("Error denying appointment", e);
        }
        return "redirect:/counselor/schedule";
    }

    // ==========================================
    // CONTENT & PROFILE METHODS
    // ==========================================

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