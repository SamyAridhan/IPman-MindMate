package com.mindmate.controller;

import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
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
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH);

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private StudentDAO studentDAO;

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
        
        List<Appointment> appointments = appointmentDAO.findByStudentOrderByDateAscTimeAsc(student);
        model.addAttribute("bookedAppointments", appointments);
        
        return "student/dashboard";
    }

    @GetMapping("/library")
    public String contentLibrary(Model model, HttpSession session) {
        if (getLoggedInStudent(session) == null) return "redirect:/login";
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    @GetMapping("/telehealth")
    public String showBookingPage(Model model, HttpSession session) {
        if (getLoggedInStudent(session) == null) return "redirect:/login";
        model.addAttribute("role", "student");
        List<Counselor> counselors = counselorDAO.findAll();
        model.addAttribute("counselors", counselors);
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

            // ============================================================
            // ✅ NEW LOGIC: Realistic Slots with Lunch Gap & Variations
            // ============================================================
            List<LocalTime> potentialSlots = new ArrayList<>();

            if (counselorId % 2 != 0) { 
                // PATTERN A (Odd IDs): "Early Bird"
                // 8:30 - 10:00
                // 10:00 - 11:30
                // 11:30 - 13:00 (Lunch starts at 13:00)
                // --- LUNCH ---
                // 14:00 - 15:30
                // 15:30 - 17:00
                potentialSlots.add(LocalTime.of(8, 30));
                potentialSlots.add(LocalTime.of(10, 0));
                potentialSlots.add(LocalTime.of(11, 30));
                potentialSlots.add(LocalTime.of(14, 0));
                potentialSlots.add(LocalTime.of(15, 30));
            } else {
                // PATTERN B (Even IDs): "Standard"
                // 9:00 - 10:30
                // 10:30 - 12:00
                // --- LUNCH GAP (12:00 - 14:30) --- 
                // (We skip 12:00 because it ends at 13:30, cutting into lunch)
                // 14:30 - 16:00
                // 16:00 - 17:30
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
                // 1. Check if already booked
                if (!bookedTimes.contains(slot)) {
                    // 2. Check if past time (Only for TODAY)
                    // If targetDate is today, slot must be in the future
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

            // ROBUST CLASH CHECK
            List<Appointment> dayAppointments = appointmentDAO.findByCounselorAndDate(counselor, date);
            
            boolean slotTaken = dayAppointments.stream()
                .anyMatch(a -> a.getTime().equals(time) && 
                               a.getStatus() != Appointment.AppointmentStatus.CANCELLED && 
                               a.getStatus() != Appointment.AppointmentStatus.DENIED);

            if (slotTaken) {
                log.warn("Slot {} at {} for Counselor {} is already taken", date, time, counselorId);
                return "redirect:/student/telehealth?error=unavailable";
            }

            // Proceed to Book
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

    // ... Other existing methods (Cancel, Acknowledge, Profile) remain unchanged ...
    @PostMapping("/telehealth/cancel")
    @Transactional
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        try {
            Appointment apt = appointmentDAO.findById(appointmentId);
            if (apt != null && apt.getStudent().getId().equals(student.getId()) &&
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
            if (apt != null && apt.getStudent().getId().equals(student.getId()) &&
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