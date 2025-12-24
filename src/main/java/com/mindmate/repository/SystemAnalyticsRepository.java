// src/main/java/com/mindmate/repository/SystemAnalyticsRepository.java

package com.mindmate.repository;

import com.mindmate.model.SystemAnalytics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository for SystemAnalytics entity.
 * Handles analytics data persistence and retrieval.
 */
@Repository
public interface SystemAnalyticsRepository extends JpaRepository<SystemAnalytics, Long> {
    
    /**
     * Retrieve the most recent analytics snapshot.
     * @return Optional containing latest analytics record
     */
    @Query("SELECT s FROM SystemAnalytics s ORDER BY s.recordedAt DESC")
    Optional<SystemAnalytics> findLatestAnalytics();
}