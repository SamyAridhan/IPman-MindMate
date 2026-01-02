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
        // Use openSession() so you don't need the 'current_session_context' config
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM ForumPost p WHERE 1=1";
            
            if (searchQuery != null && !searchQuery.isEmpty()) {
                hql += " AND (lower(p.title) LIKE :search OR lower(p.content) LIKE :search)";
            }
            
            switch (sortBy) {
                case "popular": hql += " ORDER BY p.likes DESC"; break;
                case "active": hql += " ORDER BY p.replies DESC"; break;
                case "helpful": hql += " ORDER BY p.helpfulCount DESC"; break;
                default: hql += " ORDER BY p.timestamp DESC"; break;
            }

            Query<ForumPost> query = session.createQuery(hql, ForumPost.class);
            if (searchQuery != null && !searchQuery.isEmpty()) {
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
            // We use HQL with "JOIN FETCH" to grab the replies while the session is open
            String hql = "SELECT p FROM ForumPost p " +
                        "LEFT JOIN FETCH p.repliesList " +
                        "WHERE p.id = :id";
            
            Query<ForumPost> query = session.createQuery(hql, ForumPost.class);
            query.setParameter("id", id);
            
            return query.uniqueResult();
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
                post.setReplies(post.getReplies() + 1);
                session.merge(post);
                
                tx.commit();
            } catch (Exception e) {
                if (tx != null) tx.rollback();
                throw e;
            }
        }
    }
}