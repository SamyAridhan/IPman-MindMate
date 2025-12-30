// src/main/java/com/mindmate/dao/StudentDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.hibernate.SessionFactory;

import java.time.LocalDate;
import org.hibernate.Session;
import java.util.List;
import java.util.Optional;
import org.hibernate.Transaction;

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

    private final SessionFactory sessionFactory;

    public StudentDAOHibernate(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

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

    // new
    @Override
    public void updatePointsAndStreak(Long studentId, int pointsToAdd) {
        Session session = sessionFactory.openSession();
        Transaction tx = null;
        
        try {
            tx = session.beginTransaction();
            Student student = session.get(Student.class, studentId);
            
            if (student != null) {
                LocalDate today = LocalDate.now();
                LocalDate lastDate = student.getLastCompletionDate();
                
                // 1. Calculate Streak
                if (lastDate == null) {
                    // First time ever completing a module
                    student.setCurrentStreak(1);
                } else if (lastDate.equals(today.minusDays(1))) {
                    // Completed yesterday! Increment streak
                    student.setCurrentStreak(student.getCurrentStreak() + 1);
                } else if (lastDate.isBefore(today.minusDays(1))) {
                    // Missed a day or more. Reset streak
                    student.setCurrentStreak(1);
                }
                // If lastDate.equals(today), streak stays the same (they did multiple today)

                // 2. Update Points
                int currentPoints = student.getTotalPoints() != null ? student.getTotalPoints() : 0;
                student.setTotalPoints(currentPoints + pointsToAdd);
                
                // 3. Update Last Completion Date
                student.setLastCompletionDate(today);
                
                session.merge(student);
            }
            
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}