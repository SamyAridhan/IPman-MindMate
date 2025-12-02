<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="max-w-3xl mx-auto space-y-6">
        
        <!-- Profile Card -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-foreground mb-1">User Profile</h1>
                <p class="text-sm text-muted-foreground">Manage your account settings and preferences</p>
            </div>

            <!-- Profile Information Section -->
            <div class="space-y-4 mb-6">
                <div class="space-y-2">
                    <label for="name" class="block text-sm font-medium text-foreground">Name</label>
                    <input 
                        type="text" 
                        id="name" 
                        value="Admin User"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                    />
                </div>
                
                <div class="space-y-2">
                    <label for="email" class="block text-sm font-medium text-foreground">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        value="admin.user@example.com"
                        disabled
                        class="w-full px-3 py-2 border border-input rounded-md bg-muted text-muted-foreground cursor-not-allowed"
                    />
                </div>

                <div class="space-y-2">
                    <label for="role" class="block text-sm font-medium text-foreground">Role</label>
                    <input 
                        type="text" 
                        id="role" 
                        value="System Administrator"
                        disabled
                        class="w-full px-3 py-2 border border-input rounded-md bg-muted text-muted-foreground cursor-not-allowed"
                    />
                </div>

                <div class="space-y-2">
                    <label for="department" class="block text-sm font-medium text-foreground">Department</label>
                    <input 
                        type="text" 
                        id="department" 
                        value="IT & System Management"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                    />
                </div>
                
                <button 
                    type="button"
                    onclick="alert('Profile updated successfully!')"
                    class="bg-primary text-primary-foreground px-6 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    Update Profile
                </button>
            </div>

            <hr class="border-border my-6">

            <!-- Change Password Section -->
            <div class="space-y-4 mb-6">
                <h3 class="text-lg font-semibold text-foreground">Change Password</h3>
                
                <div class="space-y-2">
                    <label for="new-password" class="block text-sm font-medium text-foreground">New Password</label>
                    <input 
                        type="password" 
                        id="new-password" 
                        placeholder="Enter new password (min 6 characters)"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                    />
                </div>
                
                <div class="space-y-2">
                    <label for="confirm-password" class="block text-sm font-medium text-foreground">Confirm New Password</label>
                    <input 
                        type="password" 
                        id="confirm-password" 
                        placeholder="Confirm new password"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                    />
                </div>
                
                <button 
                    type="button"
                    onclick="alert('Password changed successfully!')"
                    class="bg-primary text-primary-foreground px-6 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    Change Password
                </button>
            </div>

            <hr class="border-border my-6">

            <!-- Admin Preferences -->
            <div class="space-y-4">
                <h3 class="text-lg font-semibold text-foreground">System Preferences</h3>
                <p class="text-sm text-muted-foreground">Configure system notifications and alerts</p>
                
                <div class="space-y-3">
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox" 
                            checked
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Email alerts for flagged content</span>
                    </label>
                    
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox" 
                            checked
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Daily system activity reports</span>
                    </label>
                    
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox"
                            checked
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Security alerts and warnings</span>
                    </label>

                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox"
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Weekly analytics digest</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- System Overview Statistics -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <h3 class="text-lg font-semibold text-foreground mb-4">System Overview</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">1,234</p>
                    <p class="text-sm text-muted-foreground">Total Users</p>
                </div>
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">856</p>
                    <p class="text-sm text-muted-foreground">Active Sessions</p>
                </div>
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">12</p>
                    <p class="text-sm text-muted-foreground">Flagged Posts</p>
                </div>
            </div>
        </div>

        <!-- Access Permissions (Display Only) -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <h3 class="text-lg font-semibold text-foreground mb-4">Access Permissions</h3>
            <div class="space-y-2 text-sm">
                <div class="flex items-center justify-between p-3 bg-secondary/20 rounded-md">
                    <span class="text-foreground">User Management</span>
                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">Full Access</span>
                </div>
                <div class="flex items-center justify-between p-3 bg-secondary/20 rounded-md">
                    <span class="text-foreground">Content Moderation</span>
                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">Full Access</span>
                </div>
                <div class="flex items-center justify-between p-3 bg-secondary/20 rounded-md">
                    <span class="text-foreground">System Configuration</span>
                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">Full Access</span>
                </div>
                <div class="flex items-center justify-between p-3 bg-secondary/20 rounded-md">
                    <span class="text-foreground">Analytics & Reports</span>
                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">Full Access</span>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />