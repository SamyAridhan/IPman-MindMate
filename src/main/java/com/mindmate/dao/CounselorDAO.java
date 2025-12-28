// src/main/java/com/mindmate/dao/CounselorDAO.java

package com.mindmate.dao;

import com.mindmate.model.Counselor;
import java.util.List;
import java.util.Optional;

/**
 * DAO interface for Counselor entity operations.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
public interface CounselorDAO extends GenericDAO<Counselor> {
    
    /**
     * Finds a counselor by email address.
     * @param email The counselor's email
     * @return Optional containing counselor if found
     */
    Optional<Counselor> findByEmail(String email);
    
    /**
     * Finds all counselors with specific availability.
     * @param availability e.g., "High", "Medium", "Low"
     * @return List of matching counselors
     */
    List<Counselor> findByAvailability(String availability);
    
    /**
     * Finds counselors by specialization.
     * @param specialization e.g., "Anxiety Support"
     * @return List of matching counselors
     */
    List<Counselor> findBySpecialization(String specialization);
    
    /**
     * Finds all counselors ordered by rating (highest first).
     * @return List of counselors sorted by rating descending
     */
    List<Counselor> findAllOrderByRatingDesc();
}