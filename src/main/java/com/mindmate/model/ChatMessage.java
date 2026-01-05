package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chat_messages")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String role; // "user" or "assistant"

    @Column(columnDefinition = "TEXT") // Allows for long AI responses
    private String content;

    private LocalDateTime timestamp;

    public ChatMessage() {}

    public ChatMessage(String role, String content, LocalDateTime timestamp) {
        this.role = role;
        this.content = content;
        this.timestamp = timestamp;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}