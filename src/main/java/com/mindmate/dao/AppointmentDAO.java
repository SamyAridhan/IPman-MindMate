package com.mindmate.dao;

import com.mindmate.model.Appointment;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentDAO extends GenericDAO<Appointment> {
    
    // ✅ EXISTING METHODS
    List<Appointment> findByStudent(Student student);
    List<Appointment> findByStudentOrderByDateDesc(Student student); // Kept for legacy/history view
    
    // ✅ NEW: Sort by Date ASC (Earliest first) then Time ASC
    List<Appointment> findByStudentOrderByDateAscTimeAsc(Student student);

    boolean existsById(Long id);
    long count();
    
    // ✅ COUNSELOR METHODS
    List<Appointment> findByCounselor(Counselor counselor);
    List<Appointment> findByCounselorAndStatus(Counselor counselor, Appointment.AppointmentStatus status);
    List<Appointment> findByCounselorAndDate(Counselor counselor, LocalDate date);
    boolean existsByCounselorAndDateAndTime(Counselor counselor, LocalDate date, LocalTime time);
    
    // ✅ STATS METHODS
    long countByStatus(Appointment.AppointmentStatus status);
    List<Appointment> findByStatus(Appointment.AppointmentStatus status);
}