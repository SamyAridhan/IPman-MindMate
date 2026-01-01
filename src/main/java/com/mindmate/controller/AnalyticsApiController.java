// FILE: src/main/java/com/mindmate/controller/AnalyticsApiController.java (OPTIONAL)
package com.mindmate.controller;

import com.mindmate.dao.SystemAnalyticsDAO;
import com.mindmate.model.SystemAnalytics;
import com.mindmate.util.AnalyticsHelper;
import com.mindmate.util.SessionHelper;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST API Controller for AJAX analytics data requests.
 * Returns JSON data for dynamic chart updates.
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
     * 
     * @param view View type: "week", "month", or "year"
     * @param session HTTP session for authentication
     * @return Chart data in JSON format
     */
    @GetMapping("/chart-data")
    public AnalyticsHelper.ChartData getChartData(
            @RequestParam(defaultValue = "month") String view,
            HttpSession session) {
        
        // Security check
        if (!"admin".equals(SessionHelper.getRole(session))) {
            return new AnalyticsHelper.ChartData(); // Return empty data
        }
        
        List<SystemAnalytics> snapshots;
        
        switch (view) {
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
        
        return AnalyticsHelper.prepareChartData(snapshots);
    }
}