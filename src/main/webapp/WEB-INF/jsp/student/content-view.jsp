<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
    <div>
        <a href="/student/library" class="text-muted-foreground hover:text-foreground inline-flex items-center gap-2 transition-colors text-sm font-medium">
            <i data-lucide="arrow-left" class="h-4 w-4"></i>
            Back to Library
        </a>
    </div>

    <div class="bg-card shadow-sm border border-border sm:rounded-lg p-8">
        
        <div class="border-b border-border pb-6 mb-6">
            <div class="flex items-center gap-2 mb-3">
                 <span class="px-2.5 py-0.5 bg-secondary text-primary text-xs font-semibold rounded-full border border-primary/20">Article</span>
                 <span class="text-muted-foreground text-xs font-medium">• 5 min read</span>
            </div>
            <h1 class="text-3xl font-bold text-foreground mb-3">Understanding Anxiety</h1>
            <div class="flex items-center gap-2 text-sm text-muted-foreground">
                <div class="bg-secondary p-1 rounded-full">
                    <i data-lucide="user" class="h-3 w-3 text-primary"></i>
                </div>
                <span>By Dr. Smith</span>
            </div>
        </div>

        <div class="prose max-w-none text-muted-foreground leading-relaxed">
            <p class="mb-6 text-foreground text-lg">[Placeholder Content] Anxiety is a normal reaction to stress...</p>
            
            <div class="bg-secondary/30 border border-border p-4 rounded-md flex items-start gap-3">
                <i data-lucide="info" class="h-5 w-5 text-primary shrink-0 mt-0.5"></i>
                <p class="text-sm italic text-foreground">(This is a demo article view. In the real app, this content would be pulled from the database based on the ID.)</p>
            </div>
        </div>
        
        <div class="mt-8 pt-6 border-t border-border">
            <a href="/student/library" class="text-primary hover:text-primary/80 font-medium inline-flex items-center gap-2 transition-colors">
                <i data-lucide="arrow-left" class="h-4 w-4"></i>
                Back to Library
            </a>
        </div>
    </div>
</div>
</div>
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />