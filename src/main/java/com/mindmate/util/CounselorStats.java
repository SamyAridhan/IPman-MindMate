package com.mindmate.util;

/**
 * Data structure for counselor performance metrics.
 * Used in admin dashboard to display counselor statistics.
 * * @author Ying Yi (A23CS0180)
 */
public class CounselorStats {
    
    private Long counselorId;
    private String counselorName;
    private long totalAppointments; // ✅ FIXED: Changed from int to long
    private long pendingAppointments;
    private long confirmedAppointments;
    private long deniedAppointments;
    private long cancelledAppointments; // ✅ NEW FIELD
    private double approvalRate; // Percentage of approved appointments
    
    // Constructor
    public CounselorStats(Long counselorId, String counselorName) {
        this.counselorId = counselorId;
        this.counselorName = counselorName;
    }
    
    // Calculate approval rate
    public void calculateApprovalRate() {
        long total = confirmedAppointments + deniedAppointments;
        if (total > 0) {
            this.approvalRate = ((double) confirmedAppointments / total) * 100;
        } else {
            this.approvalRate = 0.0;
        }
    }
    
    // Getters and Setters
    public Long getCounselorId() { return counselorId; }
    public void setCounselorId(Long counselorId) { this.counselorId = counselorId; }
    
    public String getCounselorName() { return counselorName; }
    public void setCounselorName(String counselorName) { this.counselorName = counselorName; }
    
    public long getTotalAppointments() { return totalAppointments; }
    public void setTotalAppointments(long totalAppointments) { this.totalAppointments = totalAppointments; }
    
    public long getPendingAppointments() { return pendingAppointments; }
    public void setPendingAppointments(long pendingAppointments) { this.pendingAppointments = pendingAppointments; }
    
    public long getConfirmedAppointments() { return confirmedAppointments; }
    public void setConfirmedAppointments(long confirmedAppointments) { this.confirmedAppointments = confirmedAppointments; }
    
    public long getDeniedAppointments() { return deniedAppointments; }
    public void setDeniedAppointments(long deniedAppointments) { this.deniedAppointments = deniedAppointments; }
    
    // ✅ NEW Getter/Setter for Cancelled
    public long getCancelledAppointments() { return cancelledAppointments; }
    public void setCancelledAppointments(long cancelledAppointments) { this.cancelledAppointments = cancelledAppointments; }
    
    public double getApprovalRate() { return approvalRate; }
    public String getFormattedApprovalRate() { 
        return String.format("%.1f%%", approvalRate); 
    }
}