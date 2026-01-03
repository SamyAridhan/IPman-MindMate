<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-6">
    <div class="space-y-6">
        <%-- BACK BUTTON --%>
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
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h1 class="text-3xl font-bold text-foreground mb-1">${post.title}</h1>
                        <div class="flex items-center gap-2 text-sm text-muted-foreground">
                            <div class="bg-secondary p-1 rounded-full">
                                <i data-lucide="user" class="h-3 w-3 text-primary"></i>
                            </div>
                            <span>
                                Posted by: 
                                <span class="${post.anonymous ? 'italic text-gray-400' : ''}">
                                    ${post.anonymous ? 'Anonymous' : post.author}
                                </span> 
                                • ${post.timestamp}
                            </span>
                        </div>
                    </div>
                    <span class="px-3 py-1 bg-secondary text-primary text-xs font-semibold rounded-full border border-primary/20">
                        ${post.category}
                    </span>
                </div>
                <p class="text-foreground leading-relaxed text-lg whitespace-pre-wrap">${post.content}</p>
            </div>

            <%-- REPLIES SECTION --%>
            <div class="space-y-6">
                <h3 class="text-xl font-semibold text-foreground flex items-center gap-2">
                    <i data-lucide="message-square" class="h-5 w-5 text-primary"></i>
                    <%-- Displaying total replies from your DAO count --%>
                    Replies (${post.repliesList.size()})
                </h3>
                
                <div class="flex flex-col gap-6">
                    <c:forEach var="reply" items="${post.repliesList}">
                        <%-- ONLY START WITH TOP-LEVEL COMMENTS. The tag handles the rest recursively. --%>
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
    });
</script>

<jsp:include page="../common/footer.jsp" />