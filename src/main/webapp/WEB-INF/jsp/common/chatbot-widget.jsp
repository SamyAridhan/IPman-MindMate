<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    JSP Chatbot Widget Fragment - Embedded on every page (via footer.jsp).
    
    CRITICAL: This fragment contains only HTML structure. 
    The logic (open/close, sending messages, receiving API responses) 
    MUST be handled by client-side JavaScript (in footer.jsp).
--%>

<div id="ai-chat-widget" class="z-50">
    
    <%-- 1. Floating Chat Button --%>
    <button
        id="chat-open-button"
        onclick="toggleChatWindow(true)"
        class="fixed bottom-20 right-6 z-50 h-14 w-14 rounded-full shadow-lg bg-primary text-primary-foreground hover:bg-primary/90 transition-all duration-300"
        aria-label="Open AI Chat"
    >
        <%-- Icon Conversion: MessageCircle --%>
        <i data-lucide="message-circle" class="h-6 w-6 mx-auto"></i>
    </button>

    <%-- 2. Chat Window --%>
    <div
        id="chat-window"
        class="fixed bottom-20 right-6 z-50 w-96 h-[500px] shadow-2xl flex flex-col bg-white rounded-lg border border-gray-200 hidden"
    >
        
        <%-- Header --%>
        <div class="p-4 border-b bg-gradient-to-r from-primary/5 to-primary/10">
            <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                    <%-- Icon Conversion: MessageCircle --%>
                    <i data-lucide="message-circle" class="h-5 w-5 text-primary"></i>
                    <h3 class="font-semibold text-lg">AI Support Assistant</h3>
                </div>
                <button
                    onclick="toggleChatWindow(false)"
                    class="p-1 rounded-md text-gray-500 hover:bg-gray-100"
                    aria-label="Close Chat"
                >
                    <%-- Icon Conversion: X (Close) --%>
                    <i data-lucide="x" class="h-4 w-4"></i>
                </button>
            </div>
            
            <%-- Appointment CTA (Navigation Conversion: Use <a> tag) --%>
            <div class="flex items-center justify-between text-xs text-muted-foreground bg-background/50 rounded-md p-2">
                <span class="flex items-center gap-1">
                    <%-- Icon Conversion: Calendar --%>
                    <i data-lucide="calendar" class="h-3 w-3"></i>
                    Need someone to talk to?
                </span>
                
                <a 
                    href="/student/telehealth"
                    class="h-auto p-0 text-xs text-primary hover:underline text-decoration-none font-medium" 
                >
                    Book Appointment
                </a>
            </div>
        </div>

        <%-- Messages Container (Dynamic Content) --%>
        <div id="messages-container" class="flex-1 overflow-y-auto p-4 space-y-4">
            <%-- 
                CRITICAL CHANGE: REMOVED THE STATIC INITIAL MESSAGE BLOCK HERE.
                The content is now generated entirely by JavaScript's renderMessages() 
                which reads the 'currentMessages' array.
            --%>
            
            <%-- Placeholder for dynamic messages --%>
            <div id="loading-indicator" class="hidden">
                <%-- Dots from the React component --%>
                <div class="flex justify-start">
                    <div class="bg-muted rounded-lg px-4 py-2">
                        <div class="flex gap-1">
                            <div class="w-2 h-2 rounded-full bg-foreground/40 animate-bounce" style="animation-delay: 0ms"></div>
                            <div class="w-2 h-2 rounded-full bg-foreground/40 animate-bounce" style="animation-delay: 150ms"></div>
                            <div class="w-2 h-2 rounded-full bg-foreground/40 animate-bounce" style="animation-delay: 300ms"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="messages-end-ref"></div>
        </div>

        <%-- Input --%>
        <div class="p-4 border-t bg-white">
            <div class="flex gap-2">
                <input
                    id="chat-input"
                    type="text"
                    placeholder="Type your message..."
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                />
                <button
                    id="chat-send-button"
                    onclick="handleSendMessage()"
                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors bg-primary text-primary-foreground hover:bg-primary/90 h-10 w-10 disabled:opacity-50 disabled:pointer-events-none"
                    aria-label="Send Message"
                >
                    <%-- Icon Conversion: Send --%>
                    <i data-lucide="send" class="h-4 w-4 mx-auto"></i>
                </button>
            </div>
        </div>
    </div>
</div>