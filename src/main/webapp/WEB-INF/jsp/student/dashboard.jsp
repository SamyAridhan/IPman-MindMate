<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Student Dashboard</h1>
<div class="mb-8">
    <h2 class="text-2xl font-semibold text-foreground">Welcome Back!</h2>
    <p class="text-muted-foreground mt-2">Here's what's happening with your mental health journey today.</p>
</div>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <!-- Take Assessment Card -->
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-primary">Take Assessment</h3>
        <p class="text-muted-foreground mb-4">Complete a mental health assessment to track your progress.</p>
        <a href="/student/assessment" class="bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90 inline-block transition-all duration-300">
            Start Assessment
        </a>
    </div>

    <!-- Next Appointment Card -->
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-success">Next Appointment</h3>
        <p class="text-muted-foreground mb-4">Your next telehealth session is scheduled.</p>
        <a href="/student/telehealth/my-appointments" class="bg-success text-success-foreground px-4 py-2 rounded-lg hover:bg-success/90 inline-block transition-all duration-300">
            View Appointments
        </a>
    </div>

    <!-- Latest Article Card -->
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-info">Latest Article</h3>
        <p class="text-muted-foreground mb-4">Read our latest content on mental wellness.</p>
        <a href="/student/library" class="bg-info text-info-foreground px-4 py-2 rounded-lg hover:bg-info/90 inline-block transition-all duration-300">
            Browse Library
        </a>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

