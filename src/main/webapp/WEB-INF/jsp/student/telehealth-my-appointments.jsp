<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">My Appointments</h1>
<div class="bg-white p-6 rounded-lg shadow-md">
    <div class="mb-4">
        <a href="/student/telehealth" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 inline-block">
            Book New Appointment
        </a>
    </div>
    <h2 class="text-xl font-semibold mb-4">Upcoming Appointments</h2>
    <div class="space-y-4">
        <div class="border border-gray-200 rounded-md p-4">
            <div class="flex justify-between items-start">
                <div>
                    <h3 class="text-lg font-semibold">Dr. Jane Smith</h3>
                    <p class="text-gray-600">January 15, 2024 at 10:00 AM</p>
                    <p class="text-gray-500 text-sm mt-1">Reason: General consultation</p>
                </div>
                <div class="flex space-x-2">
                    <button class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 text-sm">
                        Join Session
                    </button>
                    <button class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 text-sm">
                        Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>
    <h2 class="text-xl font-semibold mb-4 mt-8">Past Appointments</h2>
    <div class="space-y-4">
        <div class="border border-gray-200 rounded-md p-4 bg-gray-50">
            <h3 class="text-lg font-semibold">Dr. John Doe</h3>
            <p class="text-gray-600">January 1, 2024 at 2:00 PM</p>
            <p class="text-gray-500 text-sm mt-1">Completed</p>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

