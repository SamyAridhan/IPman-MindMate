package com.mindmate.model;

import java.time.LocalDateTime;

public class ForumPost {
    private int id;
    private String title;
    private String content;
    private String category;
    private String author;
    private LocalDateTime timestamp;
    private int replies;
    private int likes;
    private int views;
    private int helpfulCount; // The new counter
    private boolean isFlagged = false; // Added field

    public ForumPost(int id, String title, String content, String category, String author, LocalDateTime timestamp,
            int replies, int likes, int views, int helpfulCount, boolean isFlagged) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.category = category;
        this.author = author;
        this.timestamp = timestamp;
        this.replies = replies;
        this.likes = likes;
        this.views = views;
        this.helpfulCount = helpfulCount;
        this.isFlagged = isFlagged;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public String getAuthor() {
        return author;
    }
    public void setAuthor(String author) {
        this.author = author;
    }
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
    public int getReplies() {
        return replies;
    }
    public void setReplies(int replies) {
        this.replies = replies;
    }
    public int getLikes() {
        return likes;
    }
    public void setLikes(int likes) {
        this.likes = likes;
    }
    public int getViews() {
        return views;
    }
    public void setViews(int views) {
        this.views = views;
    }
    public int getHelpfulCount() {
        return helpfulCount;
    }
    public void setHelpfulCount(int helpfulCount) {
        this.helpfulCount = helpfulCount;
    }
    public boolean isFlagged() {
        return isFlagged;
    }
    public void setFlagged(boolean isFlagged) {
        this.isFlagged = isFlagged;
    }
    
    
    
}