package com.mindmate.controller;

import com.mindmate.dao.AssessmentDAO;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.EducationalContentDAO; // From Team Member
import com.mindmate.dao.StudentProgressDAO;   // From Team Member
import com.mindmate.model.Assessment;
import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.model.EducationalContent; // From Team Member
import com.mindmate.util.SessionHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class StudentController {

    private static final Logger log = LoggerFactory.getLogger(StudentController.class);
    // Explicit Locale ensures consistent parsing regardless of server settings
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH);

    @Autowired
    private AssessmentDAO assessmentDAO;

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private StudentDAO studentDAO;

    // ✅ MERGED: Added Team Member's DAOs
    @Autowired
    private EducationalContentDAO contentDAO;

    @Autowired
    private StudentProgressDAO progressDAO;

    private Student getLoggedInStudent(HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null || !"student".equals(SessionHelper.getRole(session))) {
            return null;
        }
        return studentDAO.findById(userId);
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("user", SessionHelper.getUserName(session));
        
        // ✅ KEPT YOUR LOGIC: Using Ascending order for upcoming appointments
        List<Appointment> appointments = appointmentDAO.findByStudentOrderByDateAscTimeAsc(student);
        model.addAttribute("bookedAppointments", appointments);

        // --- ✅ NEW ADDITION: Assessment History ---
        // Fetch the list of past assessments for this student
        List<Assessment> history = assessmentDAO.findByStudent(student);
        model.addAttribute("assessmentHistory", history);
        
        Assessment latest = null;
        if (history != null && !history.isEmpty()) {
            // Since the list is sorted ASC (Oldest -> Newest), the last one is the latest
            latest = history.get(history.size() - 1);
        }
        model.addAttribute("latestAssessment", latest);
        
        return "student/dashboard";
    }

    // ==========================================
    // 📚 EDUCATIONAL CONTENT (Team Member's Logic)
    // ==========================================

    @GetMapping("/library")
    public String contentLibrary(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        
        // ✅ MERGED: Loading modules and progress from Team Member's code
        model.addAttribute("modules", contentDAO.findAll());
        model.addAttribute("progressList", progressDAO.getProgressByStudent(student.getId()));

        return "student/content-library";
    }

    @GetMapping("/view-module")
    public String viewModule(@RequestParam Long id, Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        EducationalContent content = contentDAO.findById(id);
        boolean isDone = progressDAO.isModuleCompleted(student.getId(), id);

        model.addAttribute("content", content);
        model.addAttribute("isCompleted", isDone);
        model.addAttribute("role", "student");

        return "student/content-view";
    }

    @PostMapping("/content/complete")
    @Transactional
    public String completeModule(@RequestParam Long contentId, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        // Check if already completed to prevent double point awarding
        if (!progressDAO.isModuleCompleted(student.getId(), contentId)) {
            EducationalContent content = contentDAO.findById(contentId);

            // Mark progress
            progressDAO.markAsComplete(student.getId(), contentId);

            // Update points and streak
            studentDAO.updatePointsAndStreak(student.getId(), content.getPointsValue());
        }

        return "redirect:/student/view-module?id=" + contentId + "&completed=true";
    }

    @GetMapping("/progress")
    public String myProgress(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("student", student);
        model.addAttribute("completedModules", progressDAO.getProgressByStudent(student.getId()));
        model.addAttribute("role", "student");

        return "student/my-progress";
    }

    // ==========================================
    // 🏥 TELEHEALTH (Your Robust Logic)
    // ==========================================

    @GetMapping("/telehealth")
    public String showBookingPage(Model model, HttpSession session) {
        if (getLoggedInStudent(session) == null) return "redirect:/login";
        model.addAttribute("role", "student");
        List<Counselor> counselors = counselorDAO.findAll();
        model.addAttribute("counselors", counselors);
        // ✅ KEPT YOUR LOGIC: Passing currentDate for JS validation
        model.addAttribute("currentDate", LocalDate.now());
        return "student/telehealth-book";
    }

    @GetMapping("/telehealth/available-slots")
    @ResponseBody
    @Transactional
    public List<String> getAvailableSlots(
            @RequestParam Long counselorId,
            @RequestParam String date,
            HttpSession session) {
        
        List<String> availableSlots = new ArrayList<>();
        if (getLoggedInStudent(session) == null) return availableSlots;
        
        try {
            Counselor counselor = counselorDAO.findById(counselorId);
            LocalDate targetDate = LocalDate.parse(date, DATE_FORMATTER);

            // ✅ KEPT YOUR LOGIC: Realistic Slots with Lunch Gap & Variations
            List<LocalTime> potentialSlots = new ArrayList<>();

            if (counselorId % 2 != 0) { 
                // Pattern A (Odd IDs): "Early Bird"
                potentialSlots.add(LocalTime.of(8, 30));
                potentialSlots.add(LocalTime.of(10, 0));
                potentialSlots.add(LocalTime.of(11, 30));
                potentialSlots.add(LocalTime.of(14, 0));
                potentialSlots.add(LocalTime.of(15, 30));
            } else {
                // Pattern B (Even IDs): "Standard"
                potentialSlots.add(LocalTime.of(9, 0));
                potentialSlots.add(LocalTime.of(10, 30));
                potentialSlots.add(LocalTime.of(14, 30));
                potentialSlots.add(LocalTime.of(16, 0));
            }

            // Get existing bookings to filter them out
            List<Appointment> booked = appointmentDAO.findByCounselorAndDate(counselor, targetDate);
            List<LocalTime> bookedTimes = booked.stream()
                .filter(a -> a.getStatus() != Appointment.AppointmentStatus.CANCELLED && 
                             a.getStatus() != Appointment.AppointmentStatus.DENIED)
                .map(Appointment::getTime)
                .collect(Collectors.toList());

            // Process Slots
            for (LocalTime slot : potentialSlots) {
                if (!bookedTimes.contains(slot)) {
                    if (!targetDate.equals(LocalDate.now()) || slot.isAfter(LocalTime.now())) {
                        availableSlots.add(slot.toString());
                    }
                }
            }

        } catch (Exception e) {
            log.error("Slot fetch error", e);
        }
        return availableSlots;
    }

    @PostMapping("/telehealth/book")
    @Transactional
    public String processBooking(
            @RequestParam("counselorId") Long counselorId,
            @RequestParam("date") String dateStr,
            @RequestParam("time") String timeStr,
            @RequestParam("sessionType") String sessionType,
            @RequestParam(value = "notes", required = false) String notes,
            HttpSession session) {
        
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login?error=notloggedin";
        
        try {
            Counselor counselor = counselorDAO.findById(counselorId);
            if (counselor == null) return "redirect:/student/telehealth?error=system";

            LocalDate date = LocalDate.parse(dateStr, DATE_FORMATTER);
            LocalTime time = LocalTime.parse(timeStr);

            if (date.isBefore(LocalDate.now())) {
                log.warn("Student {} tried booking in past", student.getId());
                return "redirect:/student/telehealth?error=invaliddate";
            }

            // ✅ KEPT YOUR LOGIC: Robust Clash Check
            List<Appointment> dayAppointments = appointmentDAO.findByCounselorAndDate(counselor, date);
            
            boolean slotTaken = dayAppointments.stream()
                .anyMatch(a -> a.getTime().equals(time) && 
                               a.getStatus() != Appointment.AppointmentStatus.CANCELLED && 
                               a.getStatus() != Appointment.AppointmentStatus.DENIED);

            if (slotTaken) {
                log.warn("Slot {} at {} for Counselor {} is already taken", date, time, counselorId);
                return "redirect:/student/telehealth?error=unavailable";
            }

            Appointment appointment = new Appointment();
            appointment.setStudent(student);
            appointment.setCounselor(counselor);
            appointment.setCounselorName(counselor.getName());
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setSessionType(sessionType);
            appointment.setNotes(notes);
            appointment.setStatus(Appointment.AppointmentStatus.PENDING);
            
            appointmentDAO.save(appointment);
            log.info("Appointment booked: ID {}", appointment.getId());
            return "redirect:/student/dashboard?success=true";
            
        } catch (DateTimeParseException e) {
            log.error("Date format error: {}", e.getMessage());
            return "redirect:/student/telehealth?error=invaliddate";
        } catch (Exception e) {
            log.error("Booking system error", e);
            return "redirect:/student/telehealth?error=bookingfailed";
        }
    }

    @PostMapping("/telehealth/cancel")
    @Transactional
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            
            if (apt != null && 
                apt.getStudent().getId().equals(student.getId()) &&
                apt.getStatus() != Appointment.AppointmentStatus.CANCELLED) {
                
                apt.setStatus(Appointment.AppointmentStatus.CANCELLED);
                appointmentDAO.update(apt);
                return "redirect:/student/dashboard?success=cancelled";
            }
        } catch (Exception e) {
            log.error("Cancellation error", e);
        }
        return "redirect:/student/dashboard?error=cantcancel";
    }

    @PostMapping("/telehealth/acknowledge")
    @Transactional
    public String acknowledgeAppointment(@RequestParam("appointmentId") Long appointmentId, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            
            if (apt != null && 
                apt.getStudent().getId().equals(student.getId()) &&
                (apt.getStatus() == Appointment.AppointmentStatus.DENIED || 
                 apt.getStatus() == Appointment.AppointmentStatus.REJECTED)) {
                
                apt.setStatus(Appointment.AppointmentStatus.ACKNOWLEDGED);
                appointmentDAO.update(apt);
                return "redirect:/student/dashboard?success=acknowledged";
            }
        } catch (Exception e) {
            log.error("Error acknowledging appointment", e);
        }
        return "redirect:/student/dashboard?error=failed";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        return "student/profile";
    }
}