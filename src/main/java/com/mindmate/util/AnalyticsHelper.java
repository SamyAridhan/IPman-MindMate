// FILE: src/main/java/com/mindmate/util/AnalyticsHelper.java
package com.mindmate.util;

import com.mindmate.model.SystemAnalytics;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Helper class for formatting analytics data for frontend charts.
 * Converts SystemAnalytics entities to chart-friendly structures.
 * 
 * @author Ying Yi (A23CS0180) - Analytics Module
 * @author Samy (A23CS0246) - Integration
 */
public class AnalyticsHelper {
    
    private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMM yyyy");
    private static final DateTimeFormatter DAY_FORMATTER = DateTimeFormatter.ofPattern("MMM dd");
    
    /**
     * Converts list of SystemAnalytics to chart data points.
     * Returns JSON-friendly structure for JavaScript charting libraries.
     * 
     * @param snapshots List of analytics snapshots
     * @return ChartData object containing labels and datasets
     */
    public static ChartData prepareChartData(List<SystemAnalytics> snapshots) {
        ChartData chartData = new ChartData();
        
        if (snapshots == null || snapshots.isEmpty()) {
            return chartData;
        }
        
        List<String> labels = new ArrayList<>();
        List<Integer> appointments = new ArrayList<>();
        List<Integer> users = new ArrayList<>();
        
        // Reverse to show chronological order (oldest -> newest)
        for (int i = snapshots.size() - 1; i >= 0; i--) {
            SystemAnalytics snapshot = snapshots.get(i);
            
            // Format date label
            String label = snapshot.getRecordedAt().format(DAY_FORMATTER);
            labels.add(label);
            
            // Extract data points
            appointments.add(snapshot.getTotalAppointments() != null ? snapshot.getTotalAppointments() : 0);
            users.add(snapshot.getTotalUsers() != null ? snapshot.getTotalUsers() : 0);
        }
        
        chartData.setLabels(labels);
        chartData.setAppointments(appointments);
        chartData.setUsers(users);
        
        return chartData;
    }
    
    /**
     * Calculates percentage growth between two snapshots.
     * 
     * @param current Current value
     * @param previous Previous value
     * @return Growth percentage (e.g., 12.5 for 12.5% growth)
     */
    public static double calculateGrowth(int current, int previous) {
        if (previous == 0) return 0.0;
        return ((double) (current - previous) / previous) * 100;
    }
    
    /**
     * Formats growth percentage for display.
     * Adds + or - prefix and % suffix.
     * 
     * @param growth Growth value
     * @return Formatted string (e.g., "+12.5%" or "-5.2%")
     */
    public static String formatGrowth(double growth) {
        String sign = growth >= 0 ? "+" : "";
        return String.format("%s%.1f%%", sign, growth);
    }
    
    // ============================================
    // INNER CLASS: ChartData
    // ============================================
    
    /**
     * Data structure for chart rendering.
     * Can be easily converted to JSON for frontend.
     */
    public static class ChartData {
        private List<String> labels = new ArrayList<>();
        private List<Integer> appointments = new ArrayList<>();
        private List<Integer> users = new ArrayList<>();
        
        public List<String> getLabels() { return labels; }
        public void setLabels(List<String> labels) { this.labels = labels; }
        
        public List<Integer> getAppointments() { return appointments; }
        public void setAppointments(List<Integer> appointments) { this.appointments = appointments; }
        
        public List<Integer> getUsers() { return users; }
        public void setUsers(List<Integer> users) { this.users = users; }
    }
}