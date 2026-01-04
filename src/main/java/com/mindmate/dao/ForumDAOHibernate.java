package com.mindmate.dao;

import com.mindmate.model.ForumPost;
import com.mindmate.model.ForumReply;
import com.mindmate.model.ModerationStats;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import java.util.Set; // Add this line
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

    // --- NEW ADMIN MODERATION METHODS ---

    @Override
    public List<ForumPost> getFlaggedPosts() {
        try (Session session = sessionFactory.openSession()) {
            // Fetch posts where isFlagged is true, including reply count for the UI
            String hql = "SELECT p, (SELECT count(r) FROM ForumReply r WHERE r.post = p) " +
                         "FROM ForumPost p WHERE p.isFlagged = true ORDER BY p.timestamp DESC";
            
            List<Object[]> results = session.createQuery(hql, Object[].class).list();
            List<ForumPost> flaggedPosts = new ArrayList<>();

            for (Object[] row : results) {
                ForumPost p = (ForumPost) row[0];
                p.setTotalReplies((Long) row[1]);
                flaggedPosts.add(p);
            }
            return flaggedPosts;
        }
    }

    @Override
    public long getTotalPostCount() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("SELECT count(p) FROM ForumPost p", Long.class).uniqueResult();
        }
    }

    @Override
    public void unflagPost(int postId) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                post.setFlagged(false);
                // Clear the user IDs who flagged it to reset the state
                if (post.getFlaggedUserIds() != null) {
                    post.getFlaggedUserIds().clear();
                }
                session.merge(post);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    // --- EXISTING METHODS ---

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
    public void saveOrUpdate(ForumPost post) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            session.merge(post);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    @Override
    public void deletePost(int postId) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                session.remove(post); 
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    @Override
    public void saveReply(ForumReply reply) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            session.persist(reply); 
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    @Override
    public ForumReply getReplyById(int id) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(ForumReply.class, id);
        }
    }

    @Override
    public void flagPost(int postId) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                post.setFlagged(true);
                session.merge(post);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    // Inside ForumDAOHibernate
// Increment logic for "Approved" stats
public void incrementApprovedCount() {
    Transaction tx = null;
    try (Session session = sessionFactory.openSession()) {
        tx = session.beginTransaction();
        
        // Fetch the single stats record (using a hardcoded ID like "global_stats")
        ModerationStats stats = session.get(ModerationStats.class, "global_stats");
        
        if (stats == null) {
            stats = new ModerationStats();
            stats.setId("global_stats");
        }
        
        stats.setApprovedCount(stats.getApprovedCount() + 1);
        
        // Use merge() instead of saveOrUpdate() to fix deprecation
        session.merge(stats); 
        
        tx.commit();
    } catch (Exception e) {
        if (tx != null) tx.rollback();
        e.printStackTrace();
    }
}

    // Increment logic for "Deleted" stats
    public void incrementDeletedCount() {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            
            ModerationStats stats = session.get(ModerationStats.class, "global_stats");
            
            if (stats == null) {
                stats = new ModerationStats();
                stats.setId("global_stats");
            }
            
            stats.setDeletedCount(stats.getDeletedCount() + 1);
            
            session.merge(stats); // Fixes deprecation
            
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    @Override
    public ModerationStats getModerationStats() {
        try (Session session = sessionFactory.openSession()) {
            // Fetch the single stats record
            ModerationStats stats = session.get(ModerationStats.class, "global_stats");
            
            // If it doesn't exist yet, return a new one with 0 counts so the JSP doesn't crash
            if (stats == null) {
                return new ModerationStats();
            }
            return stats;
        }
    }

    @Override
    public boolean toggleFlag(int postId, int userId) {
        Transaction tx = null;
        boolean isNowFlagged = false;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            ForumPost post = session.get(ForumPost.class, postId);
            if (post != null) {
                Set<Integer> flaggedUsers = post.getFlaggedUserIds();
                if (flaggedUsers.contains(userId)) {
                    flaggedUsers.remove(userId);
                    isNowFlagged = false;
                } else {
                    flaggedUsers.add(userId);
                    isNowFlagged = true;
                }
                // Update global status: flagged if the set is not empty
                post.setFlagged(!flaggedUsers.isEmpty());
                session.merge(post);
            }
            tx.commit();
            return isNowFlagged;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }
}