<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- For date formatting --%>

<jsp:include page="../common/header.jsp" />

<%-- 
    This JSP simulates the React component by assuming necessary data is 
    passed via the Spring Model: ${posts}, ${flaggedPosts}, ${totalApprovedPosts}.
    The actions (Approve/Delete) must be implemented as separate POST endpoints 
    in the Java Controller (e.g., ForumController).
--%>

<div class="min-h-screen bg-background">
    <%-- <Navigation /> is typically included in the header/layout in JSP --%>
    
    <div class="container mx-auto px-4 py-2">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-foreground mb-2">Forum Moderation</h1>
            <p class="text-muted-foreground">Review and moderate flagged forum posts</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            
            <%-- Total Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm">
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-muted-foreground">Total Posts</p>
                            <p class="text-3xl font-bold text-foreground">${posts.size()}</p>
                        </div>
                        <i data-lucide="message-square" class="w-8 h-8 text-primary"></i>
                    </div>
                </div>
            </div>

            <%-- Flagged Posts Card --%>
            <div class="bg-card border rounded-lg shadow-sm">
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-muted-foreground">Flagged Posts</p>
                            <p class="text-3xl font-bold text-destructive">${flaggedPosts.size()}</p>
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
                            <%-- Assuming totalApprovedPosts is calculated in controller --%>
                            <p class="text-3xl font-bold text-success">${totalApprovedPosts}</p>
                        </div>
                        <i data-lucide="check-circle" class="w-8 h-8 text-success"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <hr class="mb-8"/>

        <div class="bg-card border rounded-lg shadow-sm">
            <div class="p-6 border-b border-border">
                <h2 class="text-xl font-semibold text-foreground flex items-center">
                    <i data-lucide="alert-triangle" class="w-5 h-5 mr-2 text-destructive"></i>
                    Flagged Posts Queue
                </h2>
            </div>

            <div class="p-6">
                <c:choose>
                    <c:when test="${empty flaggedPosts}">
                        <div class="text-center py-12 text-muted-foreground">
                            <i data-lucide="check-circle" class="w-12 h-12 mx-auto mb-4 text-success"></i>
                            <p class="text-lg font-medium">No Flagged Posts</p>
                            <p class="text-sm">All forum posts are currently approved</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="min-w-full divide-y divide-border">
                            <thead class="bg-secondary/50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider w-2/5">Post Title</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider w-1/5">Reason</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Author</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Date</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border">
                                <c:forEach var="post" items="${flaggedPosts}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap align-top">
                                            <div>
                                                <p class="font-medium text-foreground">${post.title}</p>
                                                <p class="text-sm text-muted-foreground line-clamp-2">${post.content}</p>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-destructive">
                                                ${post.flag_reason ne null ? post.flag_reason : "Flagged"}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top text-muted-foreground text-sm">
                                            <c:out value="${post.is_anonymous ? 'Anonymous' : post.author}"/>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top text-muted-foreground text-sm">
                                            <%-- Assuming 'created_at' is a string or compatible date format --%>
                                            ${post.created_at}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap align-top">
                                            <div class="flex space-x-2">
                                                <%-- Approve Button (Sends POST request to approve/unflag) --%>
                                                <form method="POST" action="/admin/forum/approve">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-1.5 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
                                                            onclick="return confirm('Are you sure you want to approve and unflag this post?');"
                                                            >
                                                        <i data-lucide="check-circle" class="w-4 h-4 mr-1"></i>
                                                        Approve
                                                    </button>
                                                </form>
                                                
                                                <%-- Delete Button (Sends POST request to delete) --%>
                                                <form method="POST" action="/admin/forum/delete">
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit" 
                                                            class="inline-flex items-center px-3 py-1.5 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-destructive hover:bg-destructive/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-destructive"
                                                            onclick="return confirm('Are you sure you want to permanently delete this post?');"
                                                            >
                                                        <i data-lucide="trash2" class="w-4 h-4 mr-1"></i>
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

<%-- Include necessary JavaScript for icons (assuming you use Lucide) --%>
<script>
    if (typeof lucide !== 'undefined' && lucide.createIcons) {
        lucide.createIcons();
    }
    // Note: Toasts (notifications) would require a separate JS implementation.
</script>

<jsp:include page="../common/footer.jsp" />