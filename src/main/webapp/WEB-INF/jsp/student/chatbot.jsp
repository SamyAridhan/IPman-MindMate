<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Chatbot</h1>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <div class="h-96 border border-border rounded-lg p-4 mb-4 bg-muted">
        <div class="space-y-4">
            <div class="bg-primary/10 p-3 rounded-lg border border-primary/20">
                <p class="text-foreground">Hello! I'm here to help you with your mental health questions. How can I assist you today?</p>
            </div>
        </div>
    </div>
    <form method="POST" action="/student/chatbot/message" class="flex space-x-2">
        <input type="text" name="message" placeholder="Type your message..." 
               class="flex-1 px-4 py-2 border border-input bg-background rounded-lg focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 placeholder:text-muted-foreground">
        <button type="submit" class="bg-primary text-primary-foreground px-6 py-2 rounded-lg hover:bg-primary/90 transition-all duration-300">
            Send
        </button>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />

