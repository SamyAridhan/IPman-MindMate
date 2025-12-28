// src/main/java/com/mindmate/model/SystemAnalytics.java

package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity for storing system-wide analytics snapshots.
 * Used for historical tracking and dashboard metrics.
 */
@Entity
@Table(name = "system_analytics")
public class SystemAnalytics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "total_users")
    private Integer totalUsers = 0;

    @Column(name = "active_users")
    private Integer activeUsers = 0;

    @Column(name = "assessments_taken")
    private Integer assessmentsTaken = 0;

    @Column(name = "forum_posts")
    private Integer forumPosts = 0;

    @Column(name = "recorded_at", updatable = false)
    private LocalDateTime recordedAt;

    @PrePersist
    protected void onCreate() {
        recordedAt = LocalDateTime.now();
    }

    // Constructors
    public SystemAnalytics() {}

    public SystemAnalytics(Integer totalUsers, Integer activeUsers, 
                          Integer assessmentsTaken, Integer forumPosts) {
        this.totalUsers = totalUsers;
        this.activeUsers = activeUsers;
        this.assessmentsTaken = assessmentsTaken;
        this.forumPosts = forumPosts;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(Integer totalUsers) {
        this.totalUsers = totalUsers;
    }

    public Integer getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(Integer activeUsers) {
        this.activeUsers = activeUsers;
    }

    public Integer getAssessmentsTaken() {
        return assessmentsTaken;
    }

    public void setAssessmentsTaken(Integer assessmentsTaken) {
        this.assessmentsTaken = assessmentsTaken;
    }

    public Integer getForumPosts() {
        return forumPosts;
    }

    public void setForumPosts(Integer forumPosts) {
        this.forumPosts = forumPosts;
    }

    public LocalDateTime getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(LocalDateTime recordedAt) {
        this.recordedAt = recordedAt;
    }
}