// src/main/java/com/mindmate/dao/SystemAnalyticsDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.SystemAnalytics;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Hibernate implementation of SystemAnalyticsDAO.
 * 
 * @author Samy (A23CS0246)
 * @module Admin Analytics
 */
@Repository
@Transactional
public class SystemAnalyticsDAOHibernate implements SystemAnalyticsDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(SystemAnalytics analytics) {
        entityManager.persist(analytics);
    }

    @Override
    public void update(SystemAnalytics analytics) {
        entityManager.merge(analytics);
    }

    @Override
    public void delete(Long id) {
        SystemAnalytics analytics = findById(id);
        if (analytics != null) {
            entityManager.remove(analytics);
        }
    }

    @Override
    public SystemAnalytics findById(Long id) {
        return entityManager.find(SystemAnalytics.class, id);
    }

    @Override
    public List<SystemAnalytics> findAll() {
        TypedQuery<SystemAnalytics> query = entityManager.createQuery(
            "SELECT s FROM SystemAnalytics s", SystemAnalytics.class);
        return query.getResultList();
    }

    @Override
    public Optional<SystemAnalytics> findLatestAnalytics() {
        TypedQuery<SystemAnalytics> query = entityManager.createQuery(
            "SELECT s FROM SystemAnalytics s ORDER BY s.recordedAt DESC", 
            SystemAnalytics.class);
        query.setMaxResults(1);
        
        try {
            return Optional.of(query.getSingleResult());
        } catch (Exception e) {
            return Optional.empty();
        }
    }
}