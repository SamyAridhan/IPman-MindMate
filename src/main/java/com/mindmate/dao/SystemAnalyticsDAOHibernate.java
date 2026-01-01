package com.mindmate.dao;

import com.mindmate.model.SystemAnalytics;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Hibernate implementation of SystemAnalyticsDAO.
 * Handles database queries for analytics reports.
 */
@Repository
@Transactional
public class SystemAnalyticsDAOHibernate implements SystemAnalyticsDAO {

    @PersistenceContext
    private EntityManager entityManager;

    // ✅ EXISTING METHODS (Unchanged)
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
            "SELECT s FROM SystemAnalytics s ORDER BY s.recordedAt DESC", 
            SystemAnalytics.class);
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

    // ✅ NEW IMPLEMENTATIONS (Safe for existing data)

    @Override
    public List<SystemAnalytics> findByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        TypedQuery<SystemAnalytics> query = entityManager.createQuery(
            "SELECT s FROM SystemAnalytics s WHERE s.recordedAt BETWEEN :start AND :end " +
            "ORDER BY s.recordedAt DESC", 
            SystemAnalytics.class);
        query.setParameter("start", startDate);
        query.setParameter("end", endDate);
        return query.getResultList();
    }
    
    @Override
    public List<SystemAnalytics> findRecentSnapshots(int limit) {
        TypedQuery<SystemAnalytics> query = entityManager.createQuery(
            "SELECT s FROM SystemAnalytics s ORDER BY s.recordedAt DESC", 
            SystemAnalytics.class);
        query.setMaxResults(limit);
        return query.getResultList();
    }
    
    @Override
    public List<SystemAnalytics> findMonthlySnapshots(int months) {
        // Simple logic: Get all snapshots from the cutoff date
        // Advanced logic (group by month) is harder in HQL, so we filter in code or just fetch range
        LocalDateTime cutoffDate = LocalDateTime.now().minusMonths(months);
        
        TypedQuery<SystemAnalytics> query = entityManager.createQuery(
            "SELECT s FROM SystemAnalytics s WHERE s.recordedAt >= :cutoff " +
            "ORDER BY s.recordedAt ASC", 
            SystemAnalytics.class);
        query.setParameter("cutoff", cutoffDate);
        
        return query.getResultList();
    }
}