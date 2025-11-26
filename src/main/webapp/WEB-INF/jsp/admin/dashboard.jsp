<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-8">
    
    <div>
        <h1 class="text-3xl font-bold text-foreground mb-2">Admin Dashboard</h1>
        <h2 class="text-xl font-medium text-muted-foreground">Welcome, Administrator!</h2>
        <p class="text-muted-foreground mt-1">Manage users, system settings, and platform analytics.</p>
    </div>

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
            <button class="w-full bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                Settings
            </button>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />