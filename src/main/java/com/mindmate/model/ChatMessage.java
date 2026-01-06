package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chat_messages")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Link to the student
    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student student;

    // A unique ID for each conversation (e.g., "chat_17123456")
    // When a student logs in, they get a NEW sessionId
    private String sessionId; 

    // Store the title (first user message, max 100 chars)
    @Column(length = 255)
    private String title;

    private String role; 
    @Column(columnDefinition = "TEXT")
    private String content;
    private LocalDateTime timestamp;

    public ChatMessage() {
    }

    public ChatMessage(String role, String content, LocalDateTime timestamp) {
        this.role = role;
        this.content = content;
        this.timestamp = timestamp;
    }
    
    public ChatMessage(Long id, Student student, String sessionId, String role, String content,
            LocalDateTime timestamp) {
        this.id = id;
        this.student = student;
        this.sessionId = sessionId;
        this.role = role;
        this.content = content;
        this.timestamp = timestamp;
    }

    public ChatMessage(Long id, Student student, String sessionId, String title, String role, 
            String content, LocalDateTime timestamp) {
        this.id = id;
        this.student = student;
        this.sessionId = sessionId;
        this.title = title;
        this.role = role;
        this.content = content;
        this.timestamp = timestamp;
    }

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Student getStudent() {
        return student;
    }
    public void setStudent(Student student) {
        this.student = student;
    }
    public String getSessionId() {
        return sessionId;
    }
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}