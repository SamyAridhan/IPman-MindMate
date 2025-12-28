package com.mindmate.controller;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Controller for student-facing features.
 * Handles dashboard, library, and telehealth with embedded business logic.
 * * @author Samy (A23CS0246) - Telehealth Module
 */
@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private StudentDAO studentDAO;

    /**
     * Displays student dashboard with booked appointments.
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        model.addAttribute("role", "student");
        
        Student student = getLoggedInStudent(session);
        
        if (student != null) {
            List<Appointment> appointments = appointmentDAO.findByStudentOrderByDateDesc(student);
            model.addAttribute("bookedAppointments", appointments);
        }
        
        return "student/dashboard";
    }

    /**
     * Displays content library page.
     */
    @GetMapping("/library")
    public String contentLibrary(Model model) {
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    // ============================================
    // TELEHEALTH MODULE - Business Logic Embedded
    // ============================================

    /**
     * Displays telehealth booking page with available counselors.
     */
    @GetMapping("/telehealth")
    public String showBookingPage(Model model) {
        model.addAttribute("role", "student");
        
        // Fetch counselors directly from DAO
        List<Counselor> counselors = counselorDAO.findAll();
        model.addAttribute("counselors", counselors);
        
        return "student/telehealth-book";
    }

    /**
     * Processes telehealth appointment booking.
     * Contains all business logic inline.
     */
    @PostMapping("/telehealth/book")
    @Transactional
    public String processBooking(
            @RequestParam("counselorId") Long counselorId,
            @RequestParam("counselorName") String counselorName,
            @RequestParam("date") String dateStr,
            @RequestParam("time") String timeStr,
            @RequestParam("sessionType") String sessionType,
            HttpSession session) {
        
        Student student = getLoggedInStudent(session);
        
        if (student == null) {
            return "redirect:/login?error=notloggedin";
        }
        
        try {
            // Business Logic: Create appointment
            Appointment appointment = new Appointment();
            appointment.setStudent(student);
            appointment.setCounselorName(counselorName);
            
            // Parse date (format: "Dec 03, 2025")
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
            appointment.setDate(LocalDate.parse(dateStr, dateFormatter));
            
            // Parse time (format: "14:00")
            appointment.setTime(LocalTime.parse(timeStr));
            
            appointment.setSessionType(sessionType);
            appointment.setStatus(Appointment.AppointmentStatus.PENDING);
            
            // Persist via DAO
            appointmentDAO.save(appointment);
            
            return "redirect:/student/dashboard?success=true";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/student/telehealth?error=bookingfailed";
        }
    }

    /**
     * Cancels an existing appointment.
     */
    @PostMapping("/telehealth/cancel")
    @Transactional
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId) {
        
        if (!appointmentDAO.existsById(appointmentId)) {
            return "redirect:/student/dashboard?error=notfound";
        }
        
        appointmentDAO.delete(appointmentId);
        return "redirect:/student/dashboard";
    }

    // ============================================
    // HELPER METHODS
    // ============================================

    /**
     * Retrieves the currently logged-in student.
     * For demo: returns first student or creates one.
     * * TODO: Replace with proper authentication in Phase 3
     */
    private Student getLoggedInStudent(HttpSession session) {
        List<Student> students = studentDAO.findAll();
        
        if (!students.isEmpty()) {
            return students.get(0);
        }
        
        // Create demo student if none exists
        Student newStudent = new Student("Demo Student", "demo@example.com");
        studentDAO.save(newStudent);
        return newStudent;
    }
}