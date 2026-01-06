<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<div id="analytics-data-source" style="display: none;">
    <c:forEach var="snapshot" items="${trendData}">
        <div class="data-point" 
             data-date="${snapshot.recordedAt}" 
             data-appointments="${snapshot.totalAppointments != null ? snapshot.totalAppointments : 0}"
             data-users="${snapshot.totalUsers != null ? snapshot.totalUsers : 0}">
        </div>
    </c:forEach>
</div>

<div class="container mx-auto px-4 py-8">

    <c:if test="${param.success == 'snapshot'}">
        <div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-6 flex items-start gap-3 fade-in">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-green-800">Snapshot Saved</h3>
                <p class="text-sm text-green-700 mt-1">System analytics snapshot has been recorded successfully.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'snapshot'}">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3 fade-in">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-red-800">Error</h3>
                <p class="text-sm text-red-700 mt-1">Failed to save analytics snapshot. Please try again.</p>
            </div>
        </div>
    </c:if>

    <div class="space-y-8">
        
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold text-foreground mb-2">Admin Dashboard</h1>
                <p class="text-muted-foreground mt-1">System management and oversight</p>
            </div>
            <a href="/admin/analytics/snapshot" class="inline-flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity">
                <i data-lucide="save" class="w-4 h-4"></i>
                Save Snapshot
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="text-sm font-medium text-foreground">Total Users</h3>
                    <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                </div>
                <div class="text-3xl font-bold text-foreground mb-1"><c:out value="${totalUsers}" default="0"/></div>
                <c:choose>
                    <c:when test="${not empty userGrowth}">
                        <c:set var="growthValue" value="${userGrowth}" />
                        <c:choose>
                            <c:when test="${growthValue.startsWith('-')}">
                                <p class="text-xs text-red-600 mt-1 flex items-center gap-1">
                                    <i data-lucide="trending-down" class="w-3 h-3"></i>
                                    ${userGrowth}% from last snapshot
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-xs text-green-600 mt-1 flex items-center gap-1">
                                    <i data-lucide="trending-up" class="w-3 h-3"></i>
                                    +${userGrowth}% from last snapshot
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p class="text-xs text-muted-foreground mt-1">No previous data</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="text-sm font-medium text-foreground">Active Users</h3>
                    <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                    </svg>
                </div>
                <div class="text-3xl font-bold text-foreground mb-1"><c:out value="${activeUsers}" default="0"/></div>
                <p class="text-xs text-muted-foreground mt-1">Last 30 days</p>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="text-sm font-medium text-foreground">Total Appointments</h3>
                    <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                </div>
                <div class="text-3xl font-bold text-foreground mb-1"><c:out value="${totalAppointments}" default="0"/></div>
                <c:choose>
                    <c:when test="${not empty appointmentGrowth}">
                        <c:set var="apptGrowth" value="${appointmentGrowth}" />
                        <c:choose>
                            <c:when test="${apptGrowth.startsWith('-')}">
                                <p class="text-xs text-red-600 mt-1 flex items-center gap-1">
                                    <i data-lucide="trending-down" class="w-3 h-3"></i>
                                    ${appointmentGrowth}% from last snapshot
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-xs text-green-600 mt-1 flex items-center gap-1">
                                    <i data-lucide="trending-up" class="w-3 h-3"></i>
                                    +${appointmentGrowth}% from last snapshot
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p class="text-xs text-muted-foreground mt-1">No previous data</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="text-sm font-medium text-foreground">Pending Approvals</h3>
                    <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
                <div class="text-3xl font-bold text-foreground mb-1"><c:out value="${pendingAppointments}" default="0"/></div>
                <p class="text-xs text-muted-foreground mt-1">Awaiting counselor review</p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="mb-4">
                    <h3 class="text-xl font-semibold text-foreground">Appointment Trends</h3>
                    <p class="text-sm text-muted-foreground">Historical appointment data</p>
                </div>
                <div class="h-64">
                    <canvas id="appointmentChart"></canvas>
                </div>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="mb-4">
                    <h3 class="text-xl font-semibold text-foreground">Appointment Status</h3>
                    <p class="text-sm text-muted-foreground">Current distribution</p>
                </div>
                <div class="h-64">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            
            <div class="lg:col-span-3 bg-card rounded-lg shadow-sm border border-border">
                <div class="p-6 border-b border-border">
                    <h3 class="text-xl font-semibold text-foreground">Detailed Statistics</h3>
                </div>
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div>
                            <h4 class="text-sm font-medium text-muted-foreground mb-3">User Breakdown</h4>
                            <div class="space-y-2">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Students</span>
                                    <span class="text-sm font-medium text-foreground"><c:out value="${totalStudents}" default="0"/></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Counselors</span>
                                    <span class="text-sm font-medium text-foreground"><c:out value="${totalCounselors}" default="0"/></span>
                                </div>
                            </div>
                        </div>
                        
                        <div>
                            <h4 class="text-sm font-medium text-muted-foreground mb-3">Appointment Status</h4>
                            <div class="space-y-2">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Confirmed</span>
                                    <span class="text-sm font-medium text-green-600"><c:out value="${confirmedAppointments}" default="0"/></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Cancelled</span>
                                    <span class="text-sm font-medium text-red-600"><c:out value="${cancelledAppointments}" default="0"/></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Completed</span>
                                    <span class="text-sm font-medium text-blue-600"><c:out value="${completedAppointments}" default="0"/></span>
                                </div>
                            </div>
                        </div>
                        
                        <div>
                            <h4 class="text-sm font-medium text-muted-foreground mb-3">Module Usage</h4>
                            <div class="space-y-2">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Assessments</span>
                                    <span class="text-sm font-medium text-foreground"><c:out value="${assessmentsTaken}" default="0"/></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-foreground">Forum Posts</span>
                                    <span class="text-sm font-medium text-foreground"><c:out value="${forumPosts}" default="0"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="lg:col-span-1">
                <a href="/admin/counselor-performance" class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow block h-full flex flex-col justify-between">
                    <div>
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-semibold text-foreground">Counselor Metrics</h3>
                            <div class="p-2 bg-primary/10 rounded-full">
                                <i data-lucide="bar-chart-2" class="w-6 h-6 text-primary"></i>
                            </div>
                        </div>
                        <p class="text-muted-foreground mb-4">Analyze individual counselor performance, ratings, and session counts.</p>
                    </div>
                    <div class="text-primary font-medium flex items-center gap-2 mt-auto">
                        View Details
                        <i data-lucide="arrow-right" class="w-4 h-4"></i>
                    </div>
                </a>
            </div>

        </div>
    </div>
</div>

<script>
// DATA EXTRACTION
const rawDataPoints = document.querySelectorAll('#analytics-data-source .data-point');
const trendData = Array.from(rawDataPoints).map(point => ({
    date: point.getAttribute('data-date'),
    appointments: parseInt(point.getAttribute('data-appointments') || '0'),
    users: parseInt(point.getAttribute('data-users') || '0')
}));

const formatChartDate = (dateStr) => {
    try {
        if (!dateStr) return 'N/A';
        const date = new Date(dateStr);
        if (isNaN(date.getTime())) return dateStr;
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    } catch(e) { return dateStr; }
};

const labels = trendData.map(d => formatChartDate(d.date)).reverse();
const appointmentData = trendData.map(d => d.appointments).reverse();
const userData = trendData.map(d => d.users).reverse();

// CHART.JS CONFIGURATION
// APPOINTMENT TREND CHART
const appointmentCtx = document.getElementById('appointmentChart').getContext('2d');
const appointmentChart = new Chart(appointmentCtx, {
    type: 'line',
    data: {
        labels: labels.length > 0 ? labels : ['No Data'],
        datasets: [
            {
                label: 'Total Appointments',
                data: appointmentData.length > 0 ? appointmentData : [0],
                borderColor: 'rgb(59, 130, 246)',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4
            },
            {
                label: 'Total Users',
                data: userData.length > 0 ? userData : [0],
                borderColor: 'rgb(168, 85, 247)',
                backgroundColor: 'rgba(168, 85, 247, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'bottom' },
            title: { display: false }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: { stepSize: 1 }
            }
        }
    }
});

// STATUS DISTRIBUTION CHART
const statusCtx = document.getElementById('statusChart').getContext('2d');
const statusChart = new Chart(statusCtx, {
    type: 'doughnut',
    data: {
        labels: ['Pending', 'Confirmed', 'Cancelled', 'Completed'],
        datasets: [{
            data: [
                <c:out value="${pendingAppointments}" default="0"/>,
                <c:out value="${confirmedAppointments}" default="0"/>,
                <c:out value="${cancelledAppointments}" default="0"/>,
                <c:out value="${completedAppointments}" default="0"/>
            ],
            backgroundColor: [
                'rgba(251, 191, 36, 0.8)',  // Yellow
                'rgba(34, 197, 94, 0.8)',    // Green
                'rgba(239, 68, 68, 0.8)',    // Red
                'rgba(59, 130, 246, 0.8)'    // Blue
            ],
            borderColor: [
                'rgb(251, 191, 36)',
                'rgb(34, 197, 94)',
                'rgb(239, 68, 68)',
                'rgb(59, 130, 246)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'right' },
            title: { display: false }
        }
    }
});

// AUTO-DISMISS MESSAGES
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.fade-in');
    alerts.forEach(alert => {
        if (alert.classList.contains('bg-green-50') || alert.classList.contains('bg-red-50')) {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        }
    });
});
</script>

<jsp:include page="../common/footer.jsp" />