package com.mindmate.dao;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * DAO interface for Appointment entity operations.
 * Updates: Added methods for Counselor filtering and slot validation.
 */
public interface AppointmentDAO extends GenericDAO<Appointment> {
    
    // ✅ EXISTING METHODS
    List<Appointment> findByStudent(Student student);
    List<Appointment> findByStudentOrderByDateDesc(Student student);
    boolean existsById(Long id);
    long count();
    
    // ✅ NEW METHODS (Phase 3)
    
    /**
     * Finds all appointments for a specific counselor.
     */
    List<Appointment> findByCounselor(Counselor counselor);
    
    /**
     * Finds appointments for a counselor by status (e.g., PENDING requests).
     */
    List<Appointment> findByCounselorAndStatus(Counselor counselor, Appointment.AppointmentStatus status);
    
    /**
     * Finds appointments for a counselor on a specific date (for calendar view).
     */
    List<Appointment> findByCounselorAndDate(Counselor counselor, LocalDate date);
    
    /**
     * Checks if a counselor has an appointment at a specific date/time.
     * Used to prevent double-booking.
     */
    boolean existsByCounselorAndDateAndTime(Counselor counselor, LocalDate date, LocalTime time);
    
    /**
     * Counts appointments by status (for dashboard stats).
     */
    long countByStatus(Appointment.AppointmentStatus status);
    
    /**
     * Finds appointments by status (for admin analytics).
     */
    List<Appointment> findByStatus(Appointment.AppointmentStatus status);
}