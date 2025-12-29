// src/main/java/com/mindmate/controller/AuthController.java

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

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private AdminDAO adminDAO;

    /**
     * Root URL redirects to login page.
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    /**
     * Displays the login page.
     */
    @GetMapping("/login")
    public String showLoginPage(HttpSession session, 
                               @RequestParam(required = false) String error,
                               Model model) {
        // If already logged in, redirect to appropriate dashboard
        if (SessionHelper.isLoggedIn(session)) {
            String role = SessionHelper.getRole(session);
            return "redirect:/" + role + "/dashboard";
        }

        // Show error message if login failed
        if ("true".equals(error)) {
            model.addAttribute("errorMessage", "Invalid email, password, or role. Please try again.");
        }

        return "auth/login";
    }

    /**
     * Processes login form submission.
     * Validates credentials against the appropriate DAO based on role.
     */
    @PostMapping("/login")
    @Transactional
    public String processLogin(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String role,
            HttpSession session) {

        try {
            // Validate based on role
            switch (role.toLowerCase()) {
                case "student":
                    Optional<Student> student = studentDAO.findByEmail(email);
                    if (student.isPresent() && 
                        PasswordUtil.verifyPassword(password, student.get().getPassword())) {
                        
                        SessionHelper.setUserSession(
                            session,
                            student.get().getId(),
                            student.get().getName(),
                            student.get().getEmail(),
                            "student"
                        );
                        return "redirect:/student/dashboard";
                    }
                    break;

                case "counselor":
                    Optional<Counselor> counselor = counselorDAO.findByEmail(email);
                    if (counselor.isPresent() && 
                        PasswordUtil.verifyPassword(password, counselor.get().getPassword())) {
                        
                        SessionHelper.setUserSession(
                            session,
                            counselor.get().getId(),
                            counselor.get().getName(),
                            counselor.get().getEmail(),
                            "counselor"
                        );
                        return "redirect:/counselor/dashboard";
                    }
                    break;

                case "admin":
                    Optional<Admin> admin = adminDAO.findByEmail(email);
                    if (admin.isPresent() && 
                        PasswordUtil.verifyPassword(password, admin.get().getPassword())) {
                        
                        SessionHelper.setUserSession(
                            session,
                            admin.get().getId(),
                            admin.get().getName(),
                            admin.get().getEmail(),
                            "admin"
                        );
                        return "redirect:/admin/dashboard";
                    }
                    break;

                default:
                    break;
            }

            // If we reach here, authentication failed
            return "redirect:/login?error=true";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login?error=true";
        }
    }

    /**
     * Displays the student registration page.
     */
    @GetMapping("/register")
    public String showRegisterPage(HttpSession session,
                                   @RequestParam(required = false) String error,
                                   Model model) {
        // If already logged in, redirect to dashboard
        if (SessionHelper.isLoggedIn(session)) {
            String role = SessionHelper.getRole(session);
            return "redirect:/" + role + "/dashboard";
        }

        // Show error message if registration failed
        if ("emailexists".equals(error)) {
            model.addAttribute("errorMessage", "Email already registered. Please login instead.");
        } else if ("passwordmismatch".equals(error)) {
            model.addAttribute("errorMessage", "Passwords do not match.");
        } else if ("failed".equals(error)) {
            model.addAttribute("errorMessage", "Registration failed. Please try again.");
        }

        return "auth/register";
    }

    /**
     * Processes student registration form.
     * Only students can self-register; counselors/admins are pre-seeded.
     */
    @PostMapping("/register")
    @Transactional
    public String processRegistration(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            HttpSession session) {

        try {
            // Validate passwords match
            if (!password.equals(confirmPassword)) {
                return "redirect:/register?error=passwordmismatch";
            }

            // Check if email already exists
            if (studentDAO.existsByEmail(email)) {
                return "redirect:/register?error=emailexists";
            }

            // Hash the password
            String hashedPassword = PasswordUtil.hashPassword(password);

            // Create new student
            Student newStudent = new Student(name, email, hashedPassword);
            studentDAO.save(newStudent);

            // Auto-login after successful registration
            SessionHelper.setUserSession(
                session,
                newStudent.getId(),
                newStudent.getName(),
                newStudent.getEmail(),
                "student"
            );

            return "redirect:/student/dashboard?registered=true";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/register?error=failed";
        }
    }

    /**
     * Logs out the current user by clearing their session.
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        SessionHelper.clearSession(session);
        return "redirect:/login";
    }
}