// src/main/java/com/mindmate/service/CounselorService.java

package com.mindmate.service;

import com.mindmate.model.Counselor;
import com.mindmate.repository.CounselorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service layer for counselor management.
 * Handles business logic for counselor profiles and availability.
 * 
 * @author Samy (A23CS0246)
 * @module Telehealth Assistance
 */
@Service
@Transactional(readOnly = true)
public class CounselorService {

    @Autowired
    private CounselorRepository counselorRepository;

    /**
     * Retrieves all counselors from the database.
     * 
     * @return List of all counselors
     */
    public List<Counselor> getAllCounselors() {
        return counselorRepository.findAll();
    }

    /**
     * Retrieves counselors sorted by rating (highest first).
     * 
     * @return List of counselors ordered by rating
     */
    public List<Counselor> getTopRatedCounselors() {
        return counselorRepository.findAllOrderByRatingDesc();
    }

    /**
     * Retrieves counselors with specific availability.
     * 
     * @param availability "High", "Medium", or "Low"
     * @return List of matching counselors
     */
    public List<Counselor> getCounselorsByAvailability(String availability) {
        return counselorRepository.findByAvailability(availability);
    }

    /**
     * Finds a counselor by ID.
     * 
     * @param id Counselor ID
     * @return Counselor entity or null if not found
     */
    public Counselor getCounselorById(Long id) {
        return counselorRepository.findById(id).orElse(null);
    }

    /**
     * Saves a new counselor to the database.
     * 
     * @param counselor Counselor entity to save
     * @return Saved counselor with generated ID
     */
    @Transactional
    public Counselor saveCounselor(Counselor counselor) {
        return counselorRepository.save(counselor);
    }
}