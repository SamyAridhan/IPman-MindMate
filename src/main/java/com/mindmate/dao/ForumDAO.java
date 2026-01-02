package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import java.util.List;

public interface ForumDAO {
    List<ForumPost> getAllPosts(String sortBy, String searchQuery);
    ForumPost getPostById(int id);
    void saveOrUpdate(ForumPost post);
    void flagPost(int postId);
}