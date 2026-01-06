<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<style>
    /* Prevents long URLs or unbroken strings (like "aaaaa...") from breaking the layout */
    .content-break {
        overflow-wrap: anywhere;
        word-break: break-word;
        display: block;
    }
</style>

<div class="container mx-auto px-4 py-6">
    <div class="space-y-6">
        <div>
            <a href="${pageContext.request.contextPath}/student/forum" 
               class="text-muted-foreground hover:text-foreground inline-flex items-center gap-2 transition-colors text-sm font-medium mb-4">
                <i data-lucide="arrow-left" class="h-4 w-4"></i>
                Back to Forum
            </a>
        </div>

        <%-- MAIN POST CARD --%>
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
            <div class="mb-8 border-b border-border pb-6">
                <div class="flex flex-col sm:flex-row items-start justify-between gap-4 mb-4">
                    <div class="min-w-0 flex-1">
                        <h1 class="text-3xl font-bold text-foreground mb-1 content-break">
                            ${post.title}
                        </h1>
                        <div class="flex items-center gap-2 text-sm text-muted-foreground">
                            <div class="bg-secondary p-1 rounded-full">
                                <i data-lucide="user" class="h-3 w-3 text-primary"></i>
                            </div>
                            <span>
                                Posted by: 
                                <span class="${post.anonymous ? 'italic text-gray-400' : ''}">
                                    ${post.anonymous ? 'Anonymous' : post.author}
                                </span> 
                                • <span class="timestamp-el" data-timestamp="${post.timestamp}">${post.timestamp}</span>
                            </span>
                        </div>
                    </div>
                    <span class="px-3 py-1 bg-secondary text-primary text-xs font-semibold rounded-full border border-primary/20 whitespace-nowrap">
                        ${post.category}
                    </span>
                </div>
                
                <div class="text-foreground leading-relaxed text-lg whitespace-pre-wrap content-break">${fn:trim(post.content)}</div>
            </div>

            <%-- REPLIES SECTION --%>
            <div class="space-y-6">
                <h3 class="text-xl font-semibold text-foreground flex items-center gap-2">
                    <i data-lucide="message-square" class="h-5 w-5 text-primary"></i>
                    Replies (${post.repliesList.size()})
                </h3>
                
                <div class="flex flex-col gap-6">
                    <c:forEach var="reply" items="${post.repliesList}">
                        <c:if test="${empty reply.parentReply}">
                            <template:displayReply reply="${reply}" post="${post}" />
                        </c:if>
                    </c:forEach>

                    <c:if test="${empty post.repliesList}">
                        <div class="text-center py-10 bg-gray-50/50 border border-dashed rounded-lg w-full">
                            <p class="text-gray-400 italic">No replies yet. Be the first to respond!</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <%-- MAIN REPLY FORM --%>
            <div class="mt-8 pt-6 border-t border-border">
                <h3 class="text-lg font-semibold mb-4 text-foreground">Add to the Conversation</h3>
                <form method="POST" action="${pageContext.request.contextPath}/student/forum/thread/reply" class="space-y-4">
                    <input type="hidden" name="postId" value="${post.id}">
                    <textarea name="reply" rows="4" required
                              class="w-full px-4 py-3 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary bg-white text-foreground shadow-sm resize-y" 
                              placeholder="Share your thoughts..."></textarea>
                    
                    <div class="flex items-center justify-between">
                        <label class="flex items-center gap-2 cursor-pointer group">
                            <input type="checkbox" name="anonymous" value="true" class="w-4 h-4 rounded border-gray-300 text-primary focus:ring-primary">
                            <span class="text-sm text-muted-foreground group-hover:text-foreground transition-colors">Post anonymously</span>
                        </label>
                        <button type="submit" class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 font-medium shadow-md transition-all active:scale-95">
                            Post Comment
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="chatbot-widget.jsp" /> 

<script>
    function timeAgo(dateString) {
        const now = new Date();
        const past = new Date(dateString);
        const seconds = Math.floor((now - past) / 1000);

        const intervals = [
            { label: 'year', seconds: 31536000 },
            { label: 'month', seconds: 2592000 },
            { label: 'week', seconds: 604800 },
            { label: 'day', seconds: 86400 },
            { label: 'hr', seconds: 3600 },
            { label: 'min', seconds: 60 },
            { label: 's', seconds: 1 }
        ];

        for (let i = 0; i < intervals.length; i++) {
            const interval = intervals[i];
            const count = Math.floor(seconds / interval.seconds);
            if (count >= 1) {
                return count + " " + interval.label + (count > 1 ? 's' : '') + " ago";
            }
        }
        return "just now";
    }

    function refreshTimestamps() {
        document.querySelectorAll('.timestamp-el').forEach(el => {
            const rawDate = el.getAttribute('data-timestamp');
            if (rawDate) {
                el.textContent = timeAgo(rawDate);
            }
        });
    }

    function toggleReplyForm(replyId) {
        const form = document.getElementById('reply-form-' + replyId);
        if (form) {
            form.classList.toggle('hidden');
            if (!form.classList.contains('hidden')) {
                form.querySelector('textarea').focus();
            }
        }
    }

    window.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) { lucide.createIcons(); }
        refreshTimestamps();
        setInterval(refreshTimestamps, 60000);
    });
</script>

<jsp:include page="../common/footer.jsp" />