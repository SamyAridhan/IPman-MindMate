<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">AI Support Companion</h1>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border flex flex-col h-[calc(100vh-250px)] min-h-[500px]">
        
        <div class="flex-1 border border-border rounded-md p-4 mb-4 bg-secondary/10 overflow-y-auto scroll-smooth">
            <div class="space-y-4">
                
                <div class="flex items-start gap-3">
                    <div class="p-2 bg-secondary rounded-full shrink-0 border border-border">
                        <i data-lucide="bot" class="h-5 w-5 text-primary"></i>
                    </div>
                    
                    <div class="bg-card border border-border p-3 rounded-2xl rounded-tl-none shadow-sm max-w-[85%] sm:max-w-[75%]">
                        <p class="text-foreground text-sm leading-relaxed">
                            Hello! I'm your MindMate assistant. I'm here to listen and help answer your mental health questions. How can I support you today?
                        </p>
                        <span class="text-[10px] text-muted-foreground mt-1 block">Just now</span>
                    </div>
                </div>

                </div>
        </div>

        <form method="POST" action="/student/chatbot/message" class="flex gap-3">
            <div class="relative flex-1">
                <input type="text" name="message" placeholder="Type your message here..." 
                       class="w-full pl-4 pr-4 py-3 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground shadow-sm"
                       autocomplete="off">
            </div>
            
            <button type="submit" class="bg-primary text-primary-foreground px-6 py-2 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring shadow-sm flex items-center gap-2">
                <span>Send</span>
                <i data-lucide="send" class="h-4 w-4"></i>
            </button>
        </form>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />