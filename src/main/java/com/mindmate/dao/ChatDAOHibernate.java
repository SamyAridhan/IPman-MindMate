package com.mindmate.dao;

import com.mindmate.model.ChatMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class ChatDAOHibernate implements ChatDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public void saveMessage(ChatMessage message) {
        entityManager.persist(message);
    }

    @Override
    public List<ChatMessage> getAllMessages() {
        String hql = "FROM ChatMessage c ORDER BY c.timestamp ASC";
        return entityManager.createQuery(hql, ChatMessage.class).getResultList();
    }

    @Override
    @Transactional
    public void clearHistory() {
        entityManager.createQuery("DELETE FROM ChatMessage").executeUpdate();
    }

    @Override
    public List<ChatMessage> getMessagesBySession(String sessionId) {
        return entityManager.createQuery(
            "FROM ChatMessage m WHERE m.sessionId = :s ORDER BY m.timestamp ASC", ChatMessage.class)
            .setParameter("s", sessionId)
            .getResultList();
    }
    
    @Override
    public List<String> getUniqueSessionsByStudent(Long studentId) {
        // FIX: We group by sessionId and order by the latest message in that session
        // This ensures the most recent conversations appear at the top of your sidebar
        return entityManager.createQuery(
            "SELECT m.sessionId FROM ChatMessage m WHERE m.student.id = :id " +
            "GROUP BY m.sessionId ORDER BY MAX(m.timestamp) DESC", String.class)
            .setParameter("id", studentId)
            .getResultList();
    }
}