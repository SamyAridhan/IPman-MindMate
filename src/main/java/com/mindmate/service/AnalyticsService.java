// src/main/java/com/mindmate/service/AnalyticsService.java

package com.mindmate.service;

import com.mindmate.model.SystemAnalytics;
import com.mindmate.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

/**
 * Service layer for system analytics and reporting.
 * Aggregates data from various modules for admin dashboard.
 * 
 * @author Samy (A23CS0246)
 * @module Admin Analytics
 */
@Service
@Transactional(readOnly = true)
public class AnalyticsService {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private SystemAnalyticsRepository analyticsRepository;

    // TODO: Inject other repositories as team completes modules
    // @Autowired private AssessmentRepository assessmentRepository;
    // @Autowired private ForumPostRepository forumPostRepository;

    /**
     * Retrieves current system analytics with real-time data.
     * Combines database queries with placeholder data for incomplete modules.
     * 
     * @return Map containing analytics metrics
     */
    public Map<String, Object> getCurrentAnalytics() {
        Map<String, Object> analytics = new HashMap<>();
        
        // Real-time counts from database
        analytics.put("totalUsers", studentRepository.count());
        analytics.put("totalAppointments", appointmentRepository.count());
        
        // Calculate active users (students with appointments in last 30 days)
        // TODO: Implement with proper query when time permits
        analytics.put("activeUsers", calculateActiveUsers());
        
        // Mock data for modules not yet implemented
        // TODO: Replace with real data as team completes other modules
        analytics.put("assessmentsTaken", 3421);  // Placeholder
        analytics.put("forumPosts", 1089);        // Placeholder
        
        return analytics;
    }

    /**
     * Calculates number of active users based on recent activity.
     * Currently returns mock data - will be enhanced in Phase 3.
     * 
     * @return Count of active users
     */
    private long calculateActiveUsers() {
        // TODO: Implement actual logic:
        // SELECT COUNT(DISTINCT student_id) FROM appointments 
        // WHERE date >= CURRENT_DATE - INTERVAL 30 DAY
        return 856L; // Placeholder for now
    }

    /**
     * Creates a snapshot of current analytics and saves to database.
     * Useful for historical tracking and trend analysis.
     */
    @Transactional
    public void saveAnalyticsSnapshot() {
        SystemAnalytics snapshot = new SystemAnalytics();
        snapshot.setTotalUsers((int) studentRepository.count());
        snapshot.setActiveUsers((int) calculateActiveUsers());
        snapshot.setAssessmentsTaken(3421); // TODO: Replace with real count
        snapshot.setForumPosts(1089);       // TODO: Replace with real count
        
        analyticsRepository.save(snapshot);
    }

    /**
     * Retrieves the most recently saved analytics snapshot.
     * 
     * @return Latest SystemAnalytics entity or null if none exists
     */
    public SystemAnalytics getLatestSnapshot() {
        return analyticsRepository.findLatestAnalytics().orElse(null);
    }

    /**
     * Gets appointment-specific metrics for counselor dashboard.
     * 
     * @return Map containing appointment statistics
     */
    public Map<String, Object> getAppointmentMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        metrics.put("totalAppointments", appointmentRepository.count());
        // TODO: Add more metrics as needed:
        // - Appointments by status
        // - Average appointments per counselor
        // - Busiest time slots
        
        return metrics;
    }
}