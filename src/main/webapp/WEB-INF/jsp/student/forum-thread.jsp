<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
            <div class="mb-8">
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
                <div class="border-b border-border pb-6">
                    <p class="text-foreground leading-relaxed text-lg whitespace-pre-wrap">${post.content}</p>
                </div>
            </div>

            <%-- REPLIES SECTION --%>
            <div class="space-y-6">
                <h3 class="text-xl font-semibold text-foreground flex items-center gap-2">
                    <i data-lucide="message-square" class="h-5 w-5 text-primary"></i>
                    Replies (${post.repliesList.size()})
                </h3>
                
                <div class="flex flex-col gap-6">
                    <c:forEach var="reply" items="${post.repliesList}">
                        <%-- 1. TOP-LEVEL COMMENTS --%>
                        <c:if test="${empty reply.parentReply}">
                            <div class="w-full border-b border-border/30 pb-6">
                                
                                <%-- MAIN COMMENT CARD --%>
                                <div class="bg-secondary/10 p-4 rounded-lg border border-border/50 w-full">
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="font-semibold text-sm ${(!reply.anonymous && reply.author == post.author) ? 'text-primary' : 'text-foreground'}">
                                            <c:choose>
                                                <c:when test="${reply.anonymous}">
                                                    <span class="italic text-muted-foreground">Anonymous</span>
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
                                    
                                    <button onclick="toggleReplyForm('nest-${reply.id}')" class="text-xs text-primary font-medium hover:underline flex items-center gap-1">
                                        <i data-lucide="reply" class="w-3 h-3"></i> Reply
                                    </button>
                
                                    <%-- Hidden Form --%>
                                    <div id="reply-form-nest-${reply.id}" class="hidden mt-3">
                                        <form method="POST" action="${pageContext.request.contextPath}/student/forum/thread/reply" class="flex flex-col gap-2">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <input type="hidden" name="parentId" value="${reply.id}">
                                            <textarea name="reply" rows="2" class="w-full p-2 text-sm border border-input rounded-md bg-white focus:ring-1 focus:ring-primary outline-none" placeholder="Reply to ${reply.anonymous ? 'Anonymous' : reply.author}..."></textarea>
                                            <div class="flex items-center justify-between mt-1">
                                                <label class="flex items-center gap-2 cursor-pointer">
                                                    <input type="checkbox" name="anonymous" class="rounded border-gray-300 text-primary focus:ring-primary">
                                                    <span class="text-[11px] text-muted-foreground">Reply anonymously</span>
                                                </label>
                                                <div class="flex gap-2">
                                                    <button type="button" onclick="toggleReplyForm('nest-${reply.id}')" class="text-xs px-2 py-1 text-muted-foreground hover:text-foreground">Cancel</button>
                                                    <button type="submit" class="bg-primary text-white text-xs px-3 py-1 rounded shadow-sm hover:opacity-90">Post</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                
                                <%-- 2. NESTED CHILDREN (FIXED SIZE) --%>
<div class="ml-6 mt-2 border-l-2 border-primary/10 pl-4 space-y-4">
    <c:forEach var="child" items="${reply.children}">
        <div class="child-reply w-full">
            <div class="flex items-center gap-2 mb-1">
                <span class="font-bold text-sm ${(!child.anonymous && child.author == post.author) ? 'text-primary' : 'text-foreground'}">
                    <c:choose>
                        <c:when test="${child.anonymous}">
                            <span class="italic text-muted-foreground font-normal">Anonymous</span>
                        </c:when>
                        <c:otherwise>
                            ${child.author}
                            <c:if test="${child.author == post.author}">
                                <span class="text-[10px] bg-primary/10 px-1.5 py-0.5 rounded border border-primary/20 ml-1">OP</span>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </span>
                <span class="text-xs text-muted-foreground">• ${child.createdAt}</span>
            </div>
            
            <%-- Standardized font size for content --%>
            <p class="text-sm text-muted-foreground mb-2">${child.content}</p>
            
            <%-- Standardized Reply Button --%>
            <button onclick="toggleReplyForm('nest-${child.id}')" class="text-sm text-primary font-medium hover:underline flex items-center gap-1">
                <i data-lucide="reply" class="w-3 h-3"></i> Reply
            </button>

            <div id="reply-form-nest-${child.id}" class="hidden mt-3">
                <form method="POST" action="${pageContext.request.contextPath}/student/forum/thread/reply" class="bg-white p-3 rounded-md border border-border shadow-sm">
                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="parentId" value="${child.id}">
                    <textarea name="reply" rows="2" class="w-full p-2 text-sm border rounded-md outline-none focus:ring-1 focus:ring-primary mb-2" placeholder="Write a reply..."></textarea>
                    
                    <div class="flex items-center justify-between">
                        <%-- Fixed Checkbox Size --%>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" name="anonymous" class="w-4 h-4 rounded border-gray-300 text-primary focus:ring-primary">
                            <span class="text-sm text-muted-foreground">Reply anonymously</span>
                        </label>
                        <div class="flex gap-2">
                             <button type="button" onclick="toggleReplyForm('nest-${child.id}')" class="text-sm px-2 py-1 text-muted-foreground">Cancel</button>
                             <button type="submit" class="bg-primary text-white text-sm px-4 py-1.5 rounded shadow-sm">Post</button>
                        </div>
                    </div>
                </form>
            </div>
            
            <%-- Grandchildren --%>
            <c:if test="${not empty child.children}">
                <div class="mt-3 border-l-2 border-border/50 pl-4 space-y-3">
                    <c:forEach var="grandChild" items="${child.children}">
                        <div class="text-sm text-muted-foreground">
                            <span class="font-bold ${(!grandChild.anonymous && grandChild.author == post.author) ? 'text-primary' : 'text-foreground'}">
                                ${grandChild.anonymous ? 'Anonymous' : grandChild.author}:
                            </span> 
                            ${grandChild.content}
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </c:forEach>
</div>
                            </div>
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
        if (window.lucide) {
            lucide.createIcons();
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />