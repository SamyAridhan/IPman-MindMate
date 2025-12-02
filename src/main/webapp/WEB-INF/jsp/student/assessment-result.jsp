<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">Assessment Result</h1>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <div class="flex items-center gap-3 mb-4">
            <div class="p-2 bg-secondary rounded-full">
                <i data-lucide="activity" class="h-5 w-5 text-primary"></i>
            </div>
            <h2 class="text-xl font-semibold text-foreground">Your Assessment Results</h2>
        </div>
        
        <p class="text-muted-foreground mb-6">Based on your responses, here are your results and recommendations.</p>
        
        <div class="bg-secondary/50 border border-border/50 p-6 rounded-md flex flex-col items-center justify-center text-center space-y-3 min-h-[150px]">
            <i data-lucide="clipboard-check" class="h-8 w-8 text-muted-foreground/50"></i>
            <p class="text-foreground font-medium">Results will be displayed here after completing an assessment.</p>
        </div>
    </div>
</div>
</div>
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />