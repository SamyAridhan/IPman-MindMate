package com.mindmate.controller;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.model.EducationalContent;
import com.mindmate.model.StudentProgress;
import com.mindmate.util.SessionHelper; // ✅ Using Helper
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.EducationalContentDAO;
import com.mindmate.dao.StudentProgressDAO;

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

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private EducationalContentDAO contentDAO;

    @Autowired
    private StudentProgressDAO progressDAO;

    /**
     * Retrieves the logged-in student using SessionHelper.
     */
    private Student getLoggedInStudent(HttpSession session) {
        Long userId = SessionHelper.getUserId(session); // ✅ Clean & Consistent
        if (userId == null || !"student".equals(SessionHelper.getRole(session))) {
            return null;
        }
        return studentDAO.findById(userId);
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null)
            return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("user", SessionHelper.getUserName(session)); // ✅ Using Helper

        List<Appointment> appointments = appointmentDAO.findByStudentOrderByDateDesc(student);
        model.addAttribute("bookedAppointments", appointments);

        return "student/dashboard";
    }

    @GetMapping("/library")
    public String contentLibrary(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null)
            return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        model.addAttribute("modules", contentDAO.findAll());
        // We can use a helper method in the JSP to check if contentId is in student's
        // progress list
        model.addAttribute("progressList", progressDAO.getProgressByStudent(student.getId()));

        return "student/content-library";
    }

    @GetMapping("/view-module")
    public String viewModule(@RequestParam Long id, Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null)
            return "redirect:/login";

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
        if (student == null)
            return "redirect:/login";

        // 1. Check if already completed to prevent double point awarding
        if (!progressDAO.isModuleCompleted(student.getId(), contentId)) {
            EducationalContent content = contentDAO.findById(contentId);

            // 2. Mark progress in junction table
            progressDAO.markAsComplete(student.getId(), contentId);

            // 3. Update student points and calculate the Daily Streak
            studentDAO.updatePointsAndStreak(student.getId(), content.getPointsValue());
        }

        return "redirect:/student/view-module?id=" + contentId + "&completed=true";
    }

    @GetMapping("/progress")
    public String myProgress(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null)
            return "redirect:/login";

        model.addAttribute("student", student);
        model.addAttribute("completedModules", progressDAO.getProgressByStudent(student.getId()));
        model.addAttribute("role", "student");

        return "student/my-progress";
    }

    @GetMapping("/telehealth")
    public String showBookingPage(Model model, HttpSession session) {
        if (getLoggedInStudent(session) == null)
            return "redirect:/login";

        model.addAttribute("role", "student");
        List<Counselor> counselors = counselorDAO.findAll();
        model.addAttribute("counselors", counselors);

        return "student/telehealth-book";
    }

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
        if (student == null)
            return "redirect:/login?error=notloggedin";

        try {
            Appointment appointment = new Appointment();
            appointment.setStudent(student);
            appointment.setCounselorName(counselorName);

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
            appointment.setDate(LocalDate.parse(dateStr, dateFormatter));
            appointment.setTime(LocalTime.parse(timeStr));

            appointment.setSessionType(sessionType);
            appointment.setStatus(Appointment.AppointmentStatus.PENDING);

            appointmentDAO.save(appointment);

            return "redirect:/student/dashboard?success=true";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/student/telehealth?error=bookingfailed";
        }
    }

    @PostMapping("/telehealth/cancel")
    @Transactional
    public String cancelAppointment(@RequestParam("appointmentId") Long appointmentId, HttpSession session) {
        if (getLoggedInStudent(session) == null)
            return "redirect:/login";

        if (appointmentDAO.existsById(appointmentId)) {
            appointmentDAO.delete(appointmentId);
        }
        return "redirect:/student/dashboard";
    }

    // ✅ ADDED THIS MISSING METHOD
    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null)
            return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        return "student/profile";
    }
}