package com.mindmate.controller;

import com.mindmate.dao.AssessmentDAO;
import com.mindmate.dao.AppointmentDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.EducationalContentDAO;
import com.mindmate.dao.StudentProgressDAO;
import com.mindmate.model.Assessment;
import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.model.EducationalContent;
import com.mindmate.util.SessionHelper;
import com.mindmate.util.PasswordUtil; 

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class StudentController {

    private static final Logger log = LoggerFactory.getLogger(StudentController.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH);

    @Autowired
    private AssessmentDAO assessmentDAO;

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

        List<Assessment> history = assessmentDAO.findByStudent(student);
        model.addAttribute("assessmentHistory", history);
        
        Assessment latest = null;
        if (history != null && !history.isEmpty()) {
            latest = history.get(history.size() - 1);
        }
        model.addAttribute("latestAssessment", latest);

        // --- REFINED PERSONALIZATION LOGIC START ---
        List<EducationalContent> finalRecs = new ArrayList<>();
        String recTitle = "General Wellness Essentials";
        
        // Use a TreeMap to automatically sort by Priority (1 = High, 3 = Low)
        java.util.Map<Integer, List<EducationalContent>> priorityMap = new java.util.TreeMap<>();
        priorityMap.put(1, new ArrayList<>()); // Critical: Anxiety/Mood/Depression
        priorityMap.put(2, new ArrayList<>()); // Secondary: Stress/Focus/Motivation
        priorityMap.put(3, new ArrayList<>()); // Maintenance: Sleep/General Wellness

        if (latest != null && latest.getResponseData() != null) {
            String[] answers = latest.getResponseData().split(",");

            if (answers.length >= 5) {
                try {
                    int q1 = Integer.parseInt(answers[0].trim()); // Anxiety
                    int q2 = Integer.parseInt(answers[1].trim()); // Worry
                    int q3 = Integer.parseInt(answers[2].trim()); // Depression
                    int q4 = Integer.parseInt(answers[3].trim()); // Interest
                    int q5 = Integer.parseInt(answers[4].trim()); // Sleep

                    boolean specificNeedsFound = false;

                    // 1. PRIORITY 1: ANXIETY & DEPRESSION (Critical Support)
                    if (q1 >= 2 || q2 >= 2 || q3 >= 2) {
                        priorityMap.get(1).addAll(contentDAO.searchByKeyword("Anxiety"));
                        priorityMap.get(1).addAll(contentDAO.searchByKeyword("Depression"));
                        priorityMap.get(1).addAll(contentDAO.searchByKeyword("Grounding"));
                        specificNeedsFound = true;
                    }

                    // 2. PRIORITY 2: MOTIVATION & STRESS
                    if (q4 >= 2 || q1 == 1 || q2 == 1) {
                        priorityMap.get(2).addAll(contentDAO.searchByKeyword("Motivation"));
                        priorityMap.get(2).addAll(contentDAO.searchByKeyword("Stress"));
                        priorityMap.get(2).addAll(contentDAO.searchByKeyword("Pomodoro"));
                        specificNeedsFound = true;
                    }

                    // 3. PRIORITY 3: SLEEP
                    if (q5 >= 2) {
                        priorityMap.get(3).addAll(contentDAO.searchByKeyword("Sleep"));
                        specificNeedsFound = true;
                    }

                    // --- FILTERING & CAPPING (Limit to Top 3) ---
                    Set<Long> seenIds = new HashSet<>(); 
                    for (List<EducationalContent> list : priorityMap.values()) {
                        for (EducationalContent c : list) {
                            if (finalRecs.size() < 3 && !seenIds.contains(c.getId())) {
                                finalRecs.add(c);
                                seenIds.add(c.getId());
                            }
                        }
                        if (finalRecs.size() >= 3) break;
                    }

                    if (specificNeedsFound) {
                        recTitle = "Top Support Priorities for You";
                    }
                } catch (NumberFormatException e) {
                    log.error("Error parsing response data: {}", e.getMessage());
                }
            }
        }

        // Fallback: If no high scores or no data, show general content
        if (finalRecs.isEmpty()) {
            finalRecs = contentDAO.findAll().stream()
                .limit(3)
                .collect(Collectors.toList());
        }

        model.addAttribute("recommendedModules", finalRecs);
        model.addAttribute("recTitle", recTitle);
        // --- PERSONALIZATION LOGIC END ---

        List<EducationalContent> allContent = contentDAO.findAll();
        List<EducationalContent> newestModules = allContent.stream()
                .sorted((a, b) -> b.getId().compareTo(a.getId())) // Sort by ID descending (newest first)
                .limit(3)
                .collect(Collectors.toList());
        
        model.addAttribute("newestModules", newestModules);
        
        return "student/dashboard";
    }

    @GetMapping("/library")
    public String contentLibrary(Model model, HttpSession session) {
        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        model.addAttribute("role", "student");
        model.addAttribute("student", student);
        
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

        if (!progressDAO.isModuleCompleted(student.getId(), contentId)) {
            EducationalContent content = contentDAO.findById(contentId);
            progressDAO.markAsComplete(student.getId(), contentId);
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

            List<LocalTime> potentialSlots = new ArrayList<>();

            if (counselorId % 2 != 0) { 
                potentialSlots.add(LocalTime.of(8, 30));
                potentialSlots.add(LocalTime.of(10, 0));
                potentialSlots.add(LocalTime.of(11, 30));
                potentialSlots.add(LocalTime.of(14, 0));
                potentialSlots.add(LocalTime.of(15, 30));
            } else {
                potentialSlots.add(LocalTime.of(9, 0));
                potentialSlots.add(LocalTime.of(10, 30));
                potentialSlots.add(LocalTime.of(14, 30));
                potentialSlots.add(LocalTime.of(16, 0));
            }

            List<Appointment> booked = appointmentDAO.findByCounselorAndDate(counselor, targetDate);
            List<LocalTime> bookedTimes = booked.stream()
                .filter(a -> a.getStatus() != Appointment.AppointmentStatus.CANCELLED && 
                             a.getStatus() != Appointment.AppointmentStatus.DENIED)
                .map(Appointment::getTime)
                .collect(Collectors.toList());

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
                return "redirect:/student/telehealth?error=invaliddate";
            }

            List<Appointment> dayAppointments = appointmentDAO.findByCounselorAndDate(counselor, date);
            
            boolean slotTaken = dayAppointments.stream()
                .anyMatch(a -> a.getTime().equals(time) && 
                               a.getStatus() != Appointment.AppointmentStatus.CANCELLED && 
                               a.getStatus() != Appointment.AppointmentStatus.DENIED);

            if (slotTaken) {
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
            return "redirect:/student/dashboard?success=true";
            
        } catch (DateTimeParseException e) {
            return "redirect:/student/telehealth?error=invaliddate";
        } catch (Exception e) {
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
        model.addAttribute("user", student); 
        return "student/profile";
    }

    @PostMapping("/profile/update")
    @Transactional
    public String updateProfile(
            @RequestParam String name,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        try {
            student.setName(name);
            studentDAO.update(student);
            
            session.setAttribute("userName", name);
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        } catch (Exception e) {
            log.error("Error updating student profile", e);
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update profile.");
        }
        return "redirect:/student/profile";
    }

    @PostMapping("/profile/change-password")
    @Transactional
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Student student = getLoggedInStudent(session);
        if (student == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "New passwords do not match.");
            return "redirect:/student/profile";
        }

        try {
            // Use PasswordUtil to check hash and encrypt new password
            if (PasswordUtil.checkPassword(currentPassword, student.getPassword())) {
                student.setPassword(PasswordUtil.hashPassword(newPassword)); 
                studentDAO.update(student);
                redirectAttributes.addFlashAttribute("successMessage", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Incorrect current password.");
            }
        } catch (Exception e) {
            log.error("Error changing student password", e);
            redirectAttributes.addFlashAttribute("errorMessage", "System error while changing password.");
        }
        return "redirect:/student/profile";
    }
}