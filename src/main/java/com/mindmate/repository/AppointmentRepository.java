// src/main/java/com/mindmate/repository/AppointmentRepository.java
package com.mindmate.repository;

import com.mindmate.model.Appointment;
import com.mindmate.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByStudent(Student student);
    List<Appointment> findByStudentOrderByDateDesc(Student student);
}