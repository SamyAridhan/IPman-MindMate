// src/main/java/com/mindmate/repository/CounselorRepository.java

package com.mindmate.repository;

import com.mindmate.model.Counselor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Counselor entity.
 * Provides CRUD operations and custom query methods.
 */
@Repository
public interface CounselorRepository extends JpaRepository<Counselor, Long> {
    
    /**
     * Find counselor by email address.
     * @param email The counselor's email
     * @return Optional containing counselor if found
     */
    Optional<Counselor> findByEmail(String email);
    
    /**
     * Find all counselors with specific availability status.
     * @param availability e.g., "High", "Medium", "Low"
     * @return List of counselors matching availability
     */
    List<Counselor> findByAvailability(String availability);
    
    /**
     * Find counselors by specialization.
     * @param specialization e.g., "Anxiety Support"
     * @return List of counselors with matching specialization
     */
    List<Counselor> findBySpecialization(String specialization);
    
    /**
     * Find all counselors ordered by rating (highest first).
     * @return List of counselors sorted by rating descending
     */
    @Query("SELECT c FROM Counselor c ORDER BY c.rating DESC")
    List<Counselor> findAllOrderByRatingDesc();
}