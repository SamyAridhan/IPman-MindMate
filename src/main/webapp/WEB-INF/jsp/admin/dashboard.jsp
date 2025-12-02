<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-8">
    
    <div>
        <h1 class="text-3xl font-bold text-foreground mb-2">Admin Dashboard</h1>
        <p class="text-muted-foreground mt-1">System management and oversight</p>
    </div>

    <!-- KPI Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        
        <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
            <div class="flex items-center justify-between mb-2">
                <h3 class="text-sm font-medium text-foreground">Total Users</h3>
                <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
            </div>
            <div class="text-2xl font-bold text-foreground">1,234</div>
            <p class="text-xs text-green-600 mt-1">+12% from last month</p>
        </div>

        <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
            <div class="flex items-center justify-between mb-2">
                <h3 class="text-sm font-medium text-foreground">Active Users</h3>
                <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
            </div>
            <div class="text-2xl font-bold text-foreground">856</div>
            <p class="text-xs text-green-600 mt-1">+5% from last month</p>
        </div>

        <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
            <div class="flex items-center justify-between mb-2">
                <h3 class="text-sm font-medium text-foreground">Assessments Taken</h3>
                <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
            </div>
            <div class="text-2xl font-bold text-foreground">3,421</div>
            <p class="text-xs text-green-600 mt-1">+18% from last month</p>
        </div>

        <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
            <div class="flex items-center justify-between mb-2">
                <h3 class="text-sm font-medium text-foreground">Forum Posts</h3>
                <svg class="h-4 w-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
                </svg>
            </div>
            <div class="text-2xl font-bold text-foreground">1,089</div>
            <p class="text-xs text-green-600 mt-1">+23% from last month</p>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        <!-- User Engagement Chart -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <div class="mb-4">
                <h3 class="text-xl font-semibold text-foreground">User Engagement Over Time</h3>
                <p class="text-sm text-muted-foreground">Monthly active users</p>
            </div>
            <div class="h-64 flex items-end justify-between space-x-2">
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 40%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">Jan</span>
                </div>
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 60%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">Feb</span>
                </div>
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 80%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">Mar</span>
                </div>
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 75%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">Apr</span>
                </div>
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 90%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">May</span>
                </div>
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-primary rounded-t" style="height: 100%;"></div>
                    <span class="text-xs text-muted-foreground mt-2">Jun</span>
                </div>
            </div>
        </div>

        <!-- Module Popularity Chart -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <div class="mb-4">
                <h3 class="text-xl font-semibold text-foreground">Module Popularity</h3>
                <p class="text-sm text-muted-foreground">Most accessed content</p>
            </div>
            <div class="space-y-4">
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-sm text-foreground">Stress Management</span>
                        <span class="text-sm font-medium text-foreground">450</span>
                    </div>
                    <div class="w-full bg-secondary rounded-full h-2">
                        <div class="bg-primary h-2 rounded-full" style="width: 100%;"></div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-sm text-foreground">Anxiety Relief</span>
                        <span class="text-sm font-medium text-foreground">380</span>
                    </div>
                    <div class="w-full bg-secondary rounded-full h-2">
                        <div class="bg-primary h-2 rounded-full" style="width: 84%;"></div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-sm text-foreground">Sleep Hygiene</span>
                        <span class="text-sm font-medium text-foreground">320</span>
                    </div>
                    <div class="w-full bg-secondary rounded-full h-2">
                        <div class="bg-primary h-2 rounded-full" style="width: 71%;"></div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-sm text-foreground">Social Skills</span>
                        <span class="text-sm font-medium text-foreground">280</span>
                    </div>
                    <div class="w-full bg-secondary rounded-full h-2">
                        <div class="bg-primary h-2 rounded-full" style="width: 62%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Original Action Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow">
            <h3 class="text-xl font-semibold mb-3 text-foreground">User Management</h3>
            <p class="text-muted-foreground mb-6">Manage students, counselors, and admin accounts.</p>
            <button class="w-full bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                Manage Users
            </button>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow">
            <h3 class="text-xl font-semibold mb-3 text-foreground">System Analytics</h3>
            <p class="text-muted-foreground mb-6">View platform usage statistics and reports.</p>
            <button class="w-full bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                View Analytics
            </button>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow">
            <h3 class="text-xl font-semibold mb-3 text-foreground">System Settings</h3>
            <p class="text-muted-foreground mb-6">Configure platform settings and preferences.</p>
            <button class="w-full bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium focus:ring-2 focus:ring-ring">
                Settings
            </button>
        </div>
    </div>
</div>
</div>

<jsp:include page="../common/footer.jsp" />