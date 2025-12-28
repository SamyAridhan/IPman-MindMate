// src/main/java/com/mindmate/dao/SystemAnalyticsDAO.java

package com.mindmate.dao;

import com.mindmate.model.SystemAnalytics;
import java.util.Optional;

/**
 * DAO interface for SystemAnalytics entity operations.
 * 
 * @author Samy (A23CS0246)
 * @module Admin Analytics
 */
public interface SystemAnalyticsDAO extends GenericDAO<SystemAnalytics> {
    
    /**
     * Retrieves the most recent analytics snapshot.
     * @return Optional containing latest analytics record
     */
    Optional<SystemAnalytics> findLatestAnalytics();
}