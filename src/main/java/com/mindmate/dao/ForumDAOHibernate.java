package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.ArrayList;

@Repository
public class ForumDAOHibernate implements ForumDAO {

    private final SessionFactory sessionFactory;

    public ForumDAOHibernate(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
    public List<ForumPost> getAllPosts(String sortBy, String searchQuery, Integer currentUserId) {
        try (Session session = sessionFactory.openSession()) {
            StringBuilder hql = new StringBuilder(
                "SELECT p, (SELECT count(r) FROM ForumReply r WHERE r.post = p) FROM ForumPost p "
            );
            
            boolean hasSearch = (searchQuery != null && !searchQuery.isEmpty());
            if (hasSearch) {
                hql.append(" WHERE (lower(p.title) LIKE :search OR lower(p.content) LIKE :search)");
            }
            
            switch (sortBy != null ? sortBy : "recent") {
                case "popular": hql.append(" ORDER BY p.likes DESC"); break;
                case "helpful": hql.append(" ORDER BY p.helpfulCount DESC"); break;
                default: hql.append(" ORDER BY p.timestamp DESC"); break; 
            }

            Query<Object[]> query = session.createQuery(hql.toString(), Object[].class);
            if (hasSearch) {
                query.setParameter("search", "%" + searchQuery.toLowerCase() + "%");
            }
            
            List<Object[]> results = query.list();
            List<ForumPost> posts = new ArrayList<>();

            for (Object[] row : results) {
                ForumPost p = (ForumPost) row[0];
                p.setTotalReplies((Long) row[1]); 
                
                // ✅ SHADING LOGIC: Check if current user is in the ID sets
                if (currentUserId != null) {
                    p.setLikedByCurrentUser(p.getLikedUserIds().contains(currentUserId));
                    p.setHelpfulByCurrentUser(p.getHelpfulUserIds().contains(currentUserId));
                    p.setFlaggedByCurrentUser(p.getFlaggedUserIds().contains(currentUserId));
                }
                
                posts.add(p);
            }
            return posts;
        }
    }

    // ✅ NEW: TOGGLE INTERACTION (Likes & Helpful)
    public int[] toggleInteraction(int postId, int userId, String type) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            boolean isActive = false;
            int newCount = 0;

            if (post != null) {
                if ("like".equals(type)) {
                    if (post.getLikedUserIds().contains(userId)) {
                        post.getLikedUserIds().remove(userId);
                    } else {
                        post.getLikedUserIds().add(userId);
                        isActive = true;
                    }
                    post.setLikes(post.getLikedUserIds().size());
                    newCount = post.getLikes();
                } else if ("helpful".equals(type)) {
                    if (post.getHelpfulUserIds().contains(userId)) {
                        post.getHelpfulUserIds().remove(userId);
                    } else {
                        post.getHelpfulUserIds().add(userId);
                        isActive = true;
                    }
                    post.setHelpfulCount(post.getHelpfulUserIds().size());
                    newCount = post.getHelpfulCount();
                }
                session.merge(post);
            }
            tx.commit();
            return new int[]{isActive ? 1 : 0, newCount}; // Return status and count
        }
    }

    @Override
    public void flagPost(int postId) {
        // Updated to use a list of user IDs if you want to track WHO flagged it
        // Or keep your existing simple boolean flag logic:
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

    // Helper for Flag shading if you use the Set approach:
    public void toggleFlag(int postId, int userId) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                post.getFlaggedUserIds().add(userId);
                post.setFlagged(true); // Mark as flagged globally
                session.merge(post);
            }
            tx.commit();
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
    public ForumPost getPostById(int id) {
        try (Session session = sessionFactory.openSession()) {
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
            session.persist(reply); 
            ForumPost post = reply.getPost();
            post.getRepliesList().add(reply);
            session.merge(post);
            tx.commit();
        }
    }

    @Override
    public ForumReply getReplyById(int id) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(ForumReply.class, id);
        }
    }
}