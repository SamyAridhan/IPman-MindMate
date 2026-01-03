<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="reply" type="com.mindmate.model.ForumReply" required="true" %>
<%@ attribute name="post" type="com.mindmate.model.ForumPost" required="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags" %>

<div class="w-full ${not empty reply.parentReply ? 'mt-4 ml-6 border-l-2 border-primary/10 pl-4' : 'border-b border-border/30 pb-6'}">
    <%-- REPLY CARD --%>
    <div class="${empty reply.parentReply ? 'bg-secondary/10 p-4 rounded-lg border border-border/50' : ''} w-full">
        <div class="flex items-center gap-2 mb-2">
            <span class="font-semibold text-sm ${(!reply.anonymous && reply.author == post.author) ? 'text-primary' : 'text-foreground'}">
                <c:choose>
                    <c:when test="${reply.anonymous}">
                        <span class="italic text-muted-foreground ${not empty reply.parentReply ? 'font-normal' : ''}">Anonymous</span>
                    </c:when>
                    <c:otherwise>
                        ${reply.author}
                        <c:if test="${reply.author == post.author}">
                            <span class="text-[10px] bg-primary/10 px-1.5 py-0.5 rounded border border-primary/20 ml-1">OP</span>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="text-[10px] text-muted-foreground">• ${reply.createdAt}</span>
        </div>
        
        <p class="text-muted-foreground text-sm mb-3">${reply.content}</p>
        
        <%-- Action Button --%>
        <button onclick="toggleReplyForm('nest-${reply.id}')" class="text-xs text-primary font-medium hover:underline flex items-center gap-1">
            <i data-lucide="reply" class="w-3 h-3"></i> Reply
        </button>

        <%-- Hidden Form --%>
        <div id="reply-form-nest-${reply.id}" class="hidden mt-3">
            <form method="POST" action="${pageContext.request.contextPath}/student/forum/thread/reply" 
                  class="flex flex-col gap-2 ${not empty reply.parentReply ? 'bg-white p-3 rounded-md border border-border shadow-sm' : ''}">
                <input type="hidden" name="postId" value="${post.id}">
                <input type="hidden" name="parentId" value="${reply.id}">
                <textarea name="reply" rows="2" class="w-full p-2 text-sm border border-input rounded-md bg-white focus:ring-1 focus:ring-primary outline-none" 
                          placeholder="Reply to ${reply.anonymous ? 'Anonymous' : reply.author}..."></textarea>
                <div class="flex items-center justify-between mt-1">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="checkbox" name="anonymous" class="w-4 h-4 rounded border-gray-300 text-primary focus:ring-primary">
                        <span class="text-[11px] text-muted-foreground">Reply anonymously</span>
                    </label>
                    <div class="flex gap-2">
                        <button type="button" onclick="toggleReplyForm('nest-${reply.id}')" class="text-xs px-2 py-1 text-muted-foreground hover:text-foreground">Cancel</button>
                        <button type="submit" class="bg-primary text-white text-xs px-3 py-1.5 rounded shadow-sm hover:opacity-90">Post</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%-- RECURSIVE STEP: If this reply has children, display them using this same tag --%>
    <c:if test="${not empty reply.children}">
        <div class="space-y-4">
            <c:forEach var="child" items="${reply.children}">
                <template:displayReply reply="${child}" post="${post}" />
            </c:forEach>
        </div>
    </c:if>
</div>