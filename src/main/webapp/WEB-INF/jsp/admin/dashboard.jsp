<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>
<div class="mb-8">
    <h2 class="text-2xl font-semibold text-gray-800">Welcome, Administrator!</h2>
    <p class="text-gray-600 mt-2">Manage users, system settings, and platform analytics.</p>
</div>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-xl font-semibold mb-3 text-blue-600">User Management</h3>
        <p class="text-gray-600 mb-4">Manage students, counselors, and admin accounts.</p>
        <button class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
            Manage Users
        </button>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-xl font-semibold mb-3 text-green-600">System Analytics</h3>
        <p class="text-gray-600 mb-4">View platform usage statistics and reports.</p>
        <button class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700">
            View Analytics
        </button>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-xl font-semibold mb-3 text-purple-600">System Settings</h3>
        <p class="text-gray-600 mb-4">Configure platform settings and preferences.</p>
        <button class="bg-purple-600 text-white px-4 py-2 rounded-md hover:bg-purple-700">
            Settings
        </button>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

