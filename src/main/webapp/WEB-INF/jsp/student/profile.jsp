<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="max-w-3xl mx-auto space-y-6">
        
        <c:if test="${not empty successMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">${successMessage}</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">${errorMessage}</span>
            </div>
        </c:if>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-foreground mb-1">User Profile</h1>
                <p class="text-sm text-muted-foreground">Manage your account settings and preferences</p>
            </div>

            <form action="${pageContext.request.contextPath}/${role}/profile/update" method="POST" class="space-y-4 mb-6">
                
                <div class="space-y-2">
                    <label for="name" class="block text-sm font-medium text-foreground">Name</label>
                    <input 
                        type="text" 
                        id="name" 
                        name="name" 
                        value="${user.name}"
                        required
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                    />
                </div>
                
                <div class="space-y-2">
                    <label for="email" class="block text-sm font-medium text-foreground">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        value="${user.email}"
                        disabled
                        class="w-full px-3 py-2 border border-input rounded-md bg-muted text-muted-foreground cursor-not-allowed"
                    />
                </div>

                <div class="space-y-2">
                    <label for="role" class="block text-sm font-medium text-foreground">Role</label>
                    <input 
                        type="text" 
                        id="role" 
                        value="${role}"
                        disabled
                        class="w-full px-3 py-2 border border-input rounded-md bg-muted text-muted-foreground cursor-not-allowed uppercase"
                    />
                </div>

                <button 
                    type="submit"
                    class="bg-primary text-primary-foreground px-6 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    Update Profile
                </button>
            </form>

            <hr class="border-border my-6">

            <form action="${pageContext.request.contextPath}/${role}/profile/change-password" method="POST" class="space-y-4 mb-6" onsubmit="return validatePassword()">
                <h3 class="text-lg font-semibold text-foreground">Change Password</h3>
                
                <div class="space-y-2">
                    <label for="current-password" class="block text-sm font-medium text-foreground">Current Password</label>
                    <input 
                        type="password" 
                        id="current-password" 
                        name="currentPassword"
                        required
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                    />
                </div>

                <div class="space-y-2">
                    <label for="new-password" class="block text-sm font-medium text-foreground">New Password</label>
                    <input 
                        type="password" 
                        id="new-password" 
                        name="newPassword"
                        placeholder="Min 6 characters"
                        required
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                    />
                </div>
                
                <div class="space-y-2">
                    <label for="confirm-password" class="block text-sm font-medium text-foreground">Confirm New Password</label>
                    <input 
                        type="password" 
                        id="confirm-password" 
                        name="confirmPassword"
                        required
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                    />
                </div>
                
                <button 
                    type="submit"
                    class="bg-primary text-primary-foreground px-6 py-2 rounded-md hover:opacity-90 transition-opacity font-medium">
                    Change Password
                </button>
            </form>
        </div>
    </div>
</div>

<script>
function validatePassword() {
    var newPass = document.getElementById("new-password").value;
    var confirmPass = document.getElementById("confirm-password").value;
    
    if (newPass !== confirmPass) {
        alert("New passwords do not match!");
        return false;
    }
    return true;
}
</script>

<jsp:include page="../common/footer.jsp" />