package com.mindmate.model;

public class Message {
    private String role;
    private String content;

    // 1. Constructor (To fix the 'new Message(...)')
    public Message(String role, String content) {
        this.role = role;
        this.content = content;
    }

    // 2. Getters (Required for the JSP to read the data)
    public String getRole() {
        return role;
    }

    public String getContent() {
        return content;
    }

    // You can skip setters for an immutable object like a chat message
}