<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    
    <c:if test="${param.success == 'approved'}">
        <div class="fade-in bg-green-50 border border-green-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-green-800">Appointment Approved</h3>
                <p class="text-sm text-green-700 mt-1">The appointment has been confirmed. The student will be notified.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.success == 'denied'}">
        <div class="fade-in bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex items-start gap-3">
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

    <div class="mb-8">
        <div class="bg-card rounded-lg shadow-sm border border-border">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                    Today's Schedule (Upcoming)
                </h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty todayAppointments}">
                        <div class="text-center py-8 text-muted-foreground">
                            <i data-lucide="check-circle" class="w-12 h-12 mx-auto mb-3 text-success"></i>
                            <p class="font-medium">No active appointments today</p>
                            <p class="text-xs mt-1">All sessions are either completed or you are free!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <c:forEach var="apt" items="${todayAppointments}">
                                
                                <%-- Determine Card Color --%>
                                <c:set var="statusColor">
                                    <c:choose>
                                        <c:when test="${apt.status == 'CONFIRMED'}">bg-success/10 border-success/20</c:when>
                                        <c:when test="${apt.status == 'PENDING'}">bg-info/10 border-info/20</c:when>
                                        <c:otherwise>bg-muted border-border</c:otherwise>
                                    </c:choose>
                                </c:set>

                                <div class="p-4 rounded-lg border ${statusColor} hover:shadow-sm transition-shadow">
                                    <div class="flex items-start justify-between mb-2">
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
                                    
                                    <%-- Only show JOIN button for Confirmed --%>
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
    </div>
</div>

<script>
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