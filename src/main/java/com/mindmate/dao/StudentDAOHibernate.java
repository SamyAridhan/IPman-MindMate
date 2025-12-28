// src/main/java/com/mindmate/dao/StudentDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Hibernate implementation of StudentDAO.
 * Uses JPA EntityManager for database operations.
 * 
 * @author Samy (A23CS0246)
 */
@Repository
@Transactional
public class StudentDAOHibernate implements StudentDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(Student student) {
        entityManager.persist(student);
    }

    @Override
    public void update(Student student) {
        entityManager.merge(student);
    }

    @Override
    public void delete(Long id) {
        Student student = findById(id);
        if (student != null) {
            entityManager.remove(student);
        }
    }

    @Override
    public Student findById(Long id) {
        return entityManager.find(Student.class, id);
    }

    @Override
    public List<Student> findAll() {
        TypedQuery<Student> query = entityManager.createQuery(
            "SELECT s FROM Student s", Student.class);
        return query.getResultList();
    }

    @Override
    public Optional<Student> findByEmail(String email) {
        TypedQuery<Student> query = entityManager.createQuery(
            "SELECT s FROM Student s WHERE s.email = :email", Student.class);
        query.setParameter("email", email);
        
        try {
            return Optional.of(query.getSingleResult());
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(s) FROM Student s WHERE s.email = :email", Long.class);
        query.setParameter("email", email);
        return query.getSingleResult() > 0;
    }

    @Override
    public long count() {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(s) FROM Student s", Long.class);
        return query.getSingleResult();
    }
}