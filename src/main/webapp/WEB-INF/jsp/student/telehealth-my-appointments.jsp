<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">My Appointments</h1>

    <!-- Success Message (only show if coming from booking) -->
    <c:if test="${param.success eq 'true'}">
        <div class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-green-800">Success</h3>
                <p class="text-sm text-green-700 mt-1">
                    Your appointment has been booked successfully.
                </p>
            </div>
        </div>
    </c:if>

    <div class="bg-card shadow-sm border border-border rounded-lg overflow-hidden">
        <div class="px-6 py-5 border-b border-border">
            <h3 class="text-lg font-semibold text-foreground">Upcoming Sessions</h3>
        </div>
        
        <c:choose>
            <c:when test="${not empty bookedAppointments}">
                <ul class="divide-y divide-border">
                    <c:forEach var="appointment" items="${bookedAppointments}">
                        <li class="px-6 py-5 hover:bg-secondary/20 transition-colors">
                            <div class="flex items-center justify-between mb-2">
                                <p class="text-lg font-medium text-foreground">
                                    Session with <span class="text-primary">${appointment.counselorName}</span>
                                </p>
                                <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-green-100 text-green-800 border border-green-200">
                                    ${appointment.status}
                                </span>
                            </div>
                            
                            <div class="sm:flex sm:justify-between">
                                <div class="sm:flex gap-6">
                                    <p class="flex items-center text-sm text-muted-foreground">
                                        <i data-lucide="calendar" class="mr-2 h-4 w-4 text-primary"></i>
                                        ${appointment.date}
                                    </p>
                                    <p class="mt-2 flex items-center text-sm text-muted-foreground sm:mt-0">
                                        <i data-lucide="clock" class="mr-2 h-4 w-4 text-primary"></i>
                                        ${appointment.time}
                                    </p>
                                </div>
                                <div class="mt-3 sm:mt-0">
                                    <span class="text-sm text-muted-foreground">${appointment.sessionType}</span>
                                </div>
                            </div>
                            
                            <div class="flex space-x-2 mt-4">
                                <button class="text-xs px-3 py-1.5 border border-border rounded-md hover:bg-secondary transition-colors">
                                    Join Session
                                </button>
                                <button class="text-xs px-3 py-1.5 border border-border rounded-md hover:bg-secondary transition-colors">
                                    Reschedule
                                </button>
                                <form action="/student/telehealth/cancel" method="post" class="inline">
                                    <input type="hidden" name="appointmentId" value="${appointment.id}" />
                                    <button type="submit" class="text-xs px-3 py-1.5 border border-destructive text-destructive rounded-md hover:bg-destructive/10 transition-colors">
                                        Cancel
                                    </button>
                                </form>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="px-6 py-12 text-center">
                    <i data-lucide="calendar" class="w-12 h-12 mx-auto mb-3 text-muted-foreground/50"></i>
                    <p class="text-muted-foreground mb-4">No upcoming appointments</p>
                    <a href="/student/telehealth" class="inline-flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity">
                        <i data-lucide="calendar" class="w-4 h-4"></i>
                        Book New Session
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />