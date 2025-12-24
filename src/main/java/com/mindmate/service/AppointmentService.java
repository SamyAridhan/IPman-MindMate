// src/main/java/com/mindmate/service/AppointmentService.java

package com.mindmate.service;

import com.mindmate.model.Appointment;
import com.mindmate.model.Student;
import com.mindmate.repository.AppointmentRepository;
import com.mindmate.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Service layer for managing telehealth appointments.
 * Handles business logic for booking, canceling, and retrieving appointments.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
@Service
@Transactional
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private StudentRepository studentRepository;

    /**
     * Books a new telehealth appointment for a student.
     * 
     * @param studentId ID of the student booking the appointment
     * @param counselorName Name of the counselor to book with
     * @param dateStr Date string in format "MMM dd, yyyy" (e.g., "Dec 03, 2025")
     * @param timeStr Time string in format "HH:mm" (e.g., "14:00")
     * @param sessionType Type of session (e.g., "Individual Session (50 min)")
     * @return Saved Appointment entity
     * @throws RuntimeException if student not found
     */
    public Appointment bookAppointment(Long studentId, String counselorName, 
                                      String dateStr, String timeStr, String sessionType) {
        
        // Retrieve student from database
        Student student = studentRepository.findById(studentId)
            .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));

        // Create new appointment entity
        Appointment appointment = new Appointment();
        appointment.setStudent(student);
        appointment.setCounselorName(counselorName);
        
        // Parse date from frontend format (e.g., "Dec 03, 2025")
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
        appointment.setDate(LocalDate.parse(dateStr, dateFormatter));
        
        // Parse time from frontend format (e.g., "14:00")
        appointment.setTime(LocalTime.parse(timeStr));
        
        appointment.setSessionType(sessionType);
        appointment.setStatus(Appointment.AppointmentStatus.PENDING);

        // Persist to database
        return appointmentRepository.save(appointment);
    }

    /**
     * Retrieves all appointments for a specific student.
     * 
     * @param studentId ID of the student
     * @return List of appointments ordered by date (most recent first)
     * @throws RuntimeException if student not found
     */
    public List<Appointment> getStudentAppointments(Long studentId) {
        Student student = studentRepository.findById(studentId)
            .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));
        return appointmentRepository.findByStudentOrderByDateDesc(student);
    }

    /**
     * Cancels an appointment by deleting it from the database.
     * 
     * @param appointmentId ID of the appointment to cancel
     */
    public void cancelAppointment(Long appointmentId) {
        if (!appointmentRepository.existsById(appointmentId)) {
            throw new RuntimeException("Appointment not found with ID: " + appointmentId);
        }
        appointmentRepository.deleteById(appointmentId);
    }

    /**
     * Updates the status of an existing appointment.
     * Used by counselors to confirm or complete appointments.
     * 
     * @param appointmentId ID of the appointment
     * @param status New status to set
     * @return Updated Appointment entity
     * @throws RuntimeException if appointment not found
     */
    public Appointment updateAppointmentStatus(Long appointmentId, 
                                               Appointment.AppointmentStatus status) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
            .orElseThrow(() -> new RuntimeException("Appointment not found with ID: " + appointmentId));
        appointment.setStatus(status);
        return appointmentRepository.save(appointment);
    }

    /**
     * Retrieves all appointments in the system.
     * Primarily used for admin/counselor dashboards.
     * 
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAll();
    }
}