package com.mindmate.controller;

import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.EducationalContentDAO;
import com.mindmate.dao.StudentProgressDAO;
import com.mindmate.model.Appointment;
import com.mindmate.model.EducationalContent;
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

    // ✅ MERGED: Added Team Member's DAOs
    @Autowired
    private EducationalContentDAO educationalContentDAO;

    @Autowired
    private StudentProgressDAO studentProgressDAO;

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
        if (counselor == null)
            return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("user", SessionHelper.getUserName(session));

        // 1. Fetch Today's Date
        LocalDate today = LocalDate.now();

        // 2. Fetch Raw List for Today
        List<Appointment> allToday = appointmentDAO.findByCounselorAndDate(counselor, today);

        // 3. FILTER: Only show Upcoming/Actionable (Confirmed or Pending)
        List<Appointment> actionableToday = allToday.stream()
                .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CONFIRMED ||
                        a.getStatus() == Appointment.AppointmentStatus.PENDING)
                .collect(Collectors.toList());

        // Force initialize Student data
        for (Appointment apt : actionableToday) {
            if (apt.getStudent() != null)
                apt.getStudent().getName();
        }

        // 4. Update Metrics
        model.addAttribute("todayCount", actionableToday.size());

        // "Pending Requests" (Global count)
        List<Appointment> allPending = appointmentDAO.findByCounselorAndStatus(counselor,
                Appointment.AppointmentStatus.PENDING);
        model.addAttribute("pendingCount", allPending.size());

        model.addAttribute("todayAppointments", actionableToday);

        return "counselor/dashboard";
    }

    @GetMapping("/schedule")
    @Transactional
    public String showSchedule(Model model, HttpSession session,
            @RequestParam(required = false) String date) {

        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

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

        // 3. Fetch Selected Date Appointments
        List<Appointment> dailyAppointments = appointmentDAO.findByCounselorAndDate(
                counselor, selectedDate);

        // Force initialize
        for (Appointment apt : pendingAppointments) {
            if (apt.getStudent() != null)
                apt.getStudent().getName();
        }
        for (Appointment apt : dailyAppointments) {
            if (apt.getStudent() != null)
                apt.getStudent().getName();
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
        if (counselor == null)
            return "redirect:/login";

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
        return "redirect:/counselor/schedule";
    }

    @PostMapping("/appointment/deny")
    @Transactional
    public String denyAppointment(
            @RequestParam Long appointmentId,
            @RequestParam(required = false) String reason,
            HttpSession session) {

        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

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

    // ✅ YOUR METHOD: Mark Appointment as Completed
    @PostMapping("/appointment/complete")
    @Transactional
    public String completeAppointment(@RequestParam Long appointmentId, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);

            // Validation: Exists + Belongs to counselor + Is currently CONFIRMED
            if (apt != null &&
                    apt.getCounselor() != null &&
                    apt.getCounselor().getId().equals(counselor.getId()) &&
                    apt.getStatus() == Appointment.AppointmentStatus.CONFIRMED) {

                apt.setStatus(Appointment.AppointmentStatus.COMPLETED);
                appointmentDAO.update(apt);
                log.info("Counselor {} marked Appointment {} as COMPLETED", counselor.getId(), appointmentId);
            }
        } catch (Exception e) {
            log.error("Error completing appointment", e);
        }
        // Redirecting to dashboard since that's where the "Today" list is most
        // prominent
        return "redirect:/counselor/dashboard";
    }

    // ==========================================
    // 📚 CONTENT MANAGEMENT (Team Member's Logic)
    // ==========================================

    @GetMapping("/content")
    public String manageContent(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

        model.addAttribute("role", "counselor");
        // Only show content created by this counselor
        List<EducationalContent> allContents = educationalContentDAO.findAll();
        List<EducationalContent> myContents = allContents.stream()
                .filter(c -> c.getAuthor() != null && c.getAuthor().getId().equals(counselor.getId()))
                .collect(Collectors.toList());
        model.addAttribute("contents", myContents);
        return "counselor/content-manager";
    }

    @PostMapping("/content/create")
    @Transactional
    public String createOrUpdateContent(
            @RequestParam String title,
            @RequestParam String contentType,
            @RequestParam String description,
            @RequestParam String content, // Matches articleContent or videoUrl from JSP
            @RequestParam Integer points,
            @RequestParam(required = false) Long editingId,
            HttpSession session) {

        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

        EducationalContent ec;
        if (editingId != null) {
            ec = educationalContentDAO.findById(editingId);
            // Authorization check: Only allow editing own content
            if (ec == null || ec.getAuthor() == null || !ec.getAuthor().getId().equals(counselor.getId())) {
                log.warn("Counselor {} attempted to edit content {} they don't own", counselor.getId(), editingId);
                return "redirect:/counselor/content";
            }
        } else {
            ec = new EducationalContent();
            ec.setAuthor(counselor);
        }

        if (ec != null) {
            ec.setTitle(title);
            ec.setContentType(contentType);
            ec.setDescription(description);
            ec.setContentBody(content);
            ec.setPointsValue(points);

            if (editingId != null)
                educationalContentDAO.update(ec);
            else
                educationalContentDAO.save(ec);
        }

        return "redirect:/counselor/content";
    }

    @PostMapping("/content/delete")
    @Transactional
    public String deleteContent(@RequestParam Long id, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

        // Authorization check: Only allow deleting own content
        EducationalContent ec = educationalContentDAO.findById(id);
        if (ec == null || ec.getAuthor() == null || !ec.getAuthor().getId().equals(counselor.getId())) {
            log.warn("Counselor {} attempted to delete content {} they don't own", counselor.getId(), id);
            return "redirect:/counselor/content";
        }

        // Delete all student progress records for this content first
        studentProgressDAO.deleteByContentId(id);
        // Then delete the content
        educationalContentDAO.delete(id);

        return "redirect:/counselor/content";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        Counselor counselor = getLoggedInCounselor(session);
        if (counselor == null)
            return "redirect:/login";

        model.addAttribute("role", "counselor");
        model.addAttribute("counselor", counselor);
        return "counselor/profile";
    }
}