<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
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
                        <p class="text-3xl font-bold text-foreground">${todayCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
                        <i data-lucide="calendar" class="w-6 h-6 text-primary"></i>
                    </div>
                </div>
            </div>
        </a>

        <a href="/counselor/schedule" class="block">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-lg transition-all cursor-pointer">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Pending Requests</p>
                        <p class="text-3xl font-bold text-foreground">${pendingCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-info/10 rounded-full flex items-center justify-center">
                        <i data-lucide="clock" class="w-6 h-6 text-info"></i>
                    </div>
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
                            <i data-lucide="check-circle" class="w-8 h-8 mx-auto mb-2 text-success"></i>
                            <p>No appointments today</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="apt" items="${todayAppointments}">
                                <div class="p-4 bg-muted/50 rounded-lg border border-border">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="font-semibold text-foreground">
                                            ${apt.time}
                                        </span>
                                        <c:choose>
                                            <c:when test="${apt.status == 'confirmed'}">
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-primary text-primary-foreground">Confirmed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-0.5 text-xs rounded-full bg-secondary text-secondary-foreground">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="text-sm text-muted-foreground">${apt.notes}</p>
                                    <c:if test="${apt.status == 'confirmed'}">
                                        <button class="w-full mt-2 bg-primary text-primary-foreground px-4 py-2 rounded-md text-sm hover:opacity-90 transition-opacity">
                                            Join Session
                                        </button>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
                <a href="/counselor/schedule" class="block w-full mt-4">
                    <button class="w-full border border-border bg-background text-foreground px-4 py-2 rounded-md hover:bg-secondary transition-colors">
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
                            <i data-lucide="check-circle" class="w-8 h-8 mx-auto mb-2 text-success"></i>
                            <p>No pending requests</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="apt" items="${pendingAppointments}">
                                <div class="p-4 bg-muted/50 rounded-lg border border-border">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="text-sm font-semibold text-foreground">
                                            ${apt.date} ${apt.time}
                                        </span>
                                    </div>
                                    <p class="text-sm text-muted-foreground mb-3">${apt.notes}</p>
                                    <div class="flex space-x-2">
                                        <form method="POST" action="/counselor/appointment/approve" class="flex-1">
                                            <input type="hidden" name="appointmentId" value="${apt.id}" />
                                            <button type="submit" class="w-full bg-primary text-primary-foreground px-3 py-1.5 rounded-md text-sm hover:opacity-90 transition-opacity">
                                                Approve
                                            </button>
                                        </form>
                                        <form method="POST" action="/counselor/appointment/deny" class="flex-1">
                                            <input type="hidden" name="appointmentId" value="${apt.id}" />
                                            <button type="submit" class="w-full border border-border bg-background text-foreground px-3 py-1.5 rounded-md text-sm hover:bg-secondary transition-colors">
                                                Deny
                                            </button>
                                        </form>
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
                    <i data-lucide="users" class="w-5 h-5 mr-2 text-success"></i>
                    Recent Activity
                </h2>
            </div>
            <div class="p-6">
                <div class="space-y-4">
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-success rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">New assessment completed</p>
                            <p class="text-xs text-muted-foreground">Student ID: #1234 - 15 min ago</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-info rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">Module completed</p>
                            <p class="text-xs text-muted-foreground">Stress Management - 1 hour ago</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <div class="w-2 h-2 bg-primary rounded-full mt-2"></div>
                        <div class="flex-1">
                            <p class="text-sm text-foreground">New forum post</p>
                            <p class="text-xs text-muted-foreground">Community Discussion - 2 hours ago</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />