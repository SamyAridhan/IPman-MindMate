<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.mindmate.model.Assessment" %>

<jsp:include page="../common/header.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
    // --- LOGIC: Calculate "X Days Ago" ---
    Assessment latest = (Assessment) request.getAttribute("latestAssessment");
    String timeAgoString = "No assessment taken yet";
    
    if (latest != null) {
        LocalDate takenDate = latest.getTakenAt().toLocalDate();
        LocalDate today = LocalDate.now();
        long days = ChronoUnit.DAYS.between(takenDate, today);
        
        if (days == 0) {
            timeAgoString = "Last assessment was taken Today";
        } else if (days == 1) {
             timeAgoString = "Last assessment was taken Yesterday";
        } else {
             timeAgoString = "Last assessment was taken " + days + " days ago";
        }
    }
    request.setAttribute("timeAgoString", timeAgoString);
%>

<div class="container mx-auto px-4 py-8">
    <div class="mb-8 fade-in">
        <h1 class="text-3xl font-bold text-foreground mb-2">Welcome back, ${sessionScope.userName != null ? sessionScope.userName : 'Student'}!</h1>
        <p class="text-muted-foreground">How are you feeling today?</p>
    </div>

    <div class="quick-start-card p-6 rounded-lg shadow-sm mb-8 fade-in">
        <div class="flex items-center justify-between">
            <div>
                <h3 class="text-xl font-semibold text-foreground mb-2">Quick Start: How are you feeling?</h3>
                <p class="text-muted-foreground mb-4">Take a quick self-assessment to get personalized support</p>
                
                <p class="text-sm font-medium text-primary mb-4">
                    <i data-lucide="clock" class="w-4 h-4 inline mr-1"></i>
                    ${timeAgoString}
                </p>
                
                <a href="/student/assessment" class="inline-flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    <i data-lucide="heart" class="w-4 h-4"></i>
                    Take Student Survey
                </a>

                <a href="#history-section" class="inline-flex items-center gap-2 bg-secondary text-secondary-foreground border border-input px-4 py-2 rounded-md hover:bg-secondary/80 transition-colors font-medium">
                        <i data-lucide="history" class="w-4 h-4"></i>
                        View Past Results
                </a>
            </div>
            <i data-lucide="heart" class="w-20 h-20 text-primary opacity-20"></i>
        </div>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border mb-8 fade-in">
        <div class="flex items-center mb-4">
            <i data-lucide="book-open" class="w-5 h-5 mr-2 text-success-foreground"></i>
            <h2 class="text-xl font-semibold text-foreground">New in the Learning Hub</h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="learning-card p-4 rounded-lg border border-border cursor-pointer">
                <span class="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-full border border-border">article</span>
                <h4 class="font-semibold text-foreground mt-2 mb-1">Stress Management 101</h4>
                <p class="text-sm text-muted-foreground line-clamp-2">Learn effective stress coping strategies for students</p>
                <a href="/student/library" class="text-primary text-sm font-medium mt-2 inline-block hover:underline">
                    Learn more →
                </a>
            </div>
            <div class="learning-card p-4 rounded-lg border border-border cursor-pointer">
                <span class="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-full border border-border">video</span>
                <h4 class="font-semibold text-foreground mt-2 mb-1">Mindfulness Meditation Guide</h4>
                <p class="text-sm text-muted-foreground line-clamp-2">15-minute guided meditation for anxiety relief</p>
                <a href="/student/library" class="text-primary text-sm font-medium mt-2 inline-block hover:underline">
                    Learn more →
                </a>
            </div>
            <div class="learning-card p-4 rounded-lg border border-border cursor-pointer">
                <span class="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-full border border-border">article</span>
                <h4 class="font-semibold text-foreground mt-2 mb-1">Sleep Hygiene</h4>
                <p class="text-sm text-muted-foreground line-clamp-2">Interactive module on building better sleep habits</p>
                <a href="/student/library" class="text-primary text-sm font-medium mt-2 inline-block hover:underline">
                    Learn more →
                </a>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2 space-y-6">

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <i data-lucide="line-chart" class="w-5 h-5 mr-2 text-primary"></i>
                        <h2 class="text-xl font-semibold text-foreground">Assessment History</h2>
                    </div>
                    
                    <c:if test="${not empty assessmentHistory}">
                        <select id="historyFilter" class="px-3 py-1.5 border border-input rounded-md bg-background text-sm">
                            <option value="7">Last 5 Results</option>
                            <option value="30">Last 3 Results</option>
                            <option value="all">All Results</option>
                        </select>
                    </c:if>
                </div>

                <div class="relative w-full h-64 flex items-center justify-center">
                    <c:choose>
                        
                        <%-- CASE 1: User HAS Data -> Show Graph --%>
                        <c:when test="${not empty assessmentHistory}">
                            <canvas id="historyGraph"></canvas>
                        </c:when>
                        
                        <%-- CASE 2: User has NO Data -> Show Empty State --%>
                        <c:otherwise>
                            <div class="text-center text-muted-foreground">
                                <div class="bg-secondary/50 rounded-full p-3 inline-block mb-3">
                                    <i data-lucide="bar-chart-2" class="w-8 h-8 text-muted-foreground/50"></i>
                                </div>
                                <p class="text-sm font-medium">No assessment history yet</p>
                                <p class="text-xs mt-1">Complete your first check-in to track progress!</p>
                                
                                <a href="/student/assessment" class="mt-4 inline-block text-xs font-medium text-primary hover:underline">
                                    Take Assessment &rarr;
                                </a>
                            </div>
                        </c:otherwise>
                        
                    </c:choose>
                </div>

            
        </div>
            
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <i data-lucide="trending-up" class="w-5 h-5 mr-2 text-info-foreground"></i>
                        <h2 class="text-xl font-semibold text-foreground">Progress Dashboard</h2>
                    </div>
                    <select class="px-3 py-1.5 border border-input rounded-md bg-background text-sm">
                        <option>This Week</option>
                        <option>This Month</option>
                        <option>This Quarter</option>
                    </select>
                </div>

                <div class="mb-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="font-medium text-foreground">Weekly Mood Tracker</h4>
                        <span class="badge-success">7.4/10</span>
                    </div>
                    <div class="grid grid-cols-7 gap-2">
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Mon</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">7</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Tue</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">6</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Wed</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">8</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Thu</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">7</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Fri</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">9</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Sat</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">8</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Sun</div>
                            <div class="mood-circle h-8 flex items-center justify-center text-sm font-medium">7</div>
                        </div>
                    </div>
                </div>

                <div>
                    <h4 class="font-medium text-foreground mb-4">Activity Progress</h4>
                    <div class="space-y-4">
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span class="flex items-center">
                                    <i data-lucide="book-open" class="w-4 h-4 mr-1"></i>
                                    Stress Management
                                </span>
                                <span>75%</span>
                            </div>
                            <div class="progress-bar-container h-2">
                                <div class="progress-bar-fill h-2" style="width: 75%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span class="flex items-center">
                                    <i data-lucide="book-open" class="w-4 h-4 mr-1"></i>
                                    Sleep Hygiene
                                </span>
                                <span>50%</span>
                            </div>
                            <div class="progress-bar-container h-2">
                                <div class="progress-bar-fill blue-accent h-2" style="width: 50%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span class="flex items-center">
                                    <i data-lucide="book-open" class="w-4 h-4 mr-1"></i>
                                    Social Skills
                                </span>
                                <span>90%</span>
                            </div>
                            <div class="progress-bar-container h-2">
                                <div class="progress-bar-fill h-2" style="width: 90%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between text-sm mb-1">
                                <span class="flex items-center">
                                    <i data-lucide="heart" class="w-4 h-4 mr-1"></i>
                                    Self-Assessment
                                </span>
                                <span>100%</span>
                            </div>
                            <div class="progress-bar-container h-2">
                                <div class="progress-bar-fill blue-accent h-2" style="width: 100%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
    <div class="flex items-center justify-between mb-4">
        <div class="flex items-center">
            <i data-lucide="sparkles" class="w-5 h-5 mr-2 text-primary"></i>
            <h2 class="text-xl font-semibold text-foreground">
                Personalized Learning Modules
            </h2>
        </div>
        
        <button onclick="window.location.reload();" class="icon-btn border border-input" title="Refresh">
            <i data-lucide="refresh-cw" class="w-4 h-4"></i>
        </button>
    </div>

    <div class="space-y-4">
        
        <c:forEach var="module" items="${recommendedModules}">
            <a href="/student/view-module?id=${module.id}" 
               class="block p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors border border-transparent hover:border-border">
                <div class="flex items-start justify-between">
                    <div class="flex-1">
                        <div class="flex items-center space-x-2 mb-2">
                            <%-- Dynamic Icon based on content type --%>
                            <i data-lucide="${module.contentType == 'Video' ? 'video' : 'file-text'}" 
                               class="w-4 h-4 ${module.contentType == 'Video' ? 'text-blue-500' : 'text-green-500'}"></i>
                            <h4 class="font-medium text-foreground">${module.title}</h4>
                        </div>
                        <p class="text-sm text-muted-foreground line-clamp-2">${module.description}</p>
                        
                        <div class="flex items-center mt-2">
                             <span class="text-xs font-medium text-amber-600 bg-amber-50 px-2 py-0.5 rounded-full border border-amber-100">
                                <i data-lucide="star" class="w-3 h-3 inline mr-1 fill-current"></i> ${module.pointsValue} pts
                            </span>
                        </div>
                    </div>
                    <div class="ml-4 text-primary opacity-70">
                        <i data-lucide="chevron-right" class="w-5 h-5"></i>
                    </div>
                </div>
            </a>
        </c:forEach>

        <%-- EMPTY STATE --%>
        <c:if test="${empty recommendedModules}">
            <div class="text-center py-6 text-muted-foreground border border-dashed border-border rounded-lg">
                <i data-lucide="book-open" class="w-8 h-8 mx-auto mb-2 opacity-50"></i>
                <p class="text-sm">Complete the self-assessment to see your personalized list.</p>
            </div>
        </c:if>

    </div>
</div>
        </div>

        <div class="space-y-6">
            
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
                <div class="flex items-center mb-4">
                    <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Upcoming Sessions</h2>
                </div>
            
                <div class="space-y-3">
                    <c:choose>
                        <c:when test="${not empty bookedAppointments}">
                            <c:forEach var="appointment" items="${bookedAppointments}">
                                
                                <%-- ✅ LOGIC: Only show Confirmed, Pending, or Denied/Rejected. Exclude Completed/Cancelled/Acknowledged. --%>
                                <c:if test="${appointment.status == 'CONFIRMED' || appointment.status == 'PENDING' || appointment.status == 'DENIED' || appointment.status == 'REJECTED'}">
                                
                                    <div class="session-card p-4 rounded-lg border border-border mb-3 hover:shadow-md transition-shadow">
                                        
                                        <div class="flex items-center justify-between mb-2">
                                            <h4 class="font-medium text-foreground">${appointment.sessionType}</h4>
                                            
                                            <%-- Status Badges --%>
                                            <c:choose>
                                                <c:when test="${appointment.status == 'CONFIRMED'}">
                                                    <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-700 border border-green-200">Confirmed</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'PENDING'}">
                                                    <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700 border border-yellow-200">Pending</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'DENIED' || appointment.status == 'REJECTED'}">
                                                    <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-700 border border-red-200">Denied</span>
                                                </c:when>
                                            </c:choose>
                                        </div>

                                        <%-- Display Rejection Reason if Denied --%>
                                        <c:if test="${(appointment.status == 'DENIED' || appointment.status == 'REJECTED') && not empty appointment.denialReason}">
                                            <div class="text-xs text-red-600 bg-red-50 p-2 rounded mb-3 border border-red-100">
                                                <span class="font-semibold">Reason:</span> ${appointment.denialReason}
                                            </div>
                                        </c:if>

                                        <div class="text-sm text-muted-foreground space-y-1 mb-3">
                                            <div class="flex items-center">
                                                <i data-lucide="user" class="w-3 h-3 mr-2"></i>
                                                <span>with ${appointment.counselorName}</span>
                                            </div>
                                            <div class="flex items-center gap-4">
                                                <span class="flex items-center">
                                                    <i data-lucide="calendar" class="w-3 h-3 mr-1"></i>
                                                    ${appointment.date}
                                                </span>
                                                <span class="flex items-center">
                                                    <i data-lucide="clock" class="w-3 h-3 mr-1"></i>
                                                    ${appointment.time}
                                                </span>
                                            </div>
                                        </div>

                                        <div class="flex gap-2">
                                            <%-- Action Buttons --%>
                                            
                                            <%-- 1. JOIN (Confirmed only) - Updated to Google Meet --%>
                                            <c:if test="${appointment.status == 'CONFIRMED'}">
                                                <a href="https://meet.google.com" target="_blank"
                                                   class="flex-1 inline-flex justify-center items-center text-xs px-3 py-1.5 bg-primary text-primary-foreground rounded-md hover:opacity-90 transition-opacity">
                                                    <i data-lucide="video" class="w-3 h-3 mr-1"></i>
                                                    Join
                                                </a>
                                            </c:if>
                                            
                                            <%-- 2. CANCEL (Pending or Confirmed only) - ✅ UPDATED UI (Filled Style) --%>
                                            <c:if test="${appointment.status == 'PENDING' || appointment.status == 'CONFIRMED'}">
                                                <form action="/student/telehealth/cancel" method="post" class="flex-1">
                                                    <input type="hidden" name="appointmentId" value="${appointment.id}" />
                                                    <button type="submit" 
                                                            onclick="return confirm('Are you sure you want to cancel this appointment?');"
                                                            class="w-full inline-flex justify-center items-center text-xs px-3 py-1.5 bg-red-100 text-red-700 border border-red-200 rounded-md hover:bg-red-200 transition-colors">
                                                        Cancel
                                                    </button>
                                                </form>
                                            </c:if>

                                            <%-- 3. NOTED (Denied only - to remove from view) --%>
                                            <c:if test="${appointment.status == 'DENIED' || appointment.status == 'REJECTED'}">
                                                <form action="/student/telehealth/acknowledge" method="post" class="w-full">
                                                    <input type="hidden" name="appointmentId" value="${appointment.id}" />
                                                    <button type="submit" 
                                                            class="w-full inline-flex justify-center items-center text-xs px-3 py-1.5 bg-secondary text-secondary-foreground border border-input rounded-md hover:bg-secondary/80 transition-colors">
                                                        <i data-lucide="check" class="w-3 h-3 mr-1"></i>
                                                        Noted (Remove)
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if> 
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 text-muted-foreground">
                                <i data-lucide="calendar" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                                <p>No upcoming sessions</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <a href="/student/telehealth" class="block w-full bg-secondary text-secondary-foreground text-center px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium mt-2">
                        <span class="flex items-center justify-center gap-2">
                            <i data-lucide="plus" class="w-4 h-4"></i>
                            Book New Session
                        </span>
                    </a>
                </div>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
                <div class="flex items-center mb-4">
                    <i data-lucide="bell" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Notifications</h2>
                </div>

                <div class="space-y-3">
                    <div class="notification-card">
                        <p class="text-sm text-foreground">New session scheduled for tomorrow at 2 PM</p>
                        <span class="badge-outline-blue inline-block mt-1">appointment</span>
                    </div>
                    <div class="notification-card">
                        <p class="text-sm text-foreground">Complete your weekly mood check-in</p>
                        <span class="badge-outline-blue inline-block mt-1">reminder</span>
                    </div>
                    <div class="notification-card">
                        <p class="text-sm text-foreground">New peer discussion in Anxiety Support group</p>
                        <span class="badge-outline-blue inline-block mt-1">forum</span>
                    </div>
                </div>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border fade-in">
                <h2 class="text-xl font-semibold text-foreground mb-4">Quick Actions</h2>
                <div class="space-y-2">
                    <a href="/student/assessment" class="flex items-center w-full justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                        <i data-lucide="heart" class="w-4 h-4 mr-2"></i>
                        Daily Mood Check-in
                    </a>
                    <a href="/student/telehealth" class="flex items-center w-full justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                        <i data-lucide="calendar" class="w-4 h-4 mr-2"></i>
                        Schedule Session
                    </a>
                    <a href="/student/forum" class="flex items-center w-full justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                        <i data-lucide="message-circle" class="w-4 h-4 mr-2"></i>
                        Join Discussion
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', async function() {
    const ctx = document.getElementById('historyGraph');
    if (!ctx) return; // Stop if element isn't found

    try {
        // --- 1. Fetch Data from your Spring Boot Backend ---
        // Ensure your controller returns JSON like: [{"date": "Oct 1", "score": 65}, ...]
        const response = await fetch('/api/history'); 
        
        if (!response.ok) throw new Error('Network response was not ok');
        
        const apiData = await response.json();

        // --- 2. Process Data for Chart.js ---
        const labels = apiData.map(item => item.date);
        const scores = apiData.map(item => item.score);

        // --- 3. Render the Line Graph ---
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Assessment Score',
                    data: scores,
                    // Styling to match your "MindMate" blue theme
                    borderColor: '#2563eb',       // Blue-600
                    backgroundColor: (context) => {
                        const ctx = context.chart.ctx;
                        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
                        gradient.addColorStop(0, 'rgba(37, 99, 235, 0.2)'); // Top (Blue)
                        gradient.addColorStop(1, 'rgba(37, 99, 235, 0.0)'); // Bottom (Transparent)
                        return gradient;
                    },
                    borderWidth: 3,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#2563eb',
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    tension: 0.4, // 0.4 makes the line curvy (0 is straight)
                    fill: true    // Fills the area under the line
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }, // Hide the legend for a cleaner look
                    tooltip: {
                        backgroundColor: '#1e293b', // Dark tooltip
                        padding: 12,
                        cornerRadius: 8,
                        displayColors: false,
                        callbacks: {
                            label: function(context) {
                                return 'Score: ' + context.parsed.y + '/15';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 15, // Adjust this if your score is out of 10 or 50
                        ticks: {
                            stepSize: 5, // ✅ This forces even spacing: 0, 5, 10, 15
                            precision: 0 // Ensures no decimals like 2.5 appear
                        },
                        grid: {
                            color: '#e2e8f0', // Light gray grid lines
                            borderDash: [5, 5]
                        }
                    },
                    x: {
                        grid: { display: false } // Clean X-axis
                    }
                }
            }
        });

    } catch (error) {
        console.error("Chart Error:", error);
        // Fallback UI if data fails to load
        ctx.parentElement.innerHTML = `
            <div class="flex flex-col items-center justify-center h-full text-muted-foreground">
                <i data-lucide="alert-circle" class="w-8 h-8 mb-2 opacity-50"></i>
                <p>No history data available yet.</p>
            </div>
        `;
        // Re-initialize icons just in case
        if(typeof lucide !== 'undefined') lucide.createIcons();
    }
});
</script>

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />