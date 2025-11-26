<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-8">

    <div>
        <h1 class="text-3xl font-bold text-foreground mb-2">Student Dashboard</h1>
        <h2 class="text-xl font-medium text-muted-foreground">Welcome Back!</h2>
        <p class="text-muted-foreground mt-1">Here's what's happening with your mental health journey today.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="clipboard-list" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Take Assessment</h3>
                <p class="text-muted-foreground text-sm">Complete a mental health assessment to track your progress.</p>
            </div>
            <div class="mt-auto">
                <a href="/student/assessment" class="w-full text-center bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-block font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                    Start Assessment
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="calendar-clock" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Next Appointment</h3>
                <p class="text-muted-foreground text-sm">Your next telehealth session is scheduled.</p>
            </div>
            <div class="mt-auto">
                <a href="/student/telehealth/my-appointments" class="w-full text-center bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-block font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                    View Appointments
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="book-open" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Latest Article</h3>
                <p class="text-muted-foreground text-sm">Read our latest content on mental wellness.</p>
            </div>
            <div class="mt-auto">
                <a href="/student/library" class="w-full text-center bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-block font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                    Browse Library
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />