package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;

import java.util.List;

public interface ForumDAO {
    List<ForumPost> getAllPosts(String sortBy, String searchQuery, Integer currentUserId);
    ForumPost getPostById(int id);
    void saveOrUpdate(ForumPost post);
    void flagPost(int postId);
    void saveReply(ForumReply reply);

    // Inside src/main/java/com/mindmate/dao/ForumDAO.java
    ForumReply getReplyById(int id);
    void deletePost(int postId);

    List<ForumPost> getFlaggedPosts();
    long getTotalPostCount();
    void unflagPost(int postId); // This is the "Approve" action
}