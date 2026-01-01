//src/main/java/com/mindmate/controller/StudentController.java
package com.mindmate.controller;

import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.util.SessionHelper; // ✅ Keep using your Helper

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

@Controller
@RequestMapping("/student")
public class StudentController {

    private static final Logger log = LoggerFactory.getLogger(StudentController.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy");

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private StudentDAO studentDAO;

    /**
     * Helper to get full Student entity from Session
     */
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
        
        // ✅ Existing logic is fine here
        List<Appointment> appointments = appointmentDAO.findByStudentOrderByDateDesc(student);
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
        
        // ✅ NEW: Pass current date for calendar frontend
        model.addAttribute("currentDate", LocalDate.now());
        
        return "student/telehealth-book";
    }

    @PostMapping("/telehealth/book")
    @Transactional
    public String processBooking(
            @RequestParam("counselorId") Long counselorId,
            @RequestParam("date") String dateStr,
            @RequestParam("time") String timeStr,
            @RequestParam("sessionType") String sessionType,
            @RequestParam(value = "notes", required = false) String notes, // ✅ NEW: Notes
            HttpSession session) {
        
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login?error=notloggedin";
        
        try {
            // 1. Retrieve Entities
            Counselor counselor = counselorDAO.findById(counselorId);
            if (counselor == null) return "redirect:/student/telehealth?error=system";

            // 2. Parse Date/Time
            LocalDate date = LocalDate.parse(dateStr, DATE_FORMATTER);
            LocalTime time = LocalTime.parse(timeStr);

            // 3. Validation: Past Date
            if (date.isBefore(LocalDate.now())) {
                log.warn("Student {} tried booking in past", student.getId());
                return "redirect:/student/telehealth?error=invaliddate";
            }

            // 4. Validation: Double Booking (The "System" Logic)
            if (appointmentDAO.existsByCounselorAndDateAndTime(counselor, date, time)) {
                log.warn("Slot unavailable for Counselor {}", counselorId);
                return "redirect:/student/telehealth?error=unavailable";
            }

            // 5. Create Appointment
            Appointment appointment = new Appointment();
            appointment.setStudent(student);
            appointment.setCounselor(counselor); // ✅ Link Entity
            appointment.setCounselorName(counselor.getName()); // ✅ Backwards compatibility
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setSessionType(sessionType);
            appointment.setNotes(notes);
            appointment.setStatus(Appointment.AppointmentStatus.PENDING);
            
            appointmentDAO.save(appointment);
            
            log.info("Appointment booked: ID {}", appointment.getId());
            return "redirect:/student/dashboard?success=true";
            
        } catch (DateTimeParseException e) {
            log.error("Date format error", e);
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
            
            // ✅ Validation: Exists + Owned by Student + Not already cancelled
            if (apt != null && 
                apt.getStudent().getId().equals(student.getId()) &&
                apt.getStatus() != Appointment.AppointmentStatus.CANCELLED) {
                
                // Logic: Prefer marking CANCELLED over deleting record
                apt.setStatus(Appointment.AppointmentStatus.CANCELLED);
                appointmentDAO.update(apt);
                
                return "redirect:/student/dashboard?success=cancelled";
            }
        } catch (Exception e) {
            log.error("Cancellation error", e);
        }
        return "redirect:/student/dashboard?error=cantcancel";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        return "student/profile";
    }

    // ✅ NEW: AJAX Endpoint for Time Slots (Integrated from Service)
    @GetMapping("/telehealth/available-slots")
    @ResponseBody
    public List<String> getAvailableSlots(
            @RequestParam Long counselorId,
            @RequestParam String date,
            HttpSession session) {
        
        List<String> availableSlots = new ArrayList<>();
        if (getLoggedInStudent(session) == null) return availableSlots;
        
        try {
            Counselor counselor = counselorDAO.findById(counselorId);
            LocalDate targetDate = LocalDate.parse(date, DATE_FORMATTER);

            // Logic: Default 9 AM - 5 PM schedule
            LocalTime start = LocalTime.of(9, 0);
            LocalTime end = LocalTime.of(17, 0);

            while (start.isBefore(end)) {
                // Check database if this specific slot is taken
                if (!appointmentDAO.existsByCounselorAndDateAndTime(counselor, targetDate, start)) {
                    // Logic: If today, don't show past hours
                    if (!targetDate.equals(LocalDate.now()) || start.isAfter(LocalTime.now())) {
                        availableSlots.add(start.toString());
                    }
                }
                start = start.plusHours(1); // 60 min sessions
            }
        } catch (Exception e) {
            log.error("Slot fetch error", e);
        }
        return availableSlots;
    }
}