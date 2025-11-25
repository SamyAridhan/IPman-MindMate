<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Counselor Dashboard</h1>
<div class="mb-8">
    <h2 class="text-2xl font-semibold text-gray-800">Welcome, Counselor!</h2>
    <p class="text-gray-600 mt-2">Manage your schedule and content from here.</p>
</div>

<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-xl font-semibold mb-3 text-blue-600">Today's Schedule</h3>
        <p class="text-gray-600 mb-4">View and manage your appointments for today.</p>
        <a href="/counselor/schedule" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 inline-block">
            View Schedule
        </a>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-xl font-semibold mb-3 text-green-600">Content Manager</h3>
        <p class="text-gray-600 mb-4">Create and manage educational content for students.</p>
        <a href="/counselor/content" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 inline-block">
            Manage Content
        </a>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

