<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <div>
        <h1 class="text-3xl font-bold text-foreground">Community Forum</h1>
        <p class="text-muted-foreground mt-2">Join discussions, share experiences, and find support from the community.</p>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-semibold text-foreground">Discussion Threads</h2>
            <button class="text-sm bg-secondary text-primary px-3 py-1.5 rounded-md font-medium hover:bg-secondary/80 transition-colors">
                New Post
            </button>
        </div>
        
        <ul class="space-y-4">
            <c:forEach var="thread" items="${forumThreads}">
                <li class="border-b border-border pb-4 last:border-0 last:pb-0">
                    <div class="flex items-start gap-4">
                        <div class="p-2 bg-secondary rounded-full mt-1 shrink-0">
                            <i data-lucide="message-circle" class="h-5 w-5 text-primary"></i>
                        </div>
                        
                        <div class="flex-1">
                            <a href="/student/forum/thread" class="text-lg font-medium text-foreground hover:text-primary transition-colors block">
                                ${thread}
                            </a>
                            <p class="text-muted-foreground text-sm mt-1">Click to view replies and join the discussion.</p>
                        </div>
                        
                        <div class="hidden sm:block mt-2">
                             <i data-lucide="chevron-right" class="h-5 w-5 text-muted-foreground/50"></i>
                        </div>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />