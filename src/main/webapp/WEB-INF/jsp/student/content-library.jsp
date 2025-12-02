<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
    <div>
        <h1 class="text-3xl font-bold text-foreground">Content Library</h1>
        <p class="text-muted-foreground mt-2">Browse articles, videos, and resources to support your mental health journey.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
            <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="brain-circuit" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Understanding Anxiety</h3>
                <p class="text-muted-foreground text-sm">Learn about anxiety and effective coping strategies.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
             <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="leaf" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Stress Management Techniques</h3>
                <p class="text-muted-foreground text-sm">Practical tips for managing daily stress.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full">
             <div class="mb-4">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="shield-check" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Building Resilience</h3>
                <p class="text-muted-foreground text-sm">Develop resilience to overcome life's challenges.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>
    </div>
</div>
</div>
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />