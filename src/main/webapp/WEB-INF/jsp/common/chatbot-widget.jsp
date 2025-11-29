<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
    JSP Chatbot Widget Fragment - STUDENT ONLY
    Embedded on every page (via footer.jsp), but only displays for students.
--%>

<!-- Only render chatbot for students -->
<c:if test="${role == 'student'}">
    <div id="ai-chat-widget" class="z-50">
        
        <%-- 1. Floating Chat Button --%>
        <button
            id="chat-open-button"
            onclick="toggleChatWindow(true)"
            class="fixed bottom-6 right-6 z-50 h-16 w-16 rounded-full shadow-xl bg-primary text-primary-foreground hover:scale-110 transition-all duration-300 group"
            aria-label="Open AI Chat"
        >
            <%-- Icon with subtle animation --%>
            <i data-lucide="message-circle" class="h-7 w-7 mx-auto group-hover:scale-110 transition-transform"></i>
            
            <%-- Notification badge (optional - can be dynamic later) --%>
            <span class="absolute -top-1 -right-1 w-5 h-5 bg-green-500 rounded-full border-2 border-white animate-pulse"></span>
        </button>

        <%-- 2. Chat Window --%>
        <div
            id="chat-window"
            class="fixed bottom-6 right-6 z-50 w-[380px] h-[600px] shadow-2xl flex flex-col bg-card rounded-2xl border border-border hidden"
        >
            
            <%-- Header --%>
            <div class="p-4 border-b border-border bg-gradient-to-r from-primary/10 to-primary/5 rounded-t-2xl">
                <div class="flex items-center justify-between mb-3">
                    <div class="flex items-center gap-3">
                        <%-- Bot Avatar --%>
                        <div class="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center border-2 border-primary/30">
                            <i data-lucide="bot" class="h-5 w-5 text-primary"></i>
                        </div>
                        <div>
                            <h3 class="font-semibold text-base text-foreground">AI Support Assistant</h3>
                            <p class="text-xs text-muted-foreground flex items-center gap-1">
                                <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
                                Online
                            </p>
                        </div>
                    </div>
                    <button
                        onclick="toggleChatWindow(false)"
                        class="p-1.5 rounded-lg text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors"
                        aria-label="Close Chat"
                    >
                        <i data-lucide="x" class="h-5 w-5"></i>
                    </button>
                </div>
                
                <%-- Appointment CTA --%>
                <div class="flex items-center justify-between text-xs bg-card rounded-lg p-2.5 shadow-sm border border-border/50">
                    <span class="flex items-center gap-1.5 text-muted-foreground">
                        <i data-lucide="calendar" class="h-3.5 w-3.5 text-primary"></i>
                        Need professional help?
                    </span>
                    <a 
                        href="/student/telehealth"
                        class="text-primary hover:text-primary/80 font-semibold transition-colors" 
                    >
                        Book Now →
                    </a>
                </div>
            </div>

            <%-- Messages Container --%>
            <div id="messages-container" class="flex-1 overflow-y-auto p-4 space-y-3 bg-background/50">
                <%-- Dynamic messages will be rendered here --%>
            </div>

            <%-- Typing Indicator --%>
            <div id="typing-indicator" class="px-4 pb-2 hidden">
                <div class="flex items-start gap-2">
                    <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30 shrink-0">
                        <i data-lucide="bot" class="h-4 w-4 text-primary"></i>
                    </div>
                    <div class="bg-secondary rounded-2xl rounded-tl-sm px-4 py-3 shadow-sm">
                        <div class="flex gap-1">
                            <div class="w-2 h-2 rounded-full bg-primary/60 animate-bounce" style="animation-delay: 0ms"></div>
                            <div class="w-2 h-2 rounded-full bg-primary/60 animate-bounce" style="animation-delay: 150ms"></div>
                            <div class="w-2 h-2 rounded-full bg-primary/60 animate-bounce" style="animation-delay: 300ms"></div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Input Area --%>
            <div class="p-4 border-t border-border bg-card rounded-b-2xl">
                <form onsubmit="handleSendMessage(); return false;" class="flex gap-2">
                    <input
                        id="chat-input"
                        type="text"
                        placeholder="Type your message..."
                        class="flex-1 h-11 rounded-xl border border-input bg-background px-4 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all"
                        autocomplete="off"
                    />
                    <button
                        id="chat-send-button"
                        type="submit"
                        class="h-11 w-11 rounded-xl bg-primary text-primary-foreground hover:bg-primary/90 transition-all flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed shadow-sm hover:shadow-md"
                        aria-label="Send Message"
                    >
                        <i data-lucide="send" class="h-4 w-4"></i>
                    </button>
                </form>
                <p class="text-[10px] text-muted-foreground text-center mt-2">
                    AI can make mistakes. Consider checking important information.
                </p>
            </div>
        </div>
    </div>
</c:if>