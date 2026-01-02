package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * Entity representing a telehealth counseling appointment.
 * Updates: Fixed LazyInitializationException by prioritizing stored string.
 */
@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    // ✅ NEW: Store counselor as entity (The "System" side logic)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "counselor_id")
    private Counselor counselor;

    // ✅ DEPRECATED: Kept for performance & legacy frontend compatibility
    @Column(name = "counselor_name")
    private String counselorName;

    @Column(nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private LocalTime time;

    @Column(name = "session_type")
    private String sessionType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentStatus status = AppointmentStatus.PENDING;

    // ✅ NEW: Student's notes/reason for booking
    @Column(columnDefinition = "TEXT")
    private String notes;

    // ✅ NEW: Counselor's reason for denial
    @Column(name = "denial_reason", columnDefinition = "TEXT")
    private String denialReason;

    // ✅ NEW: Audit trails
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // ============================================
    // LIFECYCLE CALLBACKS (Auto-timestamps)
    // ============================================
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // ============================================
    // ENUMS
    // ============================================
    public enum AppointmentStatus {
        PENDING,    // Waiting for counselor approval
        CONFIRMED,  // Approved by counselor
        CANCELLED,  // Cancelled by student or counselor
        COMPLETED   // Session finished
    }

    // ============================================
    // CONSTRUCTORS
    // ============================================
    public Appointment() {}

    public Appointment(Student student, Counselor counselor, LocalDate date, LocalTime time, String sessionType) {
        this.student = student;
        this.counselor = counselor;
        // Sync name immediately upon creation
        this.counselorName = (counselor != null) ? counselor.getName() : null; 
        this.date = date;
        this.time = time;
        this.sessionType = sessionType;
        this.status = AppointmentStatus.PENDING;
    }

    // ============================================
    // GETTERS & SETTERS
    // ============================================
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public Counselor getCounselor() { return counselor; }
    
    public void setCounselor(Counselor counselor) {
        this.counselor = counselor;
        // Automatically sync the string name when the entity is set
        if (counselor != null) {
            this.counselorName = counselor.getName();
        }
    }

    public String getCounselorName() {
        // ✅ CRITICAL FIX: Always return the stored string.
        // Accessing 'counselor.getName()' here triggers a database call.
        // If the session is closed (e.g. inside JSP), that call crashes the app.
        return this.counselorName;
    }

    public void setCounselorName(String counselorName) {
        this.counselorName = counselorName;
    }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getTime() { return time; }
    public void setTime(LocalTime time) { this.time = time; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public AppointmentStatus getStatus() { return status; }
    public void setStatus(AppointmentStatus status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getDenialReason() { return denialReason; }
    public void setDenialReason(String denialReason) { this.denialReason = denialReason; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}