<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Admin Dashboard</h1>
<div class="mb-8">
    <h2 class="text-2xl font-semibold text-foreground">Welcome, Administrator!</h2>
    <p class="text-muted-foreground mt-2">Manage users, system settings, and platform analytics.</p>
</div>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-primary">User Management</h3>
        <p class="text-muted-foreground mb-4">Manage students, counselors, and admin accounts.</p>
        <button class="bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90 transition-all duration-300">
            Manage Users
        </button>
    </div>

    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-success">System Analytics</h3>
        <p class="text-muted-foreground mb-4">View platform usage statistics and reports.</p>
        <button class="bg-success text-success-foreground px-4 py-2 rounded-lg hover:bg-success/90 transition-all duration-300">
            View Analytics
        </button>
    </div>

    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-3 text-info">System Settings</h3>
        <p class="text-muted-foreground mb-4">Configure platform settings and preferences.</p>
        <button class="bg-info text-info-foreground px-4 py-2 rounded-lg hover:bg-info/90 transition-all duration-300">
            Settings
        </button>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

