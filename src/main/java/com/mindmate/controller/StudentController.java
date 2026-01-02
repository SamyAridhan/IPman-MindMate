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
        
        // ✅ FIXED: Use Ascending order so upcoming appointments appear first
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

            if (appointmentDAO.existsByCounselorAndDateAndTime(counselor, date, time)) {
                log.warn("Slot unavailable for Counselor {}", counselorId);
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

            LocalTime start = LocalTime.of(9, 0);
            LocalTime end = LocalTime.of(17, 0);

            while (start.isBefore(end)) {
                if (!appointmentDAO.existsByCounselorAndDateAndTime(counselor, targetDate, start)) {
                    if (!targetDate.equals(LocalDate.now()) || start.isAfter(LocalTime.now())) {
                        availableSlots.add(start.toString());
                    }
                }
                start = start.plusHours(1);
            }
        } catch (Exception e) {
            log.error("Slot fetch error", e);
        }
        return availableSlots;
    }
}