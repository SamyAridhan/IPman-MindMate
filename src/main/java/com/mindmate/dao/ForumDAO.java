package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import com.mindmate.model.ModerationStats;

import java.util.List;

public interface ForumDAO {
    List<ForumPost> getAllPosts(String sortBy, String searchQuery, Integer currentUserId);
    ForumPost getPostById(int id);
    void saveOrUpdate(ForumPost post);
    void flagPost(int postId);
    void saveReply(ForumReply reply);

    ForumReply getReplyById(int id);
    void deletePost(int postId);

    List<ForumPost> getFlaggedPosts();
    long getTotalPostCount();
    void unflagPost(int postId); // This is the "Approve" action

    void incrementDeletedCount();
    void incrementApprovedCount();
    ModerationStats getModerationStats();
    boolean toggleFlag(int postId, int userId);

}