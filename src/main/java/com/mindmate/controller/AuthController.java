package com.mindmate.controller;

import com.mindmate.dao.AdminDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.Admin;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.util.PasswordUtil;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

/**
 * Controller handling authentication operations.
 * Manages login, logout, and student registration.
 *
 * @author Samy (A23CS0246)
 */
@Controller
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private AdminDAO adminDAO;

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginPage(HttpSession session,
                                @RequestParam(required = false) String error,
                                Model model) {
        if (SessionHelper.isLoggedIn(session)) {
            String role = SessionHelper.getRole(session);
            return "redirect:/" + role + "/dashboard";
        }

        if ("true".equals(error)) {
            model.addAttribute("errorMessage", "Invalid email or password. Please try again.");
        }

        return "auth/login";
    }

    /**
     * Processes login with AUTO-ROLE DETECTION.
     * Checks Admin -> Counselor -> Student tables sequentially.
     */
    @PostMapping("/login")
    @Transactional
    public String processLogin(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session) {

        try {
            // 1. Check Admin
            Optional<Admin> admin = adminDAO.findByEmail(email);
            if (admin.isPresent()) {
                if (PasswordUtil.verifyPassword(password, admin.get().getPassword())) {
                    SessionHelper.setUserSession(session, admin.get().getId(), admin.get().getName(), admin.get().getEmail(), "admin");
                    return "redirect:/admin/dashboard";
                } else {
                    log.warn("Login failed for Admin: {} (Bad Password)", email);
                    return "redirect:/login?error=true";
                }
            }

            // 2. Check Counselor
            Optional<Counselor> counselor = counselorDAO.findByEmail(email);
            if (counselor.isPresent()) {
                if (PasswordUtil.verifyPassword(password, counselor.get().getPassword())) {
                    SessionHelper.setUserSession(session, counselor.get().getId(), counselor.get().getName(), counselor.get().getEmail(), "counselor");
                    return "redirect:/counselor/dashboard";
                } else {
                    log.warn("Login failed for Counselor: {} (Bad Password)", email);
                    return "redirect:/login?error=true";
                }
            }

            // 3. Check Student
            Optional<Student> student = studentDAO.findByEmail(email);
            if (student.isPresent()) {
                if (PasswordUtil.verifyPassword(password, student.get().getPassword())) {
                    SessionHelper.setUserSession(session, student.get().getId(), student.get().getName(), student.get().getEmail(), "student");
                    return "redirect:/student/dashboard";
                } else {
                    log.warn("Login failed for Student: {} (Bad Password)", email);
                    return "redirect:/login?error=true";
                }
            }

            // 4. Not found anywhere
            log.warn("Login failed: Email not found - {}", email);
            return "redirect:/login?error=true";

        } catch (Exception e) {
            log.error("System error during login for user: {}", email, e);
            return "redirect:/login?error=true";
        }
    }

    @GetMapping("/register")
    public String showRegisterPage(HttpSession session,
                                   @RequestParam(required = false) String error,
                                   Model model) {
        if (SessionHelper.isLoggedIn(session)) {
            String role = SessionHelper.getRole(session);
            return "redirect:/" + role + "/dashboard";
        }

        if ("emailexists".equals(error)) {
            model.addAttribute("errorMessage", "Email already registered. Please login instead.");
        } else if ("passwordmismatch".equals(error)) {
            model.addAttribute("errorMessage", "Passwords do not match.");
        } else if ("weakpassword".equals(error)) {
            model.addAttribute("errorMessage", "Password must be at least 6 characters.");
        } else if ("failed".equals(error)) {
            model.addAttribute("errorMessage", "Registration failed. Please try again.");
        }

        return "auth/register";
    }

    @PostMapping("/register")
    @Transactional
    public String processRegistration(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            HttpSession session) {

        try {
            if (password == null || password.length() < 6) {
                return "redirect:/register?error=weakpassword";
            }

            if (!password.equals(confirmPassword)) {
                return "redirect:/register?error=passwordmismatch";
            }

            if (studentDAO.existsByEmail(email)) {
                return "redirect:/register?error=emailexists";
            }

            String hashedPassword = PasswordUtil.hashPassword(password);
            Student newStudent = new Student(name, email, hashedPassword);
            studentDAO.save(newStudent);

            SessionHelper.setUserSession(session, newStudent.getId(), newStudent.getName(), newStudent.getEmail(), "student");
            log.info("New student registered: {}", email);
            
            return "redirect:/student/dashboard?registered=true";

        } catch (Exception e) {
            log.error("Registration failed for user: {}", email, e);
            return "redirect:/register?error=failed";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        SessionHelper.clearSession(session);
        return "redirect:/login";
    }
}