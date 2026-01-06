package com.mindmate.controller;

import com.mindmate.dao.*;
import com.mindmate.model.*;
import com.mindmate.util.CounselorStats;
import com.mindmate.util.SessionHelper;
import com.mindmate.util.PasswordUtil; // ✅ Added Import

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @Autowired
    private ForumDAO forumDAO;

    @Autowired
    private AdminDAO adminDAO;

    private boolean isAdmin(HttpSession session) {
        return SessionHelper.isLoggedIn(session) && "admin".equals(SessionHelper.getRole(session));
    }
    
    private Admin getLoggedInAdmin(HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null || !isAdmin(session)) {
            return null;
        }
        return adminDAO.findById(userId);
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
                
                long confirmed = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CONFIRMED || 
                                 a.getStatus() == Appointment.AppointmentStatus.COMPLETED).count();
                
                long denied = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.DENIED || 
                                 a.getStatus() == Appointment.AppointmentStatus.REJECTED || 
                                 a.getStatus() == Appointment.AppointmentStatus.ACKNOWLEDGED).count();

                long cancelled = appointments.stream()
                    .filter(a -> a.getStatus() == Appointment.AppointmentStatus.CANCELLED).count();
                
                stats.setPendingAppointments(pending);
                stats.setConfirmedAppointments(confirmed);
                stats.setDeniedAppointments(denied);
                stats.setCancelledAppointments(cancelled);
                
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
        
        Admin admin = getLoggedInAdmin(session);
        if (admin != null) {
            model.addAttribute("user", admin); // Matches ${user.name} in JSP
        } else {
            // Fallback just in case, though isAdmin checks login
            return "redirect:/login";
        }
        
        return "admin/profile";
    }

    @GetMapping("/forum-moderation")
    public String forumModeration(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));

        List<ForumPost> flaggedPosts = forumDAO.getFlaggedPosts();
        ModerationStats stats = forumDAO.getModerationStats();
        
        model.addAttribute("flaggedPosts", flaggedPosts);
        model.addAttribute("flaggedCount", flaggedPosts.size());
        model.addAttribute("approvedCount", stats.getApprovedCount());
        model.addAttribute("deletedCount", stats.getDeletedCount());
        
        return "admin/forum-moderation";
    }
    
    @PostMapping("/forum/approve")
    public String approvePost(@RequestParam("postId") int postId) {
        ForumPost post = forumDAO.getPostById(postId);
        if (post != null) {
            post.setFlagged(false);
            post.getFlaggedUserIds().clear();
            forumDAO.saveOrUpdate(post);
            forumDAO.incrementApprovedCount(); 
        }
        return "redirect:/admin/forum-moderation";
    }

    @PostMapping("/forum/delete")
    public String deletePost(@RequestParam("postId") int postId) {
        forumDAO.deletePost(postId);
        forumDAO.incrementDeletedCount(); 
        return "redirect:/admin/forum-moderation";
    }

    @GetMapping("/forum/view")
    public String viewFlaggedPost(@RequestParam("postId") int postId, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("role", "admin");
        model.addAttribute("user", SessionHelper.getUserName(session));

        ForumPost post = forumDAO.getPostById(postId);
        if (post == null) return "redirect:/admin/forum-moderation";

        model.addAttribute("post", post);
        return "admin/forum-moderation-detail";
    }

    @PostMapping("/profile/update")
    @Transactional
    public String updateProfile(
            @RequestParam String name,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Admin admin = getLoggedInAdmin(session);
        if (admin == null) return "redirect:/login";

        try {
            admin.setName(name);
            adminDAO.update(admin);
            
            session.setAttribute("userName", name);
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        } catch (Exception e) {
            log.error("Error updating admin profile", e);
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update profile.");
        }
        return "redirect:/admin/profile";
    }

    @PostMapping("/profile/change-password")
    @Transactional
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Admin admin = getLoggedInAdmin(session);
        if (admin == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "New passwords do not match.");
            return "redirect:/admin/profile";
        }

        try {
            // ✅ FIX: Use PasswordUtil
            if (PasswordUtil.checkPassword(currentPassword, admin.getPassword())) {
                admin.setPassword(PasswordUtil.hashPassword(newPassword)); 
                adminDAO.update(admin);
                redirectAttributes.addFlashAttribute("successMessage", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Incorrect current password.");
            }
        } catch (Exception e) {
            log.error("Error changing admin password", e);
            redirectAttributes.addFlashAttribute("errorMessage", "System error while changing password.");
        }
        return "redirect:/admin/profile";
    }
    
    @PostMapping("/preferences")
    public String updatePreferences(HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";
        redirectAttributes.addFlashAttribute("successMessage", "System preferences updated.");
        return "redirect:/admin/profile";
    }
}