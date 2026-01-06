package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing system analytics snapshots.
 * Updates: Added breakdown for students/counselors and appointment stats.
 */
@Entity
@Table(name = "system_analytics")
public class SystemAnalytics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ============================================
    // USER METRICS
    // ============================================
    @Column(name = "total_users")
    private Integer totalUsers = 0; // Default to 0 to prevent NullPointerExceptions

    @Column(name = "total_students")
    private Integer totalStudents = 0; 

    @Column(name = "total_counselors")
    private Integer totalCounselors = 0; 

    @Column(name = "active_users")
    private Integer activeUsers = 0;

    // ============================================
    // APPOINTMENT METRICS 
    // ============================================
    @Column(name = "total_appointments")
    private Integer totalAppointments = 0;

    @Column(name = "pending_appointments")
    private Integer pendingAppointments = 0;

    @Column(name = "confirmed_appointments")
    private Integer confirmedAppointments = 0;

    @Column(name = "cancelled_appointments")
    private Integer cancelledAppointments = 0;

    @Column(name = "completed_appointments")
    private Integer completedAppointments = 0;

    // ============================================
    // MODULE USAGE METRICS
    // ============================================
    @Column(name = "assessments_taken")
    private Integer assessmentsTaken = 0;

    @Column(name = "forum_posts")
    private Integer forumPosts = 0;

    @Column(name = "content_views")
    private Integer contentViews = 0; 

    // ============================================
    // TIMESTAMP
    // ============================================
    @Column(name = "recorded_at", nullable = false)
    private LocalDateTime recordedAt;

    @PrePersist
    protected void onCreate() {
        if (recordedAt == null) {
            recordedAt = LocalDateTime.now();
        }
    }

    // ============================================
    // CONSTRUCTORS
    // ============================================
    public SystemAnalytics() {}

    // OLD CONSTRUCTOR (For Backward Compatibility)
    public SystemAnalytics(Integer totalUsers, Integer activeUsers, 
                           Integer assessmentsTaken, Integer forumPosts) {
        this.totalUsers = totalUsers;
        this.activeUsers = activeUsers;
        this.assessmentsTaken = assessmentsTaken;
        this.forumPosts = forumPosts;
        this.recordedAt = LocalDateTime.now();
    }

    //NEW CONSTRUCTOR (For New Analytics Logic)
    public SystemAnalytics(Integer totalUsers, Integer totalAppointments) {
        this.totalUsers = totalUsers;
        this.totalAppointments = totalAppointments;
        this.recordedAt = LocalDateTime.now();
    }

    // ============================================
    // GETTERS & SETTERS 
    // ============================================
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Integer getTotalUsers() { return totalUsers; }
    public void setTotalUsers(Integer totalUsers) { this.totalUsers = totalUsers; }

    public Integer getTotalStudents() { return totalStudents; }
    public void setTotalStudents(Integer totalStudents) { this.totalStudents = totalStudents; }

    public Integer getTotalCounselors() { return totalCounselors; }
    public void setTotalCounselors(Integer totalCounselors) { this.totalCounselors = totalCounselors; }

    public Integer getActiveUsers() { return activeUsers; }
    public void setActiveUsers(Integer activeUsers) { this.activeUsers = activeUsers; }

    public Integer getTotalAppointments() { return totalAppointments; }
    public void setTotalAppointments(Integer totalAppointments) { this.totalAppointments = totalAppointments; }

    public Integer getPendingAppointments() { return pendingAppointments; }
    public void setPendingAppointments(Integer pendingAppointments) { this.pendingAppointments = pendingAppointments; }

    public Integer getConfirmedAppointments() { return confirmedAppointments; }
    public void setConfirmedAppointments(Integer confirmedAppointments) { this.confirmedAppointments = confirmedAppointments; }

    public Integer getCancelledAppointments() { return cancelledAppointments; }
    public void setCancelledAppointments(Integer cancelledAppointments) { this.cancelledAppointments = cancelledAppointments; }

    public Integer getCompletedAppointments() { return completedAppointments; }
    public void setCompletedAppointments(Integer completedAppointments) { this.completedAppointments = completedAppointments; }

    public Integer getAssessmentsTaken() { return assessmentsTaken; }
    public void setAssessmentsTaken(Integer assessmentsTaken) { this.assessmentsTaken = assessmentsTaken; }

    public Integer getForumPosts() { return forumPosts; }
    public void setForumPosts(Integer forumPosts) { this.forumPosts = forumPosts; }

    public Integer getContentViews() { return contentViews; }
    public void setContentViews(Integer contentViews) { this.contentViews = contentViews; }

    public LocalDateTime getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDateTime recordedAt) { this.recordedAt = recordedAt; }
}