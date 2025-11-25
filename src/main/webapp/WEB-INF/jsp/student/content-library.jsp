<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Content Library</h1>
<p class="text-muted-foreground mb-6">Browse articles, videos, and resources to support your mental health journey.</p>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-2 text-foreground">Understanding Anxiety</h3>
        <p class="text-muted-foreground text-sm mb-4">Learn about anxiety and effective coping strategies.</p>
        <a href="/student/library/view" class="text-primary hover:text-primary/80 hover:underline transition-colors duration-300">Read More →</a>
    </div>
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-2 text-foreground">Stress Management Techniques</h3>
        <p class="text-muted-foreground text-sm mb-4">Practical tips for managing daily stress.</p>
        <a href="/student/library/view" class="text-primary hover:text-primary/80 hover:underline transition-colors duration-300">Read More →</a>
    </div>
    <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg transition-all duration-300">
        <h3 class="text-xl font-semibold mb-2 text-foreground">Building Resilience</h3>
        <p class="text-muted-foreground text-sm mb-4">Develop resilience to overcome life's challenges.</p>
        <a href="/student/library/view" class="text-primary hover:text-primary/80 hover:underline transition-colors duration-300">Read More →</a>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

