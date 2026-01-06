<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8 max-w-4xl">
<div class="space-y-6">
<div>
<a href="${pageContext.request.contextPath}/student/library" class="text-muted-foreground hover:text-primary inline-flex items-center gap-2 transition-colors text-sm font-bold group">
Back
</a>
</div>

    <div class="bg-card shadow-2xl border border-border rounded-3xl overflow-hidden flex flex-col">
        <div class="p-8 md:p-10 border-b border-border bg-gradient-to-br from-card to-secondary/30">
            <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
                <div class="flex items-center gap-3">
                    <span class="px-3 py-1 bg-primary/10 text-primary text-[10px] font-black rounded-full border border-primary/20 uppercase tracking-widest">
                        ${content.contentType}
                    </span>
                    <c:if test="${isCompleted}">
                        <span class="px-3 py-1 bg-green-500/10 text-green-600 text-[10px] font-black rounded-full border border-green-500/20 uppercase tracking-widest flex items-center gap-1">
                            <i data-lucide="check" class="h-3 w-3"></i> Completed
                        </span>
                    </c:if>
                </div>
                
                <!-- Reward Display -->
                <div class="flex items-center gap-2 px-4 py-2 bg-background/50 backdrop-blur-md rounded-2xl border border-border shadow-inner">
                    <i data-lucide="sparkles" class="h-4 w-4 text-yellow-500"></i>
                    <span class="text-xs font-bold text-foreground">${content.pointsValue} Points</span>
                </div>
            </div>

            <h1 class="text-4xl md:text-5xl font-black text-foreground mb-6 leading-tight">${content.title}</h1>
            
            <div class="flex items-center gap-4">
                <div class="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center text-primary border border-primary/20 shadow-sm">
                    <i data-lucide="user" class="h-6 w-6"></i>
                </div>
                <div>
                    <p class="text-foreground font-bold leading-none">${not empty content.author ? content.author.name : 'MindMate Counselor'}</p>
                    <p class="text-[10px] uppercase tracking-widest mt-1.5 text-muted-foreground font-semibold">Specialist Counselor</p>
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="p-8 md:p-10 bg-card">
            <c:choose>
                <c:when test="${content.contentType == 'Video'}">
                    <!-- Video Player -->
                    <div class="aspect-video w-full rounded-2xl overflow-hidden bg-black mb-8 shadow-2xl ring-1 ring-border">
                        <iframe 
                            src="${fn:replace(content.contentBody, 'watch?v=', 'embed/')}" 
                            class="w-full h-full" 
                            frameborder="0" 
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                            allowfullscreen>
                        </iframe>
                    </div>
                    <div class="prose max-w-none">
                        <h3 class="text-foreground font-bold text-xl mb-4">About this Video</h3>
                        <p class="text-muted-foreground leading-relaxed">${content.description}</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Article Body -->
                    <div class="prose max-w-none text-muted-foreground leading-relaxed text-lg content-body">
                        <c:out value="${content.contentBody}" escapeXml="false" />
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer Action Area -->
        <div class="p-8 md:p-10 bg-secondary/20 border-t border-border flex flex-col items-center text-center gap-6">
            <c:choose>
                <c:when test="${!isCompleted}">
                    <div class="max-w-md">
                        <h3 class="text-2xl font-black text-foreground mb-3">Finished the material?</h3>
                        <p class="text-muted-foreground text-sm mb-8 leading-relaxed">
                            Complete this module to earn your <strong>${content.pointsValue} points</strong> and maintain your daily learning streak.
                        </p>
                        
                        <form action="${pageContext.request.contextPath}/student/content/complete" method="POST">
                            <input type="hidden" name="contentId" value="${content.id}" />
                            <button type="submit" class="w-full sm:w-auto inline-flex items-center justify-center gap-3 px-10 py-5 bg-primary text-primary-foreground rounded-2xl font-black text-xl shadow-xl hover:shadow-primary/20 hover:scale-[1.02] active:scale-[0.98] transition-all group">
                                <i data-lucide="check-circle-2" class="h-6 w-6 group-hover:rotate-12 transition-transform"></i>
                                Mark as Complete
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="flex flex-col items-center animate-in fade-in zoom-in duration-500">
                        <div class="h-20 w-20 bg-green-500 text-white rounded-3xl flex items-center justify-center shadow-lg shadow-green-500/20 mb-4">
                            <i data-lucide="party-popper" class="h-10 w-10"></i>
                        </div>
                        <h3 class="text-2xl font-black text-foreground mb-1">Excellent Work!</h3>
                        <p class="text-green-600 font-bold text-sm uppercase tracking-tighter">You have successfully mastered this module</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="w-full pt-4">
                <a href="${pageContext.request.contextPath}/student/library" 
                   class="inline-flex items-center gap-2 px-6 py-3 rounded-xl border border-border bg-background text-foreground font-bold text-sm hover:bg-secondary transition-all hover:px-8">
                    Return to Library
                </a>
            </div>
        </div>
    </div>
</div>


</div>

<jsp:include page="chatbot-widget.jsp" />

<script>
document.addEventListener('DOMContentLoaded', () => {
if (typeof lucide !== 'undefined') {
lucide.createIcons();
}
});
</script>

<style>
.content-body h1, .content-body h2, .content-body h3 {
color: hsl(var(--foreground));
font-weight: 900;
margin-top: 2rem;
margin-bottom: 1.25rem;
}
.content-body p { margin-bottom: 1.5rem; line-height: 1.8; }
.content-body ul { list-style-type: disc; margin-left: 1.5rem; margin-bottom: 1.5rem; }
</style>

<jsp:include page="../common/footer.jsp" />