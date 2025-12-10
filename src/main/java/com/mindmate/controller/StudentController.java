package com.mindmate.controller;

import com.mindmate.model.Appointment;
import com.mindmate.model.Student;
import com.mindmate.repository.AppointmentRepository;
import com.mindmate.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        model.addAttribute("role", "student");
        
        // Get logged-in student (demo: using session or first student)
        Student student = getLoggedInStudent(session);
        
        if (student != null) {
            List<Appointment> appointments = appointmentRepository.findByStudentOrderByDateDesc(student);
            model.addAttribute("bookedAppointments", appointments);
        }
        
        return "student/dashboard";
    }

    @GetMapping("/library")
    public String contentLibrary(Model model) {
        model.addAttribute("role", "student");
        return "student/content-library";
    }

    @PostMapping("/telehealth/book")
    public String processBooking(
            @RequestParam("counselorId") String counselorId,
            @RequestParam("counselorName") String counselorName,
            @RequestParam("date") String dateStr,
            @RequestParam("time") String timeStr,
            @RequestParam("sessionType") String sessionType,
            HttpSession session) {
        
        Student student = getLoggedInStudent(session);
        
        if (student != null) {
            Appointment appointment = new Appointment();
            appointment.setStudent(student);
            appointment.setCounselorName(counselorName);
            appointment.setDate(LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("MMM dd, yyyy")));
            appointment.setTime(LocalTime.parse(timeStr));
            appointment.setSessionType(sessionType);
            appointment.setStatus(Appointment.AppointmentStatus.CONFIRMED);
            
            appointmentRepository.save(appointment);
        }
        
        return "redirect:/student/dashboard";
    }

    @PostMapping("/telehealth/cancel")
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId, HttpSession session) {
        appointmentRepository.deleteById(appointmentId);
        return "redirect:/student/dashboard";
    }

    // Helper method to get logged-in student
    private Student getLoggedInStudent(HttpSession session) {
        // Demo: Get first student or create one
        return studentRepository.findAll().stream()
                .findFirst()
                .orElseGet(() -> {
                    Student newStudent = new Student("Demo Student", "demo@example.com");
                    return studentRepository.save(newStudent);
                });
    }
}