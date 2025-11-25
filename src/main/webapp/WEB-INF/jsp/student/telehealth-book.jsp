<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Book Telehealth Appointment</h1>
<div class="bg-white p-6 rounded-lg shadow-md max-w-2xl">
    <form method="POST" action="/student/telehealth/book" class="space-y-4">
        <div>
            <label for="counselor" class="block text-sm font-medium text-gray-700 mb-1">Select Counselor</label>
            <select id="counselor" name="counselor" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="1">Dr. Jane Smith - Licensed Therapist</option>
                <option value="2">Dr. John Doe - Clinical Psychologist</option>
            </select>
        </div>
        <div>
            <label for="date" class="block text-sm font-medium text-gray-700 mb-1">Select Date</label>
            <input type="date" id="date" name="date" 
                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                   required>
        </div>
        <div>
            <label for="time" class="block text-sm font-medium text-gray-700 mb-1">Select Time</label>
            <select id="time" name="time" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="09:00">9:00 AM</option>
                <option value="10:00">10:00 AM</option>
                <option value="11:00">11:00 AM</option>
                <option value="14:00">2:00 PM</option>
                <option value="15:00">3:00 PM</option>
            </select>
        </div>
        <div>
            <label for="reason" class="block text-sm font-medium text-gray-700 mb-1">Reason for Appointment</label>
            <textarea id="reason" name="reason" rows="4" 
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                      placeholder="Briefly describe the reason for your appointment..."></textarea>
        </div>
        <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700">
            Book Appointment
        </button>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />

