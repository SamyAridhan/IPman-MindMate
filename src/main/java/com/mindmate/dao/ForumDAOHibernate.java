package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class ForumDAOHibernate implements ForumDAO {

    private final SessionFactory sessionFactory;

    // Constructor injection (like your teammate)
    public ForumDAOHibernate(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
public List<ForumPost> getAllPosts(String sortBy, String searchQuery) {
    try (Session session = sessionFactory.openSession()) {
        // Use SELECT DISTINCT to prevent duplicates from the LEFT JOIN FETCH
        StringBuilder hql = new StringBuilder("SELECT DISTINCT p FROM ForumPost p LEFT JOIN FETCH p.repliesList ");
        
        boolean hasSearch = (searchQuery != null && !searchQuery.isEmpty());
        
        if (hasSearch) {
            hql.append(" WHERE (lower(p.title) LIKE :search OR lower(p.content) LIKE :search)");
        }
        
        switch (sortBy) {
            case "popular": hql.append(" ORDER BY p.likes DESC"); break;
            case "helpful": hql.append(" ORDER BY p.helpfulCount DESC"); break;
            // ✅ Fix: Changed p.createdAt to p.timestamp to match your ForumPost model
            default: hql.append(" ORDER BY p.timestamp DESC"); break; 
        }

        Query<ForumPost> query = session.createQuery(hql.toString(), ForumPost.class);
        if (hasSearch) {
            query.setParameter("search", "%" + searchQuery.toLowerCase() + "%");
        }
        
        return query.list();
    }
}

    @Override
    public void saveOrUpdate(ForumPost post) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            session.merge(post);
            tx.commit();
        }
    }

    @Override
    public void flagPost(int postId) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                post.setFlagged(true);
                session.merge(post);
            }
            tx.commit();
        }
    }

    @Override
    public ForumPost getPostById(int id) {
        try (Session session = sessionFactory.openSession()) {
            // Now that these are Sets, Hibernate can handle the double join
            String hql = "SELECT DISTINCT p FROM ForumPost p " +
                         "LEFT JOIN FETCH p.repliesList r " +
                         "LEFT JOIN FETCH r.children " +
                         "WHERE p.id = :id";
            
            return session.createQuery(hql, ForumPost.class)
                          .setParameter("id", id)
                          .uniqueResult();
        }
    }
    @Override
    public void saveReply(ForumReply reply) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            try {
                // We save the reply directly
                session.persist(reply); 
                
                // We also update the post's reply count
                ForumPost post = reply.getPost();
                post.getRepliesList().add(reply);
                session.merge(post);
                
                tx.commit();
            } catch (Exception e) {
                if (tx != null) tx.rollback();
                throw e;
            }
        }
    }

    // Inside src/main/java/com/mindmate/dao/ForumDAOHibernate.java
    @Override
    public ForumReply getReplyById(int id) {
        try (Session session = sessionFactory.openSession()) {
            // We use session.get to find the reply by its primary key
            return session.get(ForumReply.class, id);
        }
    }
}