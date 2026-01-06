// src/main/java/com/mindmate/controller/AnalyticsApiController.java
package com.mindmate.controller;

import com.mindmate.dao.SystemAnalyticsDAO;
import com.mindmate.model.SystemAnalytics;
import com.mindmate.util.AnalyticsHelper;
import com.mindmate.util.SessionHelper;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST API Controller for AJAX analytics requests.
 * Returns JSON data for dynamic chart updates without page reload.
 * 
 * @author Ying Yi (A23CS0180) - Analytics Module
 */
@RestController
@RequestMapping("/api/admin/analytics")
public class AnalyticsApiController {

    @Autowired
    private SystemAnalyticsDAO analyticsDAO;

    /**
     * AJAX endpoint to fetch chart data.
     * Used by frontend JavaScript to update charts dynamically.
     * 
     * Example: GET /api/admin/analytics/chart-data?view=month
     * 
     * @param view View type: "week", "month", or "year"
     * @param session HTTP session for authentication
     * @return Chart data in JSON format
     */
    @GetMapping("/chart-data")
    public Map<String, Object> getChartData(
            @RequestParam(defaultValue = "month") String view,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        // Security: Only admins can access
        if (!"admin".equals(SessionHelper.getRole(session))) {
            response.put("error", "Unauthorized");
            return response;
        }
        
        try {
            List<SystemAnalytics> snapshots;
            
            // Fetch data based on view type
            switch (view.toLowerCase()) {
                case "week":
                    snapshots = analyticsDAO.findRecentSnapshots(7);
                    break;
                case "year":
                    snapshots = analyticsDAO.findMonthlySnapshots(12);
                    break;
                case "month":
                default:
                    snapshots = analyticsDAO.findRecentSnapshots(30);
                    break;
            }
            
            // Format for Chart.js
            AnalyticsHelper.ChartData chartData = AnalyticsHelper.prepareChartData(snapshots);
            
            response.put("labels", chartData.getLabels());
            response.put("appointments", chartData.getAppointments());
            response.put("users", chartData.getUsers());
            response.put("success", true);
            
        } catch (Exception e) {
            response.put("error", "Failed to load chart data");
            response.put("success", false);
        }
        
        return response;
    }

    /**
     * Quick metrics endpoint for dashboard widgets.
     * Returns current counts without full snapshot data.
     * 
     * Example: GET /api/admin/analytics/quick-stats
     */
    @GetMapping("/quick-stats")
    public Map<String, Object> getQuickStats(HttpSession session) {
        Map<String, Object> stats = new HashMap<>();
        
        if (!"admin".equals(SessionHelper.getRole(session))) {
            stats.put("error", "Unauthorized");
            return stats;
        }
        
        try {
            
            stats.put("success", true);
            stats.put("message", "Use main dashboard endpoint for full stats");
        } catch (Exception e) {
            stats.put("error", e.getMessage());
        }
        
        return stats;
    }
}