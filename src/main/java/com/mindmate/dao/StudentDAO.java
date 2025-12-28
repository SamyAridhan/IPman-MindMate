// src/main/java/com/mindmate/dao/StudentDAO.java

package com.mindmate.dao;

import com.mindmate.model.Student;
import java.util.Optional;

/**
 * DAO interface for Student entity operations.
 * Extends GenericDAO with Student-specific query methods.
 * 
 * @author Samy (A23CS0246)
 */
public interface StudentDAO extends GenericDAO<Student> {
    
    /**
     * Finds a student by email address.
     * @param email The student's email
     * @return Optional containing student if found
     */
    Optional<Student> findByEmail(String email);
    
    /**
     * Checks if a student with the given email exists.
     * @param email The email to check
     * @return true if exists, false otherwise
     */
    boolean existsByEmail(String email);
    
    /**
     * Counts total number of students.
     * @return Total student count
     */
    long count();
}