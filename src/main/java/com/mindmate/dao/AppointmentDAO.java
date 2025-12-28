// src/main/java/com/mindmate/dao/AppointmentDAO.java

package com.mindmate.dao;

import com.mindmate.model.Appointment;
import com.mindmate.model.Student;
import java.util.List;

/**
 * DAO interface for Appointment entity operations.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
public interface AppointmentDAO extends GenericDAO<Appointment> {
    
    /**
     * Finds all appointments for a specific student.
     * @param student The student entity
     * @return List of appointments
     */
    List<Appointment> findByStudent(Student student);
    
    /**
     * Finds all appointments for a student, ordered by date descending.
     * @param student The student entity
     * @return List of appointments (newest first)
     */
    List<Appointment> findByStudentOrderByDateDesc(Student student);
    
    /**
     * Checks if an appointment exists by ID.
     * @param id Appointment ID
     * @return true if exists, false otherwise
     */
    boolean existsById(Long id);
    
    /**
     * Counts total number of appointments.
     * @return Total appointment count
     */
    long count();
}