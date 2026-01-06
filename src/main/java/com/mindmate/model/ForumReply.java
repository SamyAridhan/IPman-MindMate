package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.LinkedHashSet;

@Entity
@Table(name = "forum_replies")
public class ForumReply {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    private String author;
    
    @Column(name = "is_anonymous")
    private boolean anonymous;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "post_id")
    private ForumPost post;

    @ManyToOne
    @JoinColumn(name = "parent_id")
    private ForumReply parentReply;

    @OneToMany(mappedBy = "parentReply", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("createdAt ASC")
    private Set<ForumReply> children = new LinkedHashSet<>();

    public ForumReply() {}

    public ForumReply(String content, String author, ForumPost post, ForumReply parentReply, boolean isAnonymous) {
        this.content = content;
        this.author = author;
        this.post = post;
        this.parentReply = parentReply;
        this.anonymous = isAnonymous;
        this.createdAt = LocalDateTime.now();
    }

    // --- Getters and Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public boolean isAnonymous() { return anonymous; }
    public void setAnonymous(boolean anonymous) { this.anonymous = anonymous; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public ForumPost getPost() { return post; }
    public void setPost(ForumPost post) { this.post = post; }

    public ForumReply getParentReply() { return parentReply; }
    public void setParentReply(ForumReply parentReply) { this.parentReply = parentReply; }

    public Set<ForumReply> getChildren() { return children; }
    public void setChildren(Set<ForumReply> children) { this.children = children; }
}