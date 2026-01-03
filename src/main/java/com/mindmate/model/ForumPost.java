package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.HashSet;
import java.util.LinkedHashSet;

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
    private Set<ForumReply> repliesList = new LinkedHashSet<>();

    @Transient 
    private long totalReplies;

    // ✅ AUTOMATIC JOIN TABLES (For Group Coordination)
    // Hibernate will create these tables automatically for your teammates.
    // Using a Set ensures a user can only be in the list once (1 like per user).

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_likes", joinColumns = @JoinColumn(name = "post_id"))
    @Column(name = "user_id")
    private Set<Integer> likedUserIds = new HashSet<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_helpful", joinColumns = @JoinColumn(name = "post_id"))
    @Column(name = "user_id")
    private Set<Integer> helpfulUserIds = new HashSet<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_flags", joinColumns = @JoinColumn(name = "post_id"))
    @Column(name = "user_id")
    private Set<Integer> flaggedUserIds = new HashSet<>();

    // ✅ TRANSIENT FIELDS FOR JSP SHADING
    @Transient
    private boolean likedByCurrentUser = false;
    
    @Transient
    private boolean helpfulByCurrentUser = false;

    @Transient
    private boolean flaggedByCurrentUser = false;

    // --- Constructors ---
    public ForumPost() {
        this.timestamp = LocalDateTime.now();
    }

    public ForumPost(String title, String content, String category, String author, boolean isAnonymous) {
        this.title = title;
        this.content = content;
        this.category = category;
        this.author = author;
        this.isAnonymous = isAnonymous;
        this.timestamp = LocalDateTime.now();
    }

    // --- Standard Getters and Setters ---
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

    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }

    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }

    public int getHelpfulCount() { return helpfulCount; }
    public void setHelpfulCount(int helpfulCount) { this.helpfulCount = helpfulCount; }

    public boolean isFlagged() { return isFlagged; }
    public void setFlagged(boolean isFlagged) { this.isFlagged = isFlagged; }

    public boolean isAnonymous() { return isAnonymous; }
    public void setAnonymous(boolean anonymous) { isAnonymous = anonymous; }

    public int getReplies() { return replies; }
    public void setReplies(int replies) { this.replies = replies; }

    public Set<ForumReply> getRepliesList() { return repliesList; }
    public void setRepliesList(Set<ForumReply> repliesList) { this.repliesList = repliesList; }

    public long getTotalReplies() { return totalReplies; }
    public void setTotalReplies(long totalReplies) { this.totalReplies = totalReplies; }

    // --- ✅ Getters/Setters for Collections (Logic) ---

    public Set<Integer> getLikedUserIds() { return likedUserIds; }
    public void setLikedUserIds(Set<Integer> likedUserIds) { this.likedUserIds = likedUserIds; }

    public Set<Integer> getHelpfulUserIds() { return helpfulUserIds; }
    public void setHelpfulUserIds(Set<Integer> helpfulUserIds) { this.helpfulUserIds = helpfulUserIds; }

    public Set<Integer> getFlaggedUserIds() { return flaggedUserIds; }
    public void setFlaggedUserIds(Set<Integer> flaggedUserIds) { this.flaggedUserIds = flaggedUserIds; }

    // --- ✅ Getters/Setters for Transient UI Shading ---
    
    // Change the getter names to start with "get" instead of "is" 
// This is the most reliable way to make JSP/EL find them.

public boolean getLikedByCurrentUser() { 
    return likedByCurrentUser; 
}
public void setLikedByCurrentUser(boolean likedByCurrentUser) { 
    this.likedByCurrentUser = likedByCurrentUser; 
}

public boolean getHelpfulByCurrentUser() { 
    return helpfulByCurrentUser; 
}
public void setHelpfulByCurrentUser(boolean helpfulByCurrentUser) { 
    this.helpfulByCurrentUser = helpfulByCurrentUser; 
}

public boolean getFlaggedByCurrentUser() { 
    return flaggedByCurrentUser; 
}
public void setFlaggedByCurrentUser(boolean flaggedByCurrentUser) { 
    this.flaggedByCurrentUser = flaggedByCurrentUser; 
}
}