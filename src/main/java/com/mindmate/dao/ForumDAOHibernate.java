package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ForumDAOImpl implements ForumDAO {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public List<ForumPost> getAllPosts(String sortBy, String searchQuery) {
        Session session = sessionFactory.getCurrentSession();
        
        // Base Query
        String hql = "FROM ForumPost p WHERE 1=1";
        
        // 1. Apply Search
        if (searchQuery != null && !searchQuery.isEmpty()) {
            hql += " AND (lower(p.title) LIKE :search OR lower(p.content) LIKE :search)";
        }
        
        // 2. Apply Sorting
        switch (sortBy) {
            case "popular": hql += " ORDER BY p.likes DESC"; break;
            case "active": hql += " ORDER BY p.replies DESC"; break;
            case "helpful": hql += " ORDER BY p.helpfulCount DESC"; break;
            default: hql += " ORDER BY p.createdAt DESC"; break;
        }

        Query<ForumPost> query = session.createQuery(hql, ForumPost.class);
        if (searchQuery != null && !searchQuery.isEmpty()) {
            query.setParameter("search", "%" + searchQuery.toLowerCase() + "%");
        }
        
        return query.list();
    }

    @Override
    public void flagPost(int postId) {
        Session session = sessionFactory.getCurrentSession();
        ForumPost post = session.get(ForumPost.class, postId);
        if (post != null) {
            post.setFlagged(true);
            session.update(post);
        }
    }
    
    // Implement getPostById and saveOrUpdate similarly...
}