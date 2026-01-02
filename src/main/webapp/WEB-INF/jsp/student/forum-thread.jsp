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
                    Replies (${post.replies})
                </h3>
                
                <div class="space-y-4">
                    <c:forEach var="reply" items="${post.repliesList}">
                        <div class="bg-secondary/20 p-5 rounded-lg border border-border/50 hover:border-primary/30 transition-colors">
                            <div class="flex items-center gap-2 mb-3">
                                <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center">
                                    <i data-lucide="user" class="w-3 h-3 text-primary"></i>
                                </div>
                                <span class="font-semibold text-foreground text-sm">${reply.author}</span>
                                <span class="text-xs text-muted-foreground">• ${reply.createdAt}</span>
                            </div>
                            <p class="text-muted-foreground leading-relaxed">${reply.content}</p>
                        </div>
                    </c:forEach>

                    <c:if test="${empty post.repliesList}">
                        <div class="text-center py-10 bg-gray-50/50 border border-dashed rounded-lg">
                            <p class="text-gray-400 italic">No replies yet. Be the first to respond and offer support!</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <%-- POST A REPLY FORM --%>
            <div class="mt-8 pt-6 border-t border-border">
                <h3 class="text-lg font-semibold mb-4 text-foreground">Post a Reply</h3>
                <form method="POST" action="${pageContext.request.contextPath}/student/forum/thread/reply" class="space-y-4">
                    <%-- Hidden field to link reply to the correct post --%>
                    <input type="hidden" name="postId" value="${post.id}">
                    
                    <textarea name="reply" rows="4" required
                              class="w-full px-4 py-3 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary bg-white text-foreground placeholder:text-muted-foreground shadow-sm resize-y" 
                              placeholder="Write your words of support or share your experience..."></textarea>
                    
                    <div class="flex justify-end">
                        <button type="submit" 
                                class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-all font-medium shadow-md active:scale-95">
                            Post Reply
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="chatbot-widget.jsp" /> 

<script>
    // Initialize Lucide icons
    window.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) {
            lucide.createIcons();
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />