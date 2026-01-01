package com.mindmate.dao;

import com.mindmate.model.SystemAnalytics;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * DAO interface for SystemAnalytics entity operations.
 * Updates: Added date range filtering and trend analysis methods.
 * * @author Samy (A23CS0246)
 * @author Ying Yi (A23CS0180)
 */
public interface SystemAnalyticsDAO extends GenericDAO<SystemAnalytics> {
    
    /**
     * Retrieves the most recent analytics snapshot.
     * @return Optional containing latest analytics record
     */
    Optional<SystemAnalytics> findLatestAnalytics();

    /**
     * Retrieves analytics snapshots within a date range.
     * Ordered by recorded date descending (newest first).
     */
    List<SystemAnalytics> findByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Retrieves the last N analytics snapshots.
     * Useful for generating trend charts.
     */
    List<SystemAnalytics> findRecentSnapshots(int limit);
    
    /**
     * Retrieves monthly snapshots for trend analysis.
     * Returns snapshots for the past N months.
     */
    List<SystemAnalytics> findMonthlySnapshots(int months);
}