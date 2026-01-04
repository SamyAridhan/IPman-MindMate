<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<style>
    /* Prevent text from overflowing the container */
    .prose-content {
        max-width: 100%;
        overflow-wrap: anywhere; 
        word-break: break-word;
    }
</style>

<div class="container mx-auto px-4 py-6">
    <div class="space-y-6">
        <%-- TOP BAR: BACK BUTTON AND ACTIONS --%>
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-muted/30 p-4 rounded-lg border border-border">
            <a href="${pageContext.request.contextPath}/admin/forum-moderation" 
               class="text-muted-foreground hover:text-foreground inline-flex items-center gap-2 transition-colors text-sm font-medium">
                <i data-lucide="arrow-left" class="h-4 w-4"></i>
                Back to Moderation Queue
            </a>

            <div class="flex items-center gap-3">
                <span class="text-xs font-bold uppercase tracking-wider text-destructive mr-2 flex items-center gap-1">
                    <i data-lucide="alert-circle" class="h-3 w-3"></i> Flagged Content
                </span>
                
                <%-- ADMIN ACTIONS --%>
                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/approve">
                    <input type="hidden" name="postId" value="${post.id}">
                    <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition-all flex items-center gap-2 text-sm font-medium shadow-sm">
                        <i data-lucide="check" class="h-4 w-4"></i> Approve Post
                    </button>
                </form>

                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/delete">
                    <input type="hidden" name="postId" value="${post.id}">
                    <button type="submit" onclick="return confirm('Permanently delete this post?')" 
                            class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition-all flex items-center gap-2 text-sm font-medium shadow-sm">
                        <i data-lucide="trash-2" class="h-4 w-4"></i> Delete Post
                    </button>
                </form>
            </div>
        </div>

        <%-- MAIN POST CARD (Styles matched to student view: p-6 and text-3xl) --%>
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border overflow-hidden">
            <div class="mb-8 border-b border-border pb-6">
                <div class="flex items-start justify-between mb-4">
                    <div class="min-w-0 flex-1">
                        <h1 class="text-3xl font-bold text-foreground mb-1 break-words">${post.title}</h1>
                        <div class="flex items-center gap-2 text-sm text-muted-foreground">
                            <div class="bg-secondary p-1 rounded-full">
                                <i data-lucide="user" class="h-3 w-3 text-primary"></i>
                            </div>
                            <span>
                                Posted by: 
                                <span class="${post.anonymous ? 'italic text-gray-400' : 'font-medium text-foreground'}">
                                    ${post.anonymous ? 'Anonymous' : post.author}
                                </span> 
                                • <span class="timestamp-el" data-timestamp="${post.timestamp}">${post.timestamp}</span>
                            </span>
                        </div>
                    </div>
                    <span class="px-3 py-1 bg-secondary text-primary text-xs font-semibold rounded-full border border-primary/20">
                        ${post.category}
                    </span>
                </div>
                
                <%-- CONTENT DIV: No extra spaces and matched font size --%>
                <div class="prose prose-slate prose-content max-w-full text-foreground leading-relaxed whitespace-pre-wrap break-words overflow-wrap-anywhere">${fn:trim(post.content)}</div>
            </div>

            <%-- REPLIES SECTION --%>
            <div class="space-y-6">
                <h3 class="text-xl font-semibold text-foreground flex items-center gap-2">
                    <i data-lucide="message-square" class="h-5 w-5 text-primary"></i>
                    Replies (${post.repliesList.size()})
                </h3>
                
                <div class="flex flex-col gap-6 opacity-75">
                    <c:forEach var="reply" items="${post.repliesList}">
                        <c:if test="${empty reply.parentReply}">
                            <template:displayReply reply="${reply}" post="${post}" />
                        </c:if>
                    </c:forEach>

                    <c:if test="${empty post.repliesList}">
                        <div class="text-center py-10 bg-gray-50/50 border border-dashed rounded-lg w-full">
                            <p class="text-gray-400 italic">No replies to this post.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function timeAgo(dateString) {
        const now = new Date();
        const past = new Date(dateString);
        const seconds = Math.floor((now - past) / 1000);
        const intervals = [
            { label: 'year', seconds: 31536000 }, { label: 'month', seconds: 2592000 },
            { label: 'week', seconds: 604800 }, { label: 'day', seconds: 86400 },
            { label: 'hr', seconds: 3600 }, { label: 'min', seconds: 60 }, { label: 's', seconds: 1 }
        ];
        for (let i = 0; i < intervals.length; i++) {
            const interval = intervals[i];
            const count = Math.floor(seconds / interval.seconds);
            if (count >= 1) return count + " " + interval.label + (count > 1 ? 's' : '') + " ago";
        }
        return "just now";
    }

    function refreshTimestamps() {
        document.querySelectorAll('.timestamp-el').forEach(el => {
            const rawDate = el.getAttribute('data-timestamp');
            if (rawDate) el.textContent = timeAgo(rawDate);
        });
    }

    window.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) { lucide.createIcons(); }
        refreshTimestamps();
    });
</script>
<jsp:include page="../common/footer.jsp" />