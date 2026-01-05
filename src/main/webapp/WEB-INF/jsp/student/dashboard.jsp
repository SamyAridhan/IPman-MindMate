<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

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
                <a href="/student/assessment" class="inline-flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    <i data-lucide="heart" class="w-4 h-4"></i>
                    Take Student Survey
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
                    <h2 class="text-xl font-semibold text-foreground">AI Recommendations</h2>
                    <div class="flex items-center space-x-2">
                        <select class="px-3 py-1.5 border border-input rounded-md bg-background text-sm">
                            <option>All Topics</option>
                            <option>Stress</option>
                            <option>Sleep</option>
                            <option>Anxiety</option>
                        </select>
                        <button class="icon-btn border border-input">
                            <i data-lucide="refresh-cw" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>

                <div class="space-y-4">
                    <a href="/student/recommendation?id=mindfulness-beginners"
                        class="block p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-2">
                                    <i data-lucide="video" class="w-4 h-4"></i>
                                    <h4 class="font-medium text-foreground">Mindfulness for Beginners</h4>
                                </div>
                                <p class="text-sm text-muted-foreground mb-2">Based on your stress levels, try this calming session</p>
                                <div class="flex items-center space-x-3 text-xs text-muted-foreground">
                                    <span class="badge-outline-blue">video</span>
                                    <span>15 min</span>
                                    <span class="badge-outline-blue">stress</span>
                                </div>
                            </div>
                            <div class="flex items-center space-x-1 ml-4">
                                <button class="icon-btn"><i data-lucide="bookmark" class="w-4 h-4"></i></button>
                                <button class="icon-btn"><i data-lucide="thumbs-up" class="w-4 h-4"></i></button>
                                <button class="icon-btn"><i data-lucide="thumbs-down" class="w-4 h-4"></i></button>
                            </div>
                        </div>
                    </a>
                    
                    <a href="/student/recommendation?id=sleep-hygiene-tips"
                        class="block p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-2">
                                    <i data-lucide="file-text" class="w-4 h-4"></i>
                                    <h4 class="font-medium text-foreground">Sleep Hygiene Tips</h4>
                                </div>
                                <p class="text-sm text-muted-foreground mb-2">Improve your sleep quality with simple changes</p>
                                <div class="flex items-center space-x-3 text-xs text-muted-foreground">
                                    <span class="badge-outline-blue">article</span>
                                    <span>5 min read</span>
                                    <span class="badge-outline-blue">sleep</span>
                                </div>
                            </div>
                            <div class="flex items-center space-x-1 ml-4">
                                <button class="icon-btn"><i data-lucide="bookmark" class="w-4 h-4"></i></button>
                                <button class="icon-btn"><i data-lucide="thumbs-up" class="w-4 h-4"></i></button>
                                <button class="icon-btn"><i data-lucide="thumbs-down" class="w-4 h-4"></i></button>
                            </div>
                        </div>
                    </a>
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

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />