//src\main\java\com\mindmate\controller\AuthController.java
package com.mindmate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AuthController {

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "auth/login";
    }

    @PostMapping("/login")
    public String processLogin() {
        return "redirect:/student/dashboard";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "auth/register";
    }

    @GetMapping("/logout")
    public String logout() {
        // In a real app, we would invalidate the session here.
        // For the demo, just redirecting to login is fine.
        return "redirect:/login";
    }
    // -----------------------
}