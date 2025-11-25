<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Student Dashboard</h1>
<div class="mb-8">
    <h2 class="text-2xl font-semibold text-gray-800">Welcome Back!</h2>
    <p class="text-gray-600 mt-2">Here's what's happening with your mental health journey today.</p>
</div>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <!-- Take Assessment Card -->
    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
        <h3 class="text-xl font-semibold mb-3 text-blue-600">Take Assessment</h3>
        <p class="text-gray-600 mb-4">Complete a mental health assessment to track your progress.</p>
        <a href="/student/assessment" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 inline-block">
            Start Assessment
        </a>
    </div>

    <!-- Next Appointment Card -->
    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
        <h3 class="text-xl font-semibold mb-3 text-green-600">Next Appointment</h3>
        <p class="text-gray-600 mb-4">Your next telehealth session is scheduled.</p>
        <a href="/student/telehealth/my-appointments" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 inline-block">
            View Appointments
        </a>
    </div>

    <!-- Latest Article Card -->
    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
        <h3 class="text-xl font-semibold mb-3 text-purple-600">Latest Article</h3>
        <p class="text-gray-600 mb-4">Read our latest content on mental wellness.</p>
        <a href="/student/library" class="bg-purple-600 text-white px-4 py-2 rounded-md hover:bg-purple-700 inline-block">
            Browse Library
        </a>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

