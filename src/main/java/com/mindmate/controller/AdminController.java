package com.mindmate.controller;

import com.mindmate.dao.*;
import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.SystemAnalytics;
import com.mindmate.util.CounselorStats;
import com.mindmate.util.SessionHelper;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger log = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private CounselorDAO counselorDAO;

    @Autowired
    private AppointmentDAO appointmentDAO;

    @Autowired
    private SystemAnalyticsDAO analyticsDAO;

    private boolean isAdmin(HttpSession session) {
        return SessionHelper.isLoggedIn(session) && "admin".equals(SessionHelper.getRole(session));
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        
        log.info("Admin dashboard accessed by {}", SessionHelper.getUserName(session));
        
        long totalStudents = studentDAO.count();
        long totalCounselors = counselorDAO.count();
        long totalUsers = totalStudents + totalCounselors;
        
        long totalAppointments = appointmentDAO.count();
        long pendingAppointments = appointmentDAO.countByStatus(Appointment.AppointmentStatus.PENDING);
        long confirmedAppointments = appointmentDAO.countByStatus(Appointment.AppointmentStatus.CONFIRMED);
        long cancelledAppointments = appointmentDAO.countByStatus(Appointment.AppointmentStatus.CANCELLED);
        long completedAppointments = appointmentDAO.countByStatus(Appointment.AppointmentStatus.COMPLETED);
        
        int activeUsers = (int) totalUsers; 
        int assessmentsTaken = 3421; 
        int forumPosts = 1089; 
        
        double appointmentGrowth = 0.0;
        double userGrowth = 0.0;
        
        Optional<SystemAnalytics> lastSnapshot = analyticsDAO.findLatestAnalytics();
        if (lastSnapshot.isPresent()) {
            SystemAnalytics previous = lastSnapshot.get();
            if (previous.getTotalAppointments() != null && previous.getTotalAppointments() > 0) {
                appointmentGrowth = ((double) (totalAppointments - previous.getTotalAppointments()) 
                                   / previous.getTotalAppointments()) * 100;
            }
            if (previous.getTotalUsers() != null && previous.getTotalUsers() > 0) {
                userGrowth = ((double) (totalUsers - previous.getTotalUsers()) 
                            / previous.getTotalUsers()) * 100;
            }
        }
        
        List<SystemAnalytics> trendData = analyticsDAO.findRecentSnapshots(6);
        
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("totalCounselors", totalCounselors);
        model.addAttribute("activeUsers", activeUsers);
        
        model.addAttribute("totalAppointments", totalAppointments);
        model.addAttribute("pendingAppointments", pendingAppointments);
        model.addAttribute("confirmedAppointments", confirmedAppointments);
        model.addAttribute("cancelledAppointments", cancelledAppointments);
        model.addAttribute("completedAppointments", completedAppointments);
        
        model.addAttribute("assessmentsTaken", assessmentsTaken);
        model.addAttribute("forumPosts", forumPosts);
        
        model.addAttribute("appointmentGrowth", String.format("%.1f", appointmentGrowth));
        model.addAttribute("userGrowth", String.format("%.1f", userGrowth));
        
        model.addAttribute("trendData", trendData);
        
        return "admin/dashboard";
    }

    @GetMapping("/analytics/snapshot")
    @Transactional
    public String saveSnapshot(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            SystemAnalytics snapshot = new SystemAnalytics();
            long totalStudents = studentDAO.count();
            long totalCounselors = counselorDAO.count();
            
            snapshot.setTotalUsers((int) (totalStudents + totalCounselors));
            snapshot.setTotalStudents((int) totalStudents);
            snapshot.setTotalCounselors((int) totalCounselors);
            snapshot.setActiveUsers(856); 
            
            snapshot.setTotalAppointments((int) appointmentDAO.count());
            snapshot.setPendingAppointments((int) appointmentDAO.countByStatus(Appointment.AppointmentStatus.PENDING));
            snapshot.setConfirmedAppointments((int) appointmentDAO.countByStatus(Appointment.AppointmentStatus.CONFIRMED));
            snapshot.setCancelledAppointments((int) appointmentDAO.countByStatus(Appointment.AppointmentStatus.CANCELLED));
            snapshot.setCompletedAppointments((int) appointmentDAO.countByStatus(Appointment.AppointmentStatus.COMPLETED));
            
            snapshot.setAssessmentsTaken(3421);
            snapshot.setForumPosts(1089);
            snapshot.setContentViews(5420);
            
            snapshot.setRecordedAt(LocalDateTime.now());
            
            analyticsDAO.save(snapshot);
            log.info("Analytics snapshot saved manually by {}", SessionHelper.getUserName(session));
            return "redirect:/admin/dashboard?success=snapshot";
        } catch (Exception e) {
            log.error("Error saving analytics snapshot", e);
            return "redirect:/admin/dashboard?error=snapshot";
        }
    }

    @GetMapping("/analytics")
    public String analyticsPage(
            @RequestParam(defaultValue = "month") String view,
            HttpSession session, 
            Model model) {
        
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        model.addAttribute("currentView", view);
        
        List<SystemAnalytics> trendData;
        switch (view) {
            case "week": trendData = analyticsDAO.findRecentSnapshots(7); break;
            case "year": trendData = analyticsDAO.findMonthlySnapshots(12); break;
            case "month":
            default: trendData = analyticsDAO.findRecentSnapshots(30); break;
        }
        
        model.addAttribute("analyticsData", trendData);
        model.addAttribute("totalUsers", studentDAO.count() + counselorDAO.count());
        model.addAttribute("totalAppointments", appointmentDAO.count());
        
        return "admin/analytics";
    }

    @GetMapping("/counselor-performance")
    public String counselorPerformance(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        
        try {
            List<Counselor> allCounselors = counselorDAO.findAll();
            List<CounselorStats> performanceList = new ArrayList<>();
            
            for (Counselor counselor : allCounselors) {
                CounselorStats stats = new CounselorStats(counselor.getId(), counselor.getName());
                
                List<Appointment> appointments = appointmentDAO.findByCounselor(counselor);
                
                stats.setTotalAppointments(appointments.size());
                
                long pending = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.PENDING).count();
                
                // History of Success (Confirmed + Completed)
                long confirmed = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CONFIRMED || 
                                 a.getStatus() == Appointment.AppointmentStatus.COMPLETED).count();
                
                // History of Rejection (Denied + Rejected + Acknowledged)
                long denied = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.DENIED || 
                                 a.getStatus() == Appointment.AppointmentStatus.REJECTED || 
                                 a.getStatus() == Appointment.AppointmentStatus.ACKNOWLEDGED).count();

                // ✅ NEW: Explicitly count Cancelled (by Student)
                long cancelled = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CANCELLED).count();
                
                stats.setPendingAppointments(pending);
                stats.setConfirmedAppointments(confirmed);
                stats.setDeniedAppointments(denied);
                stats.setCancelledAppointments(cancelled); // ✅ Set it
                
                stats.calculateApprovalRate();
                
                performanceList.add(stats);
            }
            
            performanceList.sort((a, b) -> Long.compare(b.getTotalAppointments(), a.getTotalAppointments()));
            
            model.addAttribute("counselorStats", performanceList);
            log.info("Counselor performance page accessed by {}", SessionHelper.getUserName(session));
            
        } catch (Exception e) {
            log.error("Error loading counselor performance", e);
            model.addAttribute("error", "Failed to load performance data");
        }
        
        return "admin/counselor-performance";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        return "admin/profile";
    }

    @GetMapping("/forum-moderation")
    public String forumModeration(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));
        return "admin/forum-moderation";
    }
}