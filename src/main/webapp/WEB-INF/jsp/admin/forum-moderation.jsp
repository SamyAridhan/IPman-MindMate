<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../common/header.jsp" />

<style>
    /* Prevent horizontal page scroll */
    .table-responsive {
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }
    /* Force title to wrap if it's exceptionally long */
    .title-link {
        word-break: break-word;
        display: block;
        line-height: 1.4;
    }
    /* Ensure all cards have the exact same height and internal alignment */
    .stat-card {
        display: flex;
        flex-direction: column;
        justify-content: flex-start; /* Aligns content to the top */
        min-height: 120px;
    }
</style>

<div class="min-h-screen bg-background">
    <div class="container mx-auto px-4 py-6">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-foreground mb-2">Forum Moderation</h1>
            <p class="text-muted-foreground">Review and moderate flagged forum posts</p>
        </div>

        <%-- STATS CARDS: Fixed with items-start to ensure top alignment across all 3 --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            
            <%-- Flagged Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm p-6 stat-card">
                <div class="flex items-start justify-between w-full">
                    <div>
                        <p class="text-sm text-muted-foreground font-medium mb-1">Flagged Posts</p>
                        <p class="text-3xl font-bold text-destructive">${flaggedCount}</p>
                    </div>
                    <div class="p-2 bg-destructive/10 rounded-lg">
                        <i data-lucide="alert-triangle" class="w-6 h-6 text-destructive"></i>
                    </div>
                </div>
            </div>

            <%-- Approved Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm p-6 stat-card">
                <div class="flex items-start justify-between w-full">
                    <div>
                        <p class="text-sm text-muted-foreground font-medium mb-1">Approved Posts</p>
                        <p class="text-3xl font-bold text-green-600">${approvedCount}</p>
                    </div>
                    <div class="p-2 bg-green-50 rounded-lg">
                        <i data-lucide="check-circle" class="w-6 h-6 text-green-600"></i>
                    </div>
                </div>
            </div>

            <%-- Deleted Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm p-6 stat-card">
                <div class="flex items-start justify-between w-full">
                    <div>
                        <p class="text-sm text-muted-foreground font-medium mb-1">Deleted Posts</p>
                        <p class="text-3xl font-bold text-muted-foreground">${deletedCount}</p>
                    </div>
                    <div class="p-2 bg-muted rounded-lg">
                        <i data-lucide="trash-2" class="w-6 h-6 text-muted-foreground"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="bg-card border rounded-lg shadow-sm">
            <div class="p-6 border-b border-border bg-muted/10">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="shield-alert" class="w-5 h-5 mr-2 text-primary"></i>
                    Pending Moderation
                </h2>
            </div>

            <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty flaggedPosts}">
                        <div class="text-center py-20 text-muted-foreground">
                            <i data-lucide="check-circle-2" class="w-12 h-12 mx-auto mb-4 text-green-500/50"></i>
                            <p class="text-lg font-medium">Moderation Queue Clear</p>
                            <p class="text-sm">There are no flagged items to review at this time.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Removed table-fixed to allow natural spacing, ensured all text-left --%>
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-secondary/30 border-b border-border">
                                <tr>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Post Title</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Author</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Date Reported</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border">
                                <c:forEach var="post" items="${flaggedPosts}">
                                    <tr class="hover:bg-muted/40 transition-colors">
                                        <%-- 1. ONLY TITLE (Clickable) --%>
                                        <td class="px-6 py-5">
                                            <a href="${pageContext.request.contextPath}/admin/forum/view?postId=${post.id}" 
                                               class="text-base font-semibold text-primary hover:text-primary/80 transition-colors title-link">
                                                ${post.title}
                                            </a>
                                        </td>
                                        
                                        <td class="px-6 py-5 text-sm text-muted-foreground">
                                            <c:out value="${post.anonymous ? 'Anonymous' : post.author}"/>
                                        </td>
                                        
                                        <td class="px-6 py-5 text-sm text-muted-foreground">
                                            <fmt:parseDate value="${post.timestamp}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                            <fmt:formatDate value="${parsedDateTime}" pattern="MMM dd, yyyy" />
                                        </td>
                                        
                                        <%-- 2. ACTIONS: Left aligned with the rest of the column data --%>
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/approve" class="m-0">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" class="inline-flex items-center px-3 py-1.5 bg-green-600 hover:bg-green-700 text-white text-[10px] font-bold uppercase tracking-tight rounded transition-all">
                                                        <i data-lucide="check" class="w-3 h-3 mr-1"></i>
                                                        Approve
                                                    </button>
                                                </form>
                                                
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/forum/delete" class="m-0">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white text-[10px] font-bold uppercase tracking-tight rounded transition-all"
                                                            onclick="return confirm('Delete this post permanently?');">
                                                        <i data-lucide="trash-2" class="w-3 h-3 mr-1"></i>
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