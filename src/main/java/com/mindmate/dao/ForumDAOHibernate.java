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
        // HQL: Select the post and a subquery count of all replies associated with it
        StringBuilder hql = new StringBuilder(
            "SELECT p, (SELECT count(r) FROM ForumReply r WHERE r.post = p) FROM ForumPost p "
        );
        
        boolean hasSearch = (searchQuery != null && !searchQuery.isEmpty());
        
        if (hasSearch) {
            hql.append(" WHERE (lower(p.title) LIKE :search OR lower(p.content) LIKE :search)");
        }
        
        // Sorting logic remains the same
        switch (sortBy) {
            case "popular": hql.append(" ORDER BY p.likes DESC"); break;
            case "helpful": hql.append(" ORDER BY p.helpfulCount DESC"); break;
            default: hql.append(" ORDER BY p.timestamp DESC"); break; 
        }

        // We use Object[] because the query returns [ForumPost, Long]
        Query<Object[]> query = session.createQuery(hql.toString(), Object[].class);
        
        if (hasSearch) {
            query.setParameter("search", "%" + searchQuery.toLowerCase() + "%");
        }
        
        List<Object[]> results = query.list();
        List<ForumPost> posts = new java.util.ArrayList<>();

        for (Object[] row : results) {
            ForumPost p = (ForumPost) row[0];
            // row[1] contains the result of the COUNT() subquery
            long count = (Long) row[1]; 
            
            // Set the count into the transient field in your model
            p.setTotalReplies(count); 
            posts.add(p);
        }
        
        return posts;
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