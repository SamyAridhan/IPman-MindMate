<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    
    <c:if test="${param.success == 'approved'}">
        <div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-green-800">Appointment Approved</h3>
                <p class="text-sm text-green-700 mt-1">The appointment has been confirmed. The student will be notified.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.success == 'denied'}">
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="info" class="h-5 w-5 text-blue-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-blue-800">Appointment Denied</h3>
                <p class="text-sm text-blue-700 mt-1">The appointment has been denied. The student will be notified with your reason.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'notfound'}">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-red-800">Error</h3>
                <p class="text-sm text-red-700 mt-1">Appointment not found or action not permitted.</p>
            </div>
        </div>
    </c:if>

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">My Schedule</h1>
        <p class="text-muted-foreground">Manage your appointments and availability</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-1">
            <div class="bg-card rounded-lg shadow-sm border border-border">
                <div class="p-6 border-b border-border">
                    <h2 class="text-xl font-semibold text-foreground flex items-center">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                        Select Date
                    </h2>
                </div>
                <div class="p-6">
                    <div class="mb-4">
                        <div class="flex items-center justify-between mb-4">
                            <button type="button" class="p-1 hover:bg-secondary rounded">
                                <i data-lucide="chevron-left" class="w-5 h-5"></i>
                            </button>
                            <span class="font-semibold">January 2026</span>
                            <button type="button" class="p-1 hover:bg-secondary rounded">
                                <i data-lucide="chevron-right" class="w-5 h-5"></i>
                            </button>
                        </div>
                        
                        <div class="grid grid-cols-7 gap-1 text-center text-sm mb-2">
                            <div class="text-muted-foreground font-medium p-2">Su</div>
                            <div class="text-muted-foreground font-medium p-2">Mo</div>
                            <div class="text-muted-foreground font-medium p-2">Tu</div>
                            <div class="text-muted-foreground font-medium p-2">We</div>
                            <div class="text-muted-foreground font-medium p-2">Th</div>
                            <div class="text-muted-foreground font-medium p-2">Fr</div>
                            <div class="text-muted-foreground font-medium p-2">Sa</div>
                        </div>
                        
                        <div class="grid grid-cols-7 gap-1 text-center text-sm">
                            <div class="p-2 text-muted-foreground/50">28</div>
                            <div class="p-2 text-muted-foreground/50">29</div>
                            <div class="p-2 text-muted-foreground/50">30</div>
                            <div class="p-2 text-muted-foreground/50">31</div>

                            <c:forEach begin="1" end="31" var="day">
                                <c:set var="dayStr" value="${day < 10 ? '0' : ''}${day}" />
                                <c:set var="fullDate" value="2026-01-${dayStr}" />
                                
                                <div onclick="selectDate('${fullDate}')" 
                                     class="p-2 rounded cursor-pointer transition-colors
                                     ${selectedDate.toString() == fullDate ? 'bg-primary text-primary-foreground font-bold' : 'hover:bg-secondary'}">
                                    ${day}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="mt-6 p-4 bg-muted rounded-lg">
                        <h4 class="font-semibold mb-2 text-sm text-foreground">Availability Settings</h4>
                        <p class="text-xs text-muted-foreground mb-3">Current: Mon-Fri, 9 AM - 5 PM</p>
                        <button class="w-full border border-border bg-background text-foreground px-4 py-2 rounded-md text-sm hover:bg-secondary transition-colors flex items-center justify-center">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            Configure Availability
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="lg:col-span-2 space-y-6">
            <c:if test="${not empty pendingAppointments}">
                <div class="bg-card rounded-lg shadow-sm border border-border">
                    <div class="p-6 border-b border-border">
                        <h2 class="text-xl font-semibold text-foreground flex items-center">
                            <i data-lucide="clock" class="w-5 h-5 mr-2 text-info"></i>
                            Pending Requests (${pendingAppointments.size()})
                        </h2>
                    </div>
                    <div class="p-6">
                        <div class="space-y-3">
                            <c:forEach var="apt" items="${pendingAppointments}">
                                <div class="p-4 bg-info/10 rounded-lg border border-info/20">
                                    <div class="flex items-start justify-between">
                                        <div class="flex-1">
                                            <div class="flex items-center space-x-2 mb-2">
                                                <span class="font-semibold text-foreground">
                                                    ${apt.date} at ${apt.time}
                                                </span>
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                            </div>
                                            <p class="text-sm text-muted-foreground mb-1">
                                                <strong>Student:</strong> ${apt.student.name}
                                            </p>
                                            <p class="text-sm text-muted-foreground mb-1">
                                                <strong>Session Type:</strong> ${apt.sessionType}
                                            </p>
                                            <c:if test="${not empty apt.notes}">
                                                <p class="text-sm text-muted-foreground mt-2 p-2 bg-muted rounded">
                                                    <strong>Student Notes:</strong> ${apt.notes}
                                                </p>
                                            </c:if>
                                        </div>
                                        <div class="flex flex-col space-y-2 ml-4">
                                            <form method="POST" action="/counselor/appointment/approve">
                                                <input type="hidden" name="appointmentId" value="${apt.id}" />
                                                <button type="submit" class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-md text-sm hover:bg-green-700 transition-colors">
                                                    <i data-lucide="check-circle" class="w-4 h-4 mr-1"></i>
                                                    Approve
                                                </button>
                                            </form>
                                            
                                            <button type="button" 
                                                    data-id="${apt.id}"
                                                    data-student="${apt.student.name}"
                                                    data-date="${apt.date}"
                                                    data-time="${apt.time}"
                                                    onclick="openDenyModal(this)"
                                                    class="inline-flex items-center px-4 py-2 border border-red-600 text-red-600 rounded-md text-sm hover:bg-red-50 transition-colors">
                                                <i data-lucide="x-circle" class="w-4 h-4 mr-1"></i>
                                                Deny
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="bg-card rounded-lg shadow-sm border border-border">
                <div class="p-6 border-b border-border">
                    <h2 class="text-xl font-semibold text-foreground flex items-center">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                        <c:choose>
                            <c:when test="${selectedDate.equals(java.time.LocalDate.now())}">
                                Today's Appointments
                            </c:when>
                            <c:otherwise>
                                Appointments for ${selectedDate}
                            </c:otherwise>
                        </c:choose>
                    </h2>
                </div>
                <div class="p-6">
                    <c:choose>
                        <c:when test="${empty todayAppointments}">
                            <div class="text-center py-8 text-muted-foreground">
                                <i data-lucide="calendar" class="w-12 h-12 mx-auto mb-2 text-muted-foreground/50"></i>
                                <p>No appointments scheduled for this date</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach var="apt" items="${todayAppointments}">
                                    <c:set var="statusColor">
                                        <c:choose>
                                            <c:when test="${apt.status == 'CONFIRMED'}">bg-success/10 border-success/20</c:when>
                                            <c:when test="${apt.status == 'PENDING'}">bg-info/10 border-info/20</c:when>
                                            <c:when test="${apt.status == 'CANCELLED'}">bg-destructive/10 border-destructive/20</c:when>
                                            <c:when test="${apt.status == 'DENIED'}">bg-destructive/10 border-destructive/20</c:when>
                                            <c:otherwise>bg-muted border-border</c:otherwise>
                                        </c:choose>
                                    </c:set>
                                    
                                    <div class="p-4 rounded-lg border ${statusColor}">
                                        <div class="flex items-start justify-between mb-3">
                                            <div class="flex-1">
                                                <div class="flex items-center space-x-2 mb-1">
                                                    <i data-lucide="clock" class="w-4 h-4 text-muted-foreground"></i>
                                                    <span class="font-semibold text-foreground">${apt.time}</span>
                                                    <c:choose>
                                                        <c:when test="${apt.status == 'CONFIRMED'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-green-100 text-green-800">Confirmed</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'PENDING'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'CANCELLED'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-red-100 text-red-800">Cancelled by Student</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'DENIED'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-red-100 text-red-800">Denied</span>
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
                                                    <p class="text-sm text-muted-foreground mt-2 p-2 bg-muted rounded">
                                                        <strong>Notes:</strong> ${apt.notes}
                                                    </p>
                                                </c:if>
                                                <c:if test="${apt.status == 'DENIED' && not empty apt.denialReason}">
                                                    <p class="text-sm text-red-600 mt-2 p-2 bg-red-50 rounded border border-red-100">
                                                        <strong>Denial Reason:</strong> ${apt.denialReason}
                                                    </p>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${apt.status == 'CONFIRMED'}">
                                            <button class="w-full inline-flex items-center justify-center bg-primary text-primary-foreground px-4 py-2 rounded-md text-sm hover:opacity-90 transition-opacity">
                                                <i data-lucide="video" class="w-4 h-4 mr-2"></i>
                                                Join Telehealth Call
                                            </button>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

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
// Function to handle calendar clicks
function selectDate(dateString) {
    // Redirects the page with the selected date as a query parameter
    window.location.href = '/counselor/schedule?date=' + dateString;
}

// Accepts the button element instead of raw params
function openDenyModal(button) {
    const appointmentId = button.getAttribute('data-id');
    const studentName = button.getAttribute('data-student');
    const date = button.getAttribute('data-date');
    const time = button.getAttribute('data-time');

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

// Auto-dismiss success/error messages
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.bg-green-50, .bg-blue-50, .bg-red-50');
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