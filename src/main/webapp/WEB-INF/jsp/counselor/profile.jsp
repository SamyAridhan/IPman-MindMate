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
                        value="Dr. Sarah Johnson"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                    />
                </div>
                
                <div class="space-y-2">
                    <label for="email" class="block text-sm font-medium text-foreground">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        value="dr.sarah.johnson@example.com"
                        disabled
                        class="w-full px-3 py-2 border border-input rounded-md bg-muted text-muted-foreground cursor-not-allowed"
                    />
                </div>

                <div class="space-y-2">
                    <label for="specialization" class="block text-sm font-medium text-foreground">Specialization</label>
                    <input 
                        type="text" 
                        id="specialization" 
                        value="Mental Health Counseling"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                    />
                </div>

                <div class="space-y-2">
                    <label for="license" class="block text-sm font-medium text-foreground">License Number</label>
                    <input 
                        type="text" 
                        id="license" 
                        value="MHC-2024-12345"
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

            <!-- Professional Settings -->
            <div class="space-y-4">
                <h3 class="text-lg font-semibold text-foreground">Professional Settings</h3>
                <p class="text-sm text-muted-foreground">Configure your availability and appointment preferences</p>
                
                <div class="space-y-3">
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox" 
                            checked
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Accept new appointment requests</span>
                    </label>
                    
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox" 
                            checked
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Email notifications for new bookings</span>
                    </label>
                    
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input 
                            type="checkbox"
                            class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-2 focus:ring-primary"
                        />
                        <span class="text-sm text-foreground">Show profile in counselor directory</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Professional Statistics -->
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <h3 class="text-lg font-semibold text-foreground mb-4">Professional Statistics</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">156</p>
                    <p class="text-sm text-muted-foreground">Total Sessions</p>
                </div>
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">42</p>
                    <p class="text-sm text-muted-foreground">Active Clients</p>
                </div>
                <div class="text-center p-4 bg-secondary/30 rounded-lg">
                    <p class="text-2xl font-bold text-primary">4.8</p>
                    <p class="text-sm text-muted-foreground">Average Rating</p>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />