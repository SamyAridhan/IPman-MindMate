<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <!-- Welcome Section -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">Welcome back, ${sessionScope.userName != null ? sessionScope.userName : 'Student'}!</h1>
        <p class="text-muted-foreground">How are you feeling today?</p>
    </div>

    <!-- Quick Start Card -->
    <div class="bg-gradient-to-r from-primary/10 to-primary/5 p-6 rounded-lg shadow-sm border border-primary/20 mb-8">
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

    <!-- New in Learning Hub -->
    <div class="bg-card p-6 rounded-lg shadow-sm border border-border mb-8">
        <div class="flex items-center mb-4">
            <i data-lucide="book-open" class="w-5 h-5 mr-2 text-success"></i>
            <h2 class="text-xl font-semibold text-foreground">New in the Learning Hub</h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Learning Item 1 -->
            <div class="p-4 bg-secondary/30 rounded-lg border border-border hover:shadow-md transition-all cursor-pointer">
                <span class="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-full border border-border">article</span>
                <h4 class="font-semibold text-foreground mt-2 mb-1">Stress Management 101</h4>
                <p class="text-sm text-muted-foreground line-clamp-2">Learn effective stress coping strategies for students</p>
                <a href="/student/library" class="text-primary text-sm font-medium mt-2 inline-block hover:underline">
                    Learn more →
                </a>
            </div>
            <!-- Learning Item 2 -->
            <div class="p-4 bg-secondary/30 rounded-lg border border-border hover:shadow-md transition-all cursor-pointer">
                <span class="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-full border border-border">video</span>
                <h4 class="font-semibold text-foreground mt-2 mb-1">Mindfulness Meditation Guide</h4>
                <p class="text-sm text-muted-foreground line-clamp-2">15-minute guided meditation for anxiety relief</p>
                <a href="/student/library" class="text-primary text-sm font-medium mt-2 inline-block hover:underline">
                    Learn more →
                </a>
            </div>
            <!-- Learning Item 3 -->
            <div class="p-4 bg-secondary/30 rounded-lg border border-border hover:shadow-md transition-all cursor-pointer">
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
        <!-- Left Column (2/3 width) -->
        <div class="lg:col-span-2 space-y-6">
            
            <!-- Progress Dashboard -->
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <i data-lucide="trending-up" class="w-5 h-5 mr-2 text-info"></i>
                        <h2 class="text-xl font-semibold text-foreground">Progress Dashboard</h2>
                    </div>
                    <select class="px-3 py-1.5 border border-input rounded-md bg-background text-sm">
                        <option>This Week</option>
                        <option>This Month</option>
                        <option>This Quarter</option>
                    </select>
                </div>

                <!-- Weekly Mood Tracker -->
                <div class="mb-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="font-medium text-foreground">Weekly Mood Tracker</h4>
                        <span class="px-2 py-0.5 bg-success/20 text-success text-sm rounded-full">7.4/10</span>
                    </div>
                    <div class="grid grid-cols-7 gap-2">
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Mon</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">7</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Tue</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">6</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Wed</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">8</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Thu</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">7</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Fri</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">9</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Sat</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">8</div>
                        </div>
                        <div class="text-center">
                            <div class="text-xs text-muted-foreground mb-1">Sun</div>
                            <div class="bg-info/20 rounded-full h-8 flex items-center justify-center text-sm font-medium text-info">7</div>
                        </div>
                    </div>
                </div>

                <!-- Activity Progress -->
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
                            <div class="w-full bg-secondary rounded-full h-2">
                                <div class="bg-primary h-2 rounded-full" style="width: 75%"></div>
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
                            <div class="w-full bg-secondary rounded-full h-2">
                                <div class="bg-primary h-2 rounded-full" style="width: 50%"></div>
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
                            <div class="w-full bg-secondary rounded-full h-2">
                                <div class="bg-primary h-2 rounded-full" style="width: 90%"></div>
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
                            <div class="w-full bg-secondary rounded-full h-2">
                                <div class="bg-primary h-2 rounded-full" style="width: 100%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- AI Recommendations -->
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-semibold text-foreground">AI Recommendations</h2>
                    <div class="flex items-center space-x-2">
                        <select class="px-3 py-1.5 border border-input rounded-md bg-background text-sm">
                            <option>All Topics</option>
                            <option>Stress</option>
                            <option>Sleep</option>
                            <option>Anxiety</option>
                        </select>
                        <button class="p-1.5 border border-input rounded-md hover:bg-secondary transition-colors">
                            <i data-lucide="refresh-cw" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>

                <div class="space-y-4">
                    <!-- Recommendation 1 -->
                    <div class="p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-2">
                                    <i data-lucide="video" class="w-4 h-4"></i>
                                    <h4 class="font-medium text-foreground">Mindfulness for Beginners</h4>
                                </div>
                                <p class="text-sm text-muted-foreground mb-2">Based on your stress levels, try this calming session</p>
                                <div class="flex items-center space-x-3 text-xs text-muted-foreground">
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">video</span>
                                    <span>15 min</span>
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">stress</span>
                                </div>
                            </div>
                            <div class="flex items-center space-x-1 ml-4">
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="bookmark" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-up" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-down" class="w-4 h-4"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Recommendation 2 -->
                    <div class="p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-2">
                                    <i data-lucide="file-text" class="w-4 h-4"></i>
                                    <h4 class="font-medium text-foreground">Sleep Hygiene Tips</h4>
                                </div>
                                <p class="text-sm text-muted-foreground mb-2">Improve your sleep quality with simple changes</p>
                                <div class="flex items-center space-x-3 text-xs text-muted-foreground">
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">article</span>
                                    <span>5 min read</span>
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">sleep</span>
                                </div>
                            </div>
                            <div class="flex items-center space-x-1 ml-4">
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="bookmark" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-up" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-down" class="w-4 h-4"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Recommendation 3 -->
                    <div class="p-4 bg-secondary/30 rounded-lg hover:bg-secondary/50 transition-colors">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-2 mb-2">
                                    <i data-lucide="dumbbell" class="w-4 h-4"></i>
                                    <h4 class="font-medium text-foreground">Breathing Exercises</h4>
                                </div>
                                <p class="text-sm text-muted-foreground mb-2">Quick techniques for anxiety management</p>
                                <div class="flex items-center space-x-3 text-xs text-muted-foreground">
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">exercise</span>
                                    <span>10 min</span>
                                    <span class="px-2 py-0.5 bg-background rounded-full border border-border">anxiety</span>
                                </div>
                            </div>
                            <div class="flex items-center space-x-1 ml-4">
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="bookmark" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-up" class="w-4 h-4"></i>
                                </button>
                                <button class="p-2 hover:bg-background rounded-md transition-colors">
                                    <i data-lucide="thumbs-down" class="w-4 h-4"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Right Column (1/3 width) -->
        <div class="space-y-6">
            
            <!-- Upcoming Sessions -->
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center mb-4">
                    <i data-lucide="calendar" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Upcoming Sessions</h2>
                </div>

                <div class="space-y-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.bookedAppointment}">
                            <!-- Display Booked Appointment -->
                            <div class="p-3 bg-primary/10 rounded-lg border-l-4 border-primary">
                                <div class="flex items-center justify-between mb-2">
                                    <h4 class="font-medium text-foreground">${sessionScope.bookedAppointment.sessionType}</h4>
                                    <span class="px-2 py-0.5 text-xs bg-background rounded-full border border-border flex items-center gap-1">
                                        <i data-lucide="clock" class="w-3 h-3"></i>
                                        ${sessionScope.bookedAppointment.time}
                                    </span>
                                </div>
                                <p class="text-sm text-muted-foreground mb-1">with ${sessionScope.bookedAppointment.counselorName}</p>
                                <p class="text-xs text-muted-foreground">${sessionScope.bookedAppointment.date}</p>
                                <div class="flex space-x-2 mt-2">
                                    <button class="text-xs px-2 py-1 border border-border rounded-md hover:bg-secondary transition-colors">
                                        Reschedule
                                    </button>
                                    <button class="text-xs px-2 py-1 border border-border rounded-md hover:bg-secondary transition-colors">
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- No Appointments -->
                            <div class="text-center py-8 text-muted-foreground">
                                <i data-lucide="calendar" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                                <p>No upcoming sessions</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <a href="/student/telehealth" class="block w-full bg-primary text-primary-foreground text-center px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                        <span class="flex items-center justify-center gap-2">
                            <i data-lucide="calendar" class="w-4 h-4"></i>
                            Book New Session
                        </span>
                    </a>
                </div>
            </div>

            <!-- Notifications -->
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center mb-4">
                    <i data-lucide="bell" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Notifications</h2>
                </div>

                <div class="space-y-3">
                    <div class="p-3 bg-info/10 rounded-lg border-l-4 border-info">
                        <p class="text-sm text-foreground">New session scheduled for tomorrow at 2 PM</p>
                        <span class="px-2 py-0.5 bg-info/20 text-info text-xs rounded-full inline-block mt-1">appointment</span>
                    </div>
                    <div class="p-3 bg-info/10 rounded-lg border-l-4 border-info">
                        <p class="text-sm text-foreground">Complete your weekly mood check-in</p>
                        <span class="px-2 py-0.5 bg-info/20 text-info text-xs rounded-full inline-block mt-1">reminder</span>
                    </div>
                    <div class="p-3 bg-info/10 rounded-lg border-l-4 border-info">
                        <p class="text-sm text-foreground">New peer discussion in Anxiety Support group</p>
                        <span class="px-2 py-0.5 bg-info/20 text-info text-xs rounded-full inline-block mt-1">forum</span>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
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
<!-- Student-Only Chatbot Widget -->
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />