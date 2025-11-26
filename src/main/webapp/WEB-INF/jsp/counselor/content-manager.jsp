<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <h1 class="text-3xl font-bold text-foreground">Content Manager</h1>
        <a href="/counselor/content/new" class="bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-flex items-center gap-2 font-medium shadow-sm">
            <i data-lucide="plus" class="h-4 w-4"></i>
            Create New Content
        </a>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <h2 class="text-xl font-semibold mb-4 text-foreground">Published Content</h2>
        
        <div class="space-y-4">
            <div class="border-b border-border pb-4 last:border-0 last:pb-0">
                <div class="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
                    <div>
                        <h3 class="text-lg font-semibold text-foreground">Understanding Anxiety</h3>
                        <p class="text-muted-foreground text-sm mt-1">Published on: January 1, 2024</p>
                    </div>
                    
                    <div class="flex space-x-2">
                        <button class="bg-primary text-primary-foreground px-3 py-1.5 rounded-md hover:opacity-90 transition-opacity text-sm font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                            Edit
                        </button>
                        
                        <button class="bg-destructive text-destructive-foreground px-3 py-1.5 rounded-md hover:opacity-90 transition-opacity text-sm font-medium focus:outline-none focus:ring-2 focus:ring-destructive">
                            Delete
                        </button>
                    </div>
                </div>
            </div>
            
            </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />