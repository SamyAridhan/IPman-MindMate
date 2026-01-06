package com.mindmate.dao;

import com.mindmate.model.ChatMessage;
import com.mindmate.model.Student;
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

    // NEW: Count messages in a session for a student
    @Override
    public long countByStudentAndSessionId(Student student, String sessionId) {
        Long count = entityManager.createQuery(
            "SELECT COUNT(m) FROM ChatMessage m WHERE m.student = :student AND m.sessionId = :sessionId", 
            Long.class)
            .setParameter("student", student)
            .setParameter("sessionId", sessionId)
            .getSingleResult();
        return count != null ? count : 0;
    }

    // NEW: Get session titles (first user message of each session) for sidebar
    @Override
    public List<ChatMessage> getSessionTitlesByStudent(Student student) {
        return entityManager.createQuery(
            "FROM ChatMessage m WHERE m.student = :student AND m.role = 'user' AND m.title IS NOT NULL " +
            "ORDER BY m.timestamp DESC", 
            ChatMessage.class)
            .setParameter("student", student)
            .getResultList();
    }

    // NEW: Get messages for a student in a specific session
    @Override
    public List<ChatMessage> getMessagesByStudentAndSession(Student student, String sessionId) {
        return entityManager.createQuery(
            "FROM ChatMessage m WHERE m.student = :student AND m.sessionId = :sessionId " +
            "ORDER BY m.timestamp ASC", 
            ChatMessage.class)
            .setParameter("student", student)
            .setParameter("sessionId", sessionId)
            .getResultList();
    }
}