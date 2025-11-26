<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-8">

    <div>
        <h1 class="text-3xl font-bold text-foreground mb-2">Counselor Dashboard</h1>
        <h2 class="text-xl font-medium text-muted-foreground">Welcome, Counselor!</h2>
        <p class="text-muted-foreground mt-1">Manage your schedule and content from here.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="calendar" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Today's Schedule</h3>
                <p class="text-muted-foreground text-sm">View and manage your appointments for today.</p>
            </div>
            <div class="mt-auto">
                <a href="/counselor/schedule" class="w-full text-center bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-block font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                    View Schedule
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="file-text" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Content Manager</h3>
                <p class="text-muted-foreground text-sm">Create and manage educational content for students.</p>
            </div>
            <div class="mt-auto">
                <a href="/counselor/content" class="w-full text-center bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-block font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                    Manage Content
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />