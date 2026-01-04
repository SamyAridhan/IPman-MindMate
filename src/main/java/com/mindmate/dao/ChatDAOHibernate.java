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
        // entityManager.persist() takes the Java object and inserts it as a row in SQL
        entityManager.persist(message);
    }

    @Override
    public List<ChatMessage> getAllMessages() {
        // HQL uses the Class Name (ChatMessage) not the table name
        String hql = "FROM ChatMessage c ORDER BY c.timestamp ASC";
        return entityManager.createQuery(hql, ChatMessage.class).getResultList();
    }

    @Override
    @Transactional
    public void clearHistory() {
        // Useful if you want to allow students to delete their chat logs
        entityManager.createQuery("DELETE FROM ChatMessage").executeUpdate();
    }
}