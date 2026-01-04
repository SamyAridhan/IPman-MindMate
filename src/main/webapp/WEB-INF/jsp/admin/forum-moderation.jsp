<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="min-h-screen bg-background">
    <div class="container mx-auto px-4 py-2">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-foreground mb-2">Forum Moderation</h1>
            <p class="text-muted-foreground">Review and moderate flagged forum posts</p>
        </div>

        <%-- Updated Stats Cards --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            
            <%-- Flagged Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm">
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-muted-foreground">Flagged Posts</p>
                            <p class="text-3xl font-bold text-destructive">${flaggedCount}</p>
                        </div>
                        <i data-lucide="alert-triangle" class="w-8 h-8 text-destructive"></i>
                    </div>
                </div>
            </div>

            <%-- Approved Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm">
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-muted-foreground">Approved Posts</p>
                            <p class="text-3xl font-bold text-success">${approvedCount}</p>
                        </div>
                        <i data-lucide="check-circle" class="w-8 h-8 text-success"></i>
                    </div>
                </div>
            </div>

            <%-- Deleted Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm">
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-muted-foreground">Deleted Posts</p>
                            <%-- This value should be passed from the controller or initialized to 0 --%>
                            <p class="text-3xl font-bold text-muted-foreground">${deletedCount != null ? deletedCount : 0}</p>
                        </div>
                        <i data-lucide="trash-2" class="w-8 h-8 text-muted-foreground"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <hr class="mb-8"/>

        <div class="bg-card border rounded-lg shadow-sm">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="list" class="w-5 h-5 mr-2 text-primary"></i>
                    Review Queue
                </h2>
            </div>

            <div class="p-6">
                <c:choose>
                    <c:when test="${empty flaggedPosts}">
                        <div class="text-center py-12 text-muted-foreground">
                            <i data-lucide="shield-check" class="w-12 h-12 mx-auto mb-4 text-success"></i>
                            <p class="text-lg font-medium">All Clear!</p>
                            <p class="text-sm">There are no flagged posts requiring review.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="min-w-full divide-y divide-border">
                            <thead class="bg-secondary/50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider w-3/5">Post Title & Content</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Author</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Date</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border">
                                <c:forEach var="post" items="${flaggedPosts}">
                                    <tr class="hover:bg-muted/50 transition-colors">
                                        <td class="px-6 py-4 align-top">
                                            <div class="max-w-md">
                                                <p class="font-semibold text-foreground mb-1">${post.title}</p>
                                                <p class="text-sm text-muted-foreground line-clamp-3">${post.content}</p>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top text-muted-foreground text-sm">
                                            <%-- Matches isAnonymous() getter --%>
                                            <c:out value="${post.anonymous ? 'Anonymous' : post.author}"/>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top text-muted-foreground text-sm">
                                            <%-- Matches getTimestamp() getter --%>
                                            <fmt:parseDate value="${post.timestamp}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                            <fmt:formatDate value="${parsedDateTime}" pattern="dd MMM yyyy" />
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top text-right">
                                            <div class="flex justify-end space-x-2">
                                                <%-- Approve Button --%>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/approve">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md text-white bg-success hover:bg-success/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-success"
                                                            onclick="return confirm('Approve this post? It will be visible to everyone and unflagged.');">
                                                        <i data-lucide="check" class="w-3.5 h-3.5 mr-1"></i>
                                                        Approve
                                                    </button>
                                                </form>
                                                
                                                <%-- Delete Button --%>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/delete">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md text-white bg-destructive hover:bg-destructive/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-destructive"
                                                            onclick="return confirm('Permanently delete this post? This cannot be undone.');">
                                                        <i data-lucide="trash-2" class="w-3.5 h-3.5 mr-1"></i>
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof lucide !== 'undefined' && lucide.createIcons) {
            lucide.createIcons();
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />