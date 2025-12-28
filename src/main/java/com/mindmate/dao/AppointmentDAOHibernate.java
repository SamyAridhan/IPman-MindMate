// src/main/java/com/mindmate/dao/AppointmentDAOHibernate.java

package com.mindmate.dao;

import com.mindmate.model.Appointment;
import com.mindmate.model.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Hibernate implementation of AppointmentDAO.
 * Handles all database operations for appointments.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
@Repository
@Transactional
public class AppointmentDAOHibernate implements AppointmentDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(Appointment appointment) {
        entityManager.persist(appointment);
    }

    @Override
    public void update(Appointment appointment) {
        entityManager.merge(appointment);
    }

    @Override
    public void delete(Long id) {
        Appointment appointment = findById(id);
        if (appointment != null) {
            entityManager.remove(appointment);
        }
    }

    @Override
    public Appointment findById(Long id) {
        return entityManager.find(Appointment.class, id);
    }

    @Override
    public List<Appointment> findAll() {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a", Appointment.class);
        return query.getResultList();
    }

    @Override
    public List<Appointment> findByStudent(Student student) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.student = :student", 
            Appointment.class);
        query.setParameter("student", student);
        return query.getResultList();
    }

    @Override
    public List<Appointment> findByStudentOrderByDateDesc(Student student) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.student = :student ORDER BY a.date DESC", 
            Appointment.class);
        query.setParameter("student", student);
        return query.getResultList();
    }

    @Override
    public boolean existsById(Long id) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(a) FROM Appointment a WHERE a.id = :id", Long.class);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }

    @Override
    public long count() {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(a) FROM Appointment a", Long.class);
        return query.getSingleResult();
    }
}