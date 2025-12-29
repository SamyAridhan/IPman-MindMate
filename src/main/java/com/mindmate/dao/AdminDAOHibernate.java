// src/main/java/com/mindmate/dao/AdminDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.Admin;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Hibernate implementation of AdminDAO.
 * 
 * @author Samy (A23CS0246)
 */
@Repository
@Transactional
public class AdminDAOHibernate implements AdminDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(Admin admin) {
        entityManager.persist(admin);
    }

    @Override
    public void update(Admin admin) {
        entityManager.merge(admin);
    }

    @Override
    public void delete(Long id) {
        Admin admin = findById(id);
        if (admin != null) {
            entityManager.remove(admin);
        }
    }

    @Override
    public Admin findById(Long id) {
        return entityManager.find(Admin.class, id);
    }

    @Override
    public List<Admin> findAll() {
        TypedQuery<Admin> query = entityManager.createQuery(
            "SELECT a FROM Admin a", Admin.class);
        return query.getResultList();
    }

    @Override
    public Optional<Admin> findByEmail(String email) {
        TypedQuery<Admin> query = entityManager.createQuery(
            "SELECT a FROM Admin a WHERE a.email = :email", Admin.class);
        query.setParameter("email", email);
        
        try {
            return Optional.of(query.getSingleResult());
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public long count() {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(a) FROM Admin a", Long.class);
        return query.getSingleResult();
    }
}