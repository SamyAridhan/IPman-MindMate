<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Content Manager</h1>
<div class="mb-6">
    <a href="/counselor/content/new" class="bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90 inline-block transition-all duration-300">
        Create New Content
    </a>
</div>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <h2 class="text-xl font-semibold mb-4 text-foreground">Published Content</h2>
    <div class="space-y-4">
        <div class="border-b border-border pb-4">
            <h3 class="text-lg font-semibold text-foreground">Understanding Anxiety</h3>
            <p class="text-muted-foreground text-sm mb-2">Published on: January 1, 2024</p>
            <div class="flex space-x-2">
                <button class="bg-primary text-primary-foreground px-3 py-1 rounded-lg hover:bg-primary/90 text-sm transition-all duration-300">
                    Edit
                </button>
                <button class="bg-destructive text-destructive-foreground px-3 py-1 rounded-lg hover:bg-destructive/90 text-sm transition-all duration-300">
                    Delete
                </button>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

