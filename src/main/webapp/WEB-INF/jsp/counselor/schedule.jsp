<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">My Schedule</h1>
        <p class="text-muted-foreground">Manage your appointments and availability</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Calendar Section -->
        <div class="lg:col-span-1">
            <div class="bg-card rounded-lg shadow-sm border border-border">
                <div class="p-6 border-b border-border">
                    <h2 class="text-xl font-semibold text-foreground flex items-center">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                        Select Date
                    </h2>
                </div>
                <div class="p-6">
                    <!-- Simple Calendar Display -->
                    <div class="mb-4">
                        <div class="flex items-center justify-between mb-4">
                            <button type="button" class="p-1 hover:bg-secondary rounded">
                                <i data-lucide="chevron-left" class="w-5 h-5"></i>
                            </button>
                            <span class="font-semibold">December 2025</span>
                            <button type="button" class="p-1 hover:bg-secondary rounded">
                                <i data-lucide="chevron-right" class="w-5 h-5"></i>
                            </button>
                        </div>
                        
                        <!-- Week Headers -->
                        <div class="grid grid-cols-7 gap-1 text-center text-sm mb-2">
                            <div class="text-muted-foreground font-medium p-2">Su</div>
                            <div class="text-muted-foreground font-medium p-2">Mo</div>
                            <div class="text-muted-foreground font-medium p-2">Tu</div>
                            <div class="text-muted-foreground font-medium p-2">We</div>
                            <div class="text-muted-foreground font-medium p-2">Th</div>
                            <div class="text-muted-foreground font-medium p-2">Fr</div>
                            <div class="text-muted-foreground font-medium p-2">Sa</div>
                        </div>
                        
                        <!-- Calendar Days -->
                        <div class="grid grid-cols-7 gap-1 text-center text-sm">
                            <div class="p-2 text-muted-foreground/50">30</div>
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer">1</div>
                            <div class="p-2 bg-primary text-primary-foreground rounded cursor-pointer">2</div>
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer">3</div>
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer">4</div>
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer">5</div>
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer">6</div>
                            <c:forEach begin="7" end="31" var="day">
                                <div class="p-2 hover:bg-secondary rounded cursor-pointer">${day}</div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <!-- Availability Settings -->
                    <div class="mt-6 p-4 bg-muted rounded-lg">
                        <h4 class="font-semibold mb-2 text-sm text-foreground">Availability Settings</h4>
                        <p class="text-xs text-muted-foreground mb-3">Set your working hours and days</p>
                        <button class="w-full border border-border bg-background text-foreground px-4 py-2 rounded-md text-sm hover:bg-secondary transition-colors flex items-center justify-center">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            Configure Availability
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Appointments Section -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Pending Requests -->
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
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-secondary text-secondary-foreground">Pending</span>
                                            </div>
                                            <p class="text-sm text-muted-foreground">${apt.notes}</p>
                                        </div>
                                        <div class="flex space-x-2 ml-4">
                                            <form method="POST" action="/counselor/appointment/approve">
                                                <input type="hidden" name="appointmentId" value="${apt.id}" />
                                                <button type="submit" class="inline-flex items-center px-3 py-1.5 bg-primary text-primary-foreground rounded-md text-sm hover:opacity-90 transition-opacity">
                                                    <i data-lucide="check-circle" class="w-4 h-4 mr-1"></i>
                                                    Approve
                                                </button>
                                            </form>
                                            <form method="POST" action="/counselor/appointment/deny">
                                                <input type="hidden" name="appointmentId" value="${apt.id}" />
                                                <button type="submit" class="inline-flex items-center px-3 py-1.5 border border-destructive text-destructive rounded-md text-sm hover:bg-destructive/10 transition-colors">
                                                    <i data-lucide="x-circle" class="w-4 h-4 mr-1"></i>
                                                    Deny
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Selected Date Appointments -->
            <div class="bg-card rounded-lg shadow-sm border border-border">
                <div class="p-6 border-b border-border">
                    <h2 class="text-xl font-semibold text-foreground flex items-center">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                        Appointments on December 02, 2025
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
                                            <c:when test="${apt.status == 'confirmed'}">bg-success/10 border-success/20</c:when>
                                            <c:when test="${apt.status == 'pending'}">bg-info/10 border-info/20</c:when>
                                            <c:when test="${apt.status == 'cancelled'}">bg-destructive/10 border-destructive/20</c:when>
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
                                                        <c:when test="${apt.status == 'confirmed'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-primary text-primary-foreground">Confirmed</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'pending'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-secondary text-secondary-foreground">Pending</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'cancelled'}">
                                                            <span class="px-2 py-0.5 text-xs rounded-full bg-destructive text-destructive-foreground">Cancelled</span>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                                <p class="text-sm text-muted-foreground">${apt.notes}</p>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${apt.status == 'confirmed'}">
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

<jsp:include page="../common/footer.jsp" />