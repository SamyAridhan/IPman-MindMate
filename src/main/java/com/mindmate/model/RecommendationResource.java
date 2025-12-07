package com.mindmate.model;

/**
 * Model class to hold structured data for an AI-recommended resource.
 * This replaces the static inner class used previously in the Controller.
 */
public class RecommendationResource {
    private String title;
    private String content;
    private String embedHtml;
    private String typeText;
    private String typeBadgeClass; // Used to map to MindMate CSS classes

    // Constructor
    public RecommendationResource(String title, String content, String embedHtml, String typeText, String typeBadgeClass) {
        this.title = title;
        this.content = content;
        this.embedHtml = embedHtml;
        this.typeText = typeText;
        this.typeBadgeClass = typeBadgeClass;
    }

    // --- Getters ---
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public String getEmbedHtml() { return embedHtml; }
    public String getTypeText() { return typeText; }
    public String getTypeBadgeClass() { return typeBadgeClass; }

    // --- Setters (Optional, but included for completeness/binding) ---
    public void setTitle(String title) { this.title = title; }
    public void setContent(String content) { this.content = content; }
    public void setEmbedHtml(String embedHtml) { this.embedHtml = embedHtml; }
    public void setTypeText(String typeText) { this.typeText = typeText; }
    public void setTypeBadgeClass(String typeBadgeClass) { this.typeBadgeClass = typeBadgeClass; }
} 
