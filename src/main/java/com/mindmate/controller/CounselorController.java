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

    // Static Content Store (Kept from your original code)
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
    @Transactional // ✅ Keep session open for lazy loading
    public String showDashboard(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("user", SessionHelper.getUserName(session));

        // Use DB Query instead of loading ALL appointments
        List<Appointment> myAppointments = appointmentDAO.findByCounselor(counselor);

        // Force initialize Student data for all loaded appointments
        for (Appointment apt : myAppointments) {
            if (apt.getStudent() != null) {
                apt.getStudent().getName(); // Touches the proxy to load data
            }
        }

        // Stats
        LocalDate today = LocalDate.now();
        long todayCount = myAppointments.stream().filter(a -> a.getDate().isEqual(today)).count();
        long pendingCount = myAppointments.stream().filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING).count();

        model.addAttribute("todayCount", todayCount);
        model.addAttribute("pendingCount", pendingCount);
        
        // Fetch Today's Specific List
        List<Appointment> todayAppointments = appointmentDAO.findByCounselorAndDate(counselor, today);
        // Force initialize Student data for today's list
        for (Appointment apt : todayAppointments) {
            if (apt.getStudent() != null) {
                apt.getStudent().getName();
            }
        }
        model.addAttribute("todayAppointments", todayAppointments);
        
        // Filter pending list for view
        List<Appointment> pendingList = myAppointments.stream()
                .filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING)
                .limit(3)
                .collect(Collectors.toList());
        
        model.addAttribute("pendingAppointments", pendingList);

        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    @Transactional // ✅ Keep session open for lazy loading
    public String showSchedule(Model model, HttpSession session, 
                               @RequestParam(required = false) String date) { // ✅ NEW: Date param
        
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        model.addAttribute("role", "counselor");

        // 1. Determine Date (Selected or Today)
        LocalDate selectedDate;
        if (date != null && !date.isEmpty()) {
            selectedDate = LocalDate.parse(date);
        } else {
            selectedDate = LocalDate.now();
        }

        // 2. Fetch Pending (Always show all pending)
        List<Appointment> pendingAppointments = appointmentDAO.findByCounselorAndStatus(
                counselor, Appointment.AppointmentStatus.PENDING);

        // 3. Fetch Selected Date Appointments
        List<Appointment> dailyAppointments = appointmentDAO.findByCounselorAndDate(
                counselor, selectedDate);

        // Force initialize Student data
        for (Appointment apt : pendingAppointments) {
            if (apt.getStudent() != null) apt.getStudent().getName();
        }
        for (Appointment apt : dailyAppointments) {
            if (apt.getStudent() != null) apt.getStudent().getName();
        }

        model.addAttribute("pendingAppointments", pendingAppointments);
        model.addAttribute("todayAppointments", dailyAppointments); // Reusing variable name for JSP compatibility
        model.addAttribute("selectedDate", selectedDate); // ✅ Pass the date object

        return "counselor/schedule";
    }

    @PostMapping("/appointment/approve")
    @Transactional
    public String approveAppointment(@RequestParam Long appointmentId, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            
            // Validation: Exists + Belongs to this counselor + Is Pending
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
            
            // Validation
            if (apt != null && 
                apt.getCounselor() != null && 
                apt.getCounselor().getId().equals(counselor.getId()) &&
                apt.getStatus() == Appointment.AppointmentStatus.PENDING) {
                
                // ✅ FIXED: Set status to DENIED (not CANCELLED) to match logic
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
    // EXISTING CONTENT & PROFILE METHODS (UNCHANGED)
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