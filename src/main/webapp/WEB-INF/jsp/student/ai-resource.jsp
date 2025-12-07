<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
<div class="space-y-6 fade-in">
    
    <div>
        <a href="${pageContext.request.contextPath}/student/dashboard" 
           class="inline-flex items-center gap-2 transition-colors text-sm font-medium"
           style="color: hsl(var(--muted-foreground));">
            <i data-lucide="arrow-left" class="h-4 w-4"></i>
            Back to dashboard
        </a>
    </div>

    <div class="bg-card shadow-sm sm:rounded-lg p-8"
         style="background: hsl(var(--card)); border: 1px solid hsl(var(--border)); border-radius: var(--radius);">
        
        <div class="border-b pb-6 mb-6" style="border-color: hsl(var(--border));">
            <div class="flex items-center gap-2 mb-3">
                
                <span class="badge ${resource.typeBadgeClass}">
                    ${resource.typeText}
                </span>
                
                <span class="text-xs font-medium" style="color: hsl(var(--muted-foreground));">• 5 min read</span>
            </div>
            
            <h1 class="text-3xl font-bold mb-3" style="color: hsl(var(--foreground));">
                ${resource.title}
            </h1>
            
            <div class="flex items-center gap-2 text-sm" style="color: hsl(var(--muted-foreground));">
                <div class="p-1 rounded-full" style="background: hsl(var(--secondary));">
                    <i data-lucide="user" class="h-3 w-3" style="color: hsl(var(--primary));"></i>
                </div>
                <span>By MindMate AI</span>
            </div>
        </div>

        <div class="prose max-w-none leading-relaxed text-lg">
            <c:out value="${resource.embedHtml}" escapeXml="false" />
        </div>

    </div>
</div>
</div>
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />