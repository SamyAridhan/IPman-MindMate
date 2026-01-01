<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    
    <!-- Success/Error Messages -->
    <c:if test="${param.success == 'approved'}">
        <div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-6 flex items-start gap-3 fade-in">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-green-800">Appointment Approved</h3>
                <p class="text-sm text-green-700 mt-1">The appointment has been confirmed. The student will be notified.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.success == 'denied'}">
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex items-start gap-3 fade-in">
            <i data-lucide="info" class="h-5 w-5 text-blue-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-blue-800">Appointment Denied</h3>
                <p class="text-sm text-blue-700 mt-1">The appointment has been cancelled and the student has been notified.</p>
            </div>
        </div>
    </c:if>

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">Counselor Dashboard</h1>
        <p class="text-muted-foreground">Professional workspace for counseling management</p>
    </div>

    <!-- Key Metrics -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <a href="/counselor/schedule" class="block">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-lg transition-all cursor-pointer">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Today's Appointments</p>
                        <p class="text-4xl font-bold text-foreground mt-2">${todayCount}</p>
                    </div>
                    <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center">
                        <i data-lucide="calendar" class="w-8 h-8 text-primary"></i>
                    </div>
                </div>
                <div class="mt-4 flex items-center text-sm text-primary font-medium">
                    View Schedule
                    <i data-lucide="arrow-right" class="w-4 h-4 ml-1"></i>
                </div>
            </div>
        </a>

        <a href="/counselor/schedule" class="block">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-lg transition-all cursor-pointer">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Pending Requests</p>
                        <p class="text-4xl font-bold text-foreground mt-2">${pendingCount}</p>
                    </div>
                    <div class="w-16 h-16 bg-info/10 rounded-full flex items-center justify-center">
                        <i data-lucide="clock" class="w-8 h-8 text-info"></i>
                    </div>
                </div>
                <div class="mt-4 flex items-center text-sm text-info font-medium">
                    Review Requests
                    <i data-lucide="arrow-right" class="w-4 h-4 ml-1"></i>
                </div>
            </div>
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Today's Schedule -->
        <div class="bg-card rounded-lg shadow-sm border border-border">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                    Today's Schedule
                </h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty todayAppointments}">
                        <div class="text-center py-8 text-muted-foreground">
                            <i data-lucide="check-circle" class="w-12 h-12 mx-auto mb-3 text-success"></i>
                            <p class="font-medium">No appointments today</p>
                            <p class="text-xs mt-1">Enjoy your free time!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="apt" items="${todayAppointments}">
                                <div class="p-4 bg-muted/50 rounded-lg border border-border">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="font-semibold text-foreground flex items-center gap-2">
                                            <i data-lucide="clock" class="w-4 h-4"></i>
                                            ${apt.time}
                                        </span>
                                        <c:choose>
                                            <c:when test="${apt.status == 'CONFIRMED'}">
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-green-100 text-green-800 border border-green-200">Confirmed</span>
                                            </c:when>
                                            <c:when test="${apt.status == 'PENDING'}">
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-800 border border-yellow-200">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-secondary text-secondary-foreground">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="text-sm text-muted-foreground mb-1">
                                        <strong>Student:</strong> ${apt.student.name}
                                    </p>
                                    <p class="text-sm text-muted-foreground">
                                        <strong>Type:</strong> ${apt.sessionType}
                                    </p>
                                    <c:if test="${not empty apt.notes}">
                                        <p class="text-xs text-muted-foreground mt-2 p-2 bg-background rounded">
                                            <strong>Notes:</strong> ${apt.notes}
                                        </p>
                                    </c:if>
                                    <c:if test="${apt.status == 'CONFIRMED'}">
                                        <button class="w-full mt-3 bg-primary text-primary-foreground px-4 py-2 rounded-md text-sm hover:opacity-90 transition-opacity flex items-center justify-center gap-2">
                                            <i data-lucide="video" class="w-4 h-4"></i>
                                            Join Session
                                        </button>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
                <a href="/counselor/schedule" class="block w-full mt-4">
                    <button class="w-full border border-border bg-background text-foreground px-4 py-2 rounded-md hover:bg-secondary transition-colors flex items-center justify-center gap-2">
                        <i data-lucide="calendar-days" class="w-4 h-4"></i>
                        View Full Schedule
                    </button>
                </a>
            </div>
        </div>

        <!-- Pending Requests -->
        <div class="bg-card rounded-lg shadow-sm border border-border">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="clock" class="w-5 h-5 mr-2 text-info"></i>
                    Pending Appointment Requests
                </h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty pendingAppointments}">
                        <div class="text-center py-8 text-muted-foreground">
                            <i data-lucide="check-circle" class="w-12 h-12 mx-auto mb-3 text-success"></i>
                            <p class="font-medium">No pending requests</p>
                            <p class="text-xs mt-1">All caught up!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="apt" items="${pendingAppointments}">
                                <div class="p-4 bg-info/10 rounded-lg border border-info/20">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="text-sm font-semibold text-foreground">
                                            ${apt.date} ${apt.time}
                                        </span>
                                        <span class="px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                    </div>
                                    <p class="text-sm text-muted-foreground mb-1">
                                        <strong>Student:</strong> ${apt.student.name}
                                    </p>
                                    <p class="text-sm text-muted-foreground mb-3">
                                        <strong>Type:</strong> ${apt.sessionType}
                                    </p>
                                    <c:if test="${not empty apt.notes}">
                                        <p class="text-xs text-muted-foreground mb-3 p-2 bg-background rounded">
                                            <strong>Notes:</strong> ${apt.notes}
                                        </p>
                                    </c:if>
                                    <div class="flex space-x-2">
                                        <form method="POST" action="/counselor/appointment/approve" class="flex-1">
                                            <input type="hidden" name="appointmentId" value="${apt.id}" />
                                            <button type="submit" class="w-full bg-green-600 text-white px-3 py-1.5 rounded-md text-sm hover:bg-green-700 transition-colors flex items-center justify-center gap-1">
                                                <i data-lucide="check" class="w-3 h-3"></i>
                                                Approve
                                            </button>
                                        </form>
                                        <button type="button" 
                                                data-id="${apt.id}"
                                                data-name="${apt.student.name}"
                                                data-date="${apt.date}"
                                                data-time="${apt.time}"
                                                onclick="openDenyModal(this)"
                                                class="flex-1 border border-red-600 text-red-600 px-3 py-1.5 rounded-md text-sm hover:bg-red-50 transition-colors flex items-center justify-center gap-1">
                                            <i data-lucide="x" class="w-3 h-3"></i>
                                            Deny
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="bg-card rounded-lg shadow-sm border border-border">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="activity" class="w-5 h-5 mr-2 text-success"></i>
                    Recent Activity
                </h2>
            </div>
            <div class="p-6">
                <div class="space-y-4">
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-success rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">New appointment request</p>
                            <p class="text-xs text-muted-foreground">Student ID: #1234 - 15 min ago</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-info rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">Session completed</p>
                            <p class="text-xs text-muted-foreground">With Jane Doe - 1 hour ago</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-primary rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">Appointment confirmed</p>
                            <p class="text-xs text-muted-foreground">Tomorrow at 2:00 PM - 2 hours ago</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-yellow-500 rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">Student feedback received</p>
                            <p class="text-xs text-muted-foreground">Rating: 5/5 - 3 hours ago</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
        <a href="/counselor/content" class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow block">
            <div class="flex items-center justify-between mb-3">
                <h3 class="text-lg font-semibold text-foreground">Content Manager</h3>
                <i data-lucide="file-text" class="w-6 h-6 text-primary"></i>
            </div>
            <p class="text-sm text-muted-foreground mb-4">Create and manage educational content for students.</p>
            <div class="text-primary font-medium flex items-center gap-2 text-sm">
                Manage Content
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </div>
        </a>

        <a href="/counselor/profile" class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow block">
            <div class="flex items-center justify-between mb-3">
                <h3 class="text-lg font-semibold text-foreground">My Profile</h3>
                <i data-lucide="user" class="w-6 h-6 text-primary"></i>
            </div>
            <p class="text-sm text-muted-foreground mb-4">Update your professional profile and credentials.</p>
            <div class="text-primary font-medium flex items-center gap-2 text-sm">
                Edit Profile
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </div>
        </a>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow">
            <div class="flex items-center justify-between mb-3">
                <h3 class="text-lg font-semibold text-foreground">Resources</h3>
                <i data-lucide="book-open" class="w-6 h-6 text-primary"></i>
            </div>
            <p class="text-sm text-muted-foreground mb-4">Access counseling resources and guidelines.</p>
            <button class="text-primary font-medium flex items-center gap-2 text-sm hover:underline">
                View Resources
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>
        </div>
    </div>
</div>

<!-- Denial Reason Modal (Reused from schedule.jsp) -->
<div id="deny-modal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center p-4">
    <div class="bg-card rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-border">
            <h2 class="text-xl font-semibold text-foreground">Deny Appointment Request</h2>
        </div>
        
        <form method="POST" action="/counselor/appointment/deny" id="deny-form">
            <div class="p-6">
                <p class="mb-4 text-foreground">You are about to deny the following appointment:</p>
                
                <div class="bg-muted p-4 rounded-lg space-y-2 mb-4">
                    <p class="text-sm"><strong>Student:</strong> <span id="deny-student-name">-</span></p>
                    <p class="text-sm"><strong>Date & Time:</strong> <span id="deny-datetime">-</span></p>
                </div>
                
                <div class="mb-4">
                    <label for="denial-reason" class="block text-sm font-medium text-foreground mb-2">
                        Reason for Denial <span class="text-red-600">*</span>
                    </label>
                    <textarea 
                        id="denial-reason" 
                        name="reason" 
                        rows="4" 
                        required
                        placeholder="Please provide a reason for denying this appointment request..."
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background resize-none"
                    ></textarea>
                    <p class="text-xs text-muted-foreground mt-1">
                        This reason will be shared with the student.
                    </p>
                </div>
                
                <input type="hidden" name="appointmentId" id="deny-appointment-id" />
            </div>

            <div class="p-6 border-t border-border flex justify-end gap-3">
                <button type="button" onclick="closeDenyModal()" class="px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                    Cancel
                </button>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors">
                    Confirm Denial
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openDenyModal(buttonElement) {
    // specific fix: read data from attributes instead of params
    const appointmentId = buttonElement.getAttribute('data-id');
    const studentName = buttonElement.getAttribute('data-name');
    const date = buttonElement.getAttribute('data-date');
    const time = buttonElement.getAttribute('data-time');

    document.getElementById('deny-appointment-id').value = appointmentId;
    document.getElementById('deny-student-name').textContent = studentName;
    document.getElementById('deny-datetime').textContent = date + ' at ' + time;
    document.getElementById('denial-reason').value = '';
    
    document.getElementById('deny-modal').classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function closeDenyModal() {
    document.getElementById('deny-modal').classList.add('hidden');
    document.body.style.overflow = 'auto';
}

// Close modal when clicking outside
document.getElementById('deny-modal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeDenyModal();
    }
});

// Auto-dismiss messages
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.fade-in');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
});
</script>

<jsp:include page="../common/footer.jsp" />