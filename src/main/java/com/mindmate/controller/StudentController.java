// src/main/java/com/mindmate/controller/StudentController.java

package com.mindmate.controller;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.service.AppointmentService;
import com.mindmate.service.CounselorService;
import com.mindmate.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 * Controller for student-facing features.
 * Handles dashboard, library, and telehealth appointment management.
 * 
 * @author Samy (A23CS0246) - Telehealth Module
 */
@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private CounselorService counselorService;

    @Autowired
    private StudentRepository studentRepository;

    /**
     * Displays student dashboard with booked appointments.
     * 
     * @param model Spring MVC model
     * @param session HTTP session for user state
     * @return View name for dashboard JSP
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        model.addAttribute("role", "student");
        
        Student student = getLoggedInStudent(session);
        
        if (student != null) {
            List<Appointment> appointments = appointmentService.getStudentAppointments(student.getId());
            model.addAttribute("bookedAppointments", appointments);
        }
        
        return "student/dashboard";
    }

    /**
     * Displays content library page.
     * 
     * @param model Spring MVC model
     * @return View name for library JSP
     */
    @GetMapping("/library")
    public String contentLibrary(Model model) {
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    // ============================================
    // TELEHEALTH APPOINTMENT BOOKING MODULE
    // ============================================

    /**
     * Displays telehealth booking page with available counselors.
     * 
     * @param model Spring MVC model
     * @return View name for booking form JSP
     */
    @GetMapping("/telehealth")
    public String showBookingPage(Model model) {
        model.addAttribute("role", "student");
        
        // Load all counselors from database via service layer
        List<Counselor> counselors = counselorService.getAllCounselors();
        model.addAttribute("counselors", counselors);
        
        return "student/telehealth-book";
    }

    /**
     * Processes telehealth appointment booking.
     * Creates new appointment record in database.
     * 
     * @param counselorId ID of selected counselor
     * @param counselorName Name of selected counselor
     * @param dateStr Appointment date (format: "MMM dd, yyyy")
     * @param timeStr Appointment time (format: "HH:mm")
     * @param sessionType Type of session being booked
     * @param session HTTP session for user state
     * @return Redirect to dashboard with success message
     */
    @PostMapping("/telehealth/book")
    public String processBooking(
            @RequestParam("counselorId") Long counselorId,
            @RequestParam("counselorName") String counselorName,
            @RequestParam("date") String dateStr,
            @RequestParam("time") String timeStr,
            @RequestParam("sessionType") String sessionType,
            HttpSession session) {
        
        Student student = getLoggedInStudent(session);
        
        if (student != null) {
            // Delegate business logic to service layer
            appointmentService.bookAppointment(
                student.getId(), 
                counselorName, 
                dateStr, 
                timeStr, 
                sessionType
            );
        }
        
        return "redirect:/student/dashboard?success=true";
    }

    /**
     * Cancels an existing appointment.
     * 
     * @param appointmentId ID of appointment to cancel
     * @return Redirect to dashboard
     */
    @PostMapping("/telehealth/cancel")
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId) {
        appointmentService.cancelAppointment(appointmentId);
        return "redirect:/student/dashboard";
    }

    // ============================================
    // HELPER METHODS
    // ============================================

    /**
     * Retrieves the currently logged-in student.
     * For demo purposes, returns the first student in database.
     * 
     * TODO: Replace with proper authentication in Phase 3
     * 
     * @param session HTTP session
     * @return Student entity
     */
    private Student getLoggedInStudent(HttpSession session) {
        return studentRepository.findAll().stream()
                .findFirst()
                .orElseGet(() -> {
                    Student newStudent = new Student("Demo Student", "demo@example.com");
                    return studentRepository.save(newStudent);
                });
    }
}