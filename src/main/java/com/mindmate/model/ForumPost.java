package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "forum_posts")
public class ForumPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    private String category;
    private String author;

    // ✅ NEW ATTRIBUTE
    @Column(name = "is_anonymous")
    private boolean isAnonymous = false; 

    @Column(name = "created_at")
    private LocalDateTime timestamp;

    private int replies = 0;
    private int likes = 0;
    private int views = 0;

    @Column(name = "helpful_count")
    private int helpfulCount = 0;

    @Column(name = "is_flagged")
    private boolean isFlagged = false;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("createdAt ASC")
    private List<ForumReply> repliesList;

    public ForumPost() {
    }

    // Updated Constructor to include anonymity choice
    public ForumPost(String title, String content, String category, String author, boolean isAnonymous) {
        this.title = title;
        this.content = content;
        this.category = category;
        this.author = author;
        this.isAnonymous = isAnonymous;
        this.timestamp = LocalDateTime.now();
    }

    // --- Getters and Setters (Same as yours) ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }

    public int getReplies() { return replies; }
    public void setReplies(int replies) { this.replies = replies; }

    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }

    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }

    public int getHelpfulCount() { return helpfulCount; }
    public void setHelpfulCount(int helpfulCount) { this.helpfulCount = helpfulCount; }

    public boolean isFlagged() { return isFlagged; }
    public void setFlagged(boolean isFlagged) { this.isFlagged = isFlagged; }

    // ✅ Getter and Setter for isAnonymous
    public boolean isAnonymous() {
        return isAnonymous;
    }
    
    public void setAnonymous(boolean anonymous) {
        isAnonymous = anonymous;
    }

    // ✅ ADD GETTER/SETTER AT THE END
    public List<ForumReply> getRepliesList() { 
        return repliesList; 
    }
    
    public void setRepliesList(List<ForumReply> repliesList) { 
        this.repliesList = repliesList; 
    }
    
}