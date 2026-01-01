package com.mindmate.dao;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Hibernate implementation of AppointmentDAO.
 * Handles database operations including new Counselor-specific queries.
 */
@Repository
@Transactional
public class AppointmentDAOHibernate implements AppointmentDAO {

    @PersistenceContext
    private EntityManager entityManager;

    // ✅ EXISTING METHODS
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

    // ✅ NEW IMPLEMENTATIONS

    @Override
    public List<Appointment> findByCounselor(Counselor counselor) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.counselor = :counselor ORDER BY a.date DESC", 
            Appointment.class);
        query.setParameter("counselor", counselor);
        return query.getResultList();
    }

    @Override
    public List<Appointment> findByCounselorAndStatus(Counselor counselor, Appointment.AppointmentStatus status) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.counselor = :counselor AND a.status = :status ORDER BY a.date DESC", 
            Appointment.class);
        query.setParameter("counselor", counselor);
        query.setParameter("status", status);
        return query.getResultList();
    }

    @Override
    public List<Appointment> findByCounselorAndDate(Counselor counselor, LocalDate date) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.counselor = :counselor AND a.date = :date ORDER BY a.time ASC", 
            Appointment.class);
        query.setParameter("counselor", counselor);
        query.setParameter("date", date);
        return query.getResultList();
    }

    @Override
    public boolean existsByCounselorAndDateAndTime(Counselor counselor, LocalDate date, LocalTime time) {
        // Smart Logic: Don't count "CANCELLED" appointments as taken slots
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(a) FROM Appointment a WHERE a.counselor = :counselor " +
            "AND a.date = :date AND a.time = :time AND a.status != :cancelledStatus", 
            Long.class);
        
        query.setParameter("counselor", counselor);
        query.setParameter("date", date);
        query.setParameter("time", time);
        query.setParameter("cancelledStatus", Appointment.AppointmentStatus.CANCELLED);
        
        return query.getSingleResult() > 0;
    }

    @Override
    public long countByStatus(Appointment.AppointmentStatus status) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(a) FROM Appointment a WHERE a.status = :status", Long.class);
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    @Override
    public List<Appointment> findByStatus(Appointment.AppointmentStatus status) {
        TypedQuery<Appointment> query = entityManager.createQuery(
            "SELECT a FROM Appointment a WHERE a.status = :status ORDER BY a.date DESC", 
            Appointment.class);
        query.setParameter("status", status);
        return query.getResultList();
    }
}