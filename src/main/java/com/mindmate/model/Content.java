package com.mindmate.model;

public class Content {
    private Long id;
    private String title;
    private String type;
    private String description;
    private String content;

    public Content() {
    }

    public Content(Long id, String title, String type, String description, String content) {
        this.id = id;
        this.title = title;
        this.type = type;
        this.description = description;
        this.content = content;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
