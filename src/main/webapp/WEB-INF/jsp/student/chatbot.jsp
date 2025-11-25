<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Chatbot</h1>
<div class="bg-white p-6 rounded-lg shadow-md">
    <div class="h-96 border border-gray-300 rounded-md p-4 mb-4 bg-gray-50">
        <div class="space-y-4">
            <div class="bg-blue-100 p-3 rounded-md">
                <p class="text-gray-700">Hello! I'm here to help you with your mental health questions. How can I assist you today?</p>
            </div>
        </div>
    </div>
    <form method="POST" action="/student/chatbot/message" class="flex space-x-2">
        <input type="text" name="message" placeholder="Type your message..." 
               class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
        <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700">
            Send
        </button>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />

