// src/main/java/com/mindmate/dao/CounselorDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.Counselor;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Hibernate implementation of CounselorDAO.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
@Repository
@Transactional
public class CounselorDAOHibernate implements CounselorDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(Counselor counselor) {
        entityManager.persist(counselor);
    }

    @Override
    public void update(Counselor counselor) {
        entityManager.merge(counselor);
    }

    @Override
    public void delete(Long id) {
        Counselor counselor = findById(id);
        if (counselor != null) {
            entityManager.remove(counselor);
        }
    }

    @Override
    public Counselor findById(Long id) {
        return entityManager.find(Counselor.class, id);
    }

    @Override
    public List<Counselor> findAll() {
        TypedQuery<Counselor> query = entityManager.createQuery(
            "SELECT c FROM Counselor c", Counselor.class);
        return query.getResultList();
    }

    @Override
    public Optional<Counselor> findByEmail(String email) {
        TypedQuery<Counselor> query = entityManager.createQuery(
            "SELECT c FROM Counselor c WHERE c.email = :email", Counselor.class);
        query.setParameter("email", email);
        
        try {
            return Optional.of(query.getSingleResult());
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Counselor> findByAvailability(String availability) {
        TypedQuery<Counselor> query = entityManager.createQuery(
            "SELECT c FROM Counselor c WHERE c.availability = :availability", 
            Counselor.class);
        query.setParameter("availability", availability);
        return query.getResultList();
    }

    @Override
    public List<Counselor> findBySpecialization(String specialization) {
        TypedQuery<Counselor> query = entityManager.createQuery(
            "SELECT c FROM Counselor c WHERE c.specialization = :specialization", 
            Counselor.class);
        query.setParameter("specialization", specialization);
        return query.getResultList();
    }

    @Override
    public List<Counselor> findAllOrderByRatingDesc() {
        TypedQuery<Counselor> query = entityManager.createQuery(
            "SELECT c FROM Counselor c ORDER BY c.rating DESC", Counselor.class);
        return query.getResultList();
    }
}