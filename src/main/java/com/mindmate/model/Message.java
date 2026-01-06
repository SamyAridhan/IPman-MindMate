package com.mindmate.model;

public class Message {
    private String role;
    private String content;

    // 1. Constructor 
    public Message(String role, String content) {
        this.role = role;
        this.content = content;
    }

    // 2. Getters 
    public String getRole() {
        return role;
    }

    public String getContent() {
        return content;
    }

}