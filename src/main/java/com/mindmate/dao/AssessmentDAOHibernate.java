package com.mindmate.dao;

import com.mindmate.model.Assessment;
import com.mindmate.model.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class AssessmentDAOHibernate implements AssessmentDAO {

    @PersistenceContext
    private EntityManager entityManager;

    // --- 1. GenericDAO Methods ---

    @Override
    @Transactional
    public void save(Assessment assessment) {
        entityManager.persist(assessment);
    }

    @Override
    @Transactional
    public void update(Assessment assessment) {
        entityManager.merge(assessment);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Assessment assessment = findById(id);
        if (assessment != null) {
            entityManager.remove(assessment);
        }
    }

    @Override
    public Assessment findById(Long id) {
        return entityManager.find(Assessment.class, id);
    }

    @Override
    public List<Assessment> findAll() {
        String jpql = "SELECT a FROM Assessment a";
        TypedQuery<Assessment> query = entityManager.createQuery(jpql, Assessment.class);
        return query.getResultList();
    }

    // --- 2. AssessmentDAO Specific Methods ---

    @Override
    public List<Assessment> findByStudent(Student student) {
        // Returns assessments for a specific student, sorted by date (newest first)
        String jpql = "SELECT a FROM Assessment a WHERE a.student = :student ORDER BY a.takenAt ASC";
        TypedQuery<Assessment> query = entityManager.createQuery(jpql, Assessment.class);
        query.setParameter("student", student);
        return query.getResultList();
    }

    public List<Assessment> findHistoryByStudent(Long studentId) {
        // Using JPQL (Java Persistence Query Language)
        String hql = "SELECT a FROM Assessment a WHERE a.student.id = :sId ORDER BY a.takenAt ASC";
        
        TypedQuery<Assessment> query = entityManager.createQuery(hql, Assessment.class);
        query.setParameter("sId", studentId);
        
        return query.getResultList();
    }
}