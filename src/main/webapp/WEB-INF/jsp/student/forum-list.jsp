<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<%-- MOCK DATA ASSUMPTIONS:
    Your Spring Controller must provide the following Model Attributes:
    1. ${categories}: List of category objects (id, name, color, count).
    2. ${posts}: List of post objects (id, title, content, author, timestamp, category, replies, likes, views, supportLevel, tags).
    3. ${urgentPosts}: List of posts marked as urgent (for the sidebar).
--%>
<div class="container mx-auto py-3">
    <div class="flex items-center justify-between mb-2 border-b pb-4">
        <div class="flex items-center space-x-4">
            <%-- Assuming header/nav handles the back button --%>
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Peer Support Forum</h1>
                <p class="text-gray-600 mt-1">Safe, anonymous community support • Join discussions, share experiences, and find support.</p>
            </div>
        </div>
        
        <%-- New Post Button (DialogTrigger converted to simple button/onclick) --%>
        <button onclick="openNewPostModal()" class="flex items-center bg-primary text-primary-foreground hover:bg-primary/90 px-4 py-2 rounded-lg font-semibold shadow-md transition-colors">
            <i data-lucide="plus" class="w-4 h-4 mr-2"></i>
            Share or Ask for Support
        </button>
    </div>

    <%-- Main Tabs (Keeping only the structure for User View, ignoring Moderator View logic) --%>
    <div class="w-full">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            
            <%-- START SIDEBAR (lg:col-span-1) --%>
            <div class="lg:col-span-1 space-y-6">
                
                <%-- Support Categories Card --%>
                <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
                    <h2 class="text-lg font-semibold text-foreground flex items-center mb-3 pb-3 border-b border-border/70">
                        <i data-lucide="handshake" class="w-5 h-5 mr-2"></i>
                        Support Categories
                    </h2>
                    <div class="space-y-2">
                        <c:set var="categories" value="${forumCategories}" /> <%-- Use the controller's attribute name if available --%>
                        <c:if test="${empty categories}">
                            <%-- Mock categories if controller didn't provide them (for UI preview) --%>
                            <c:set var="categories" value="${[{'id': 'all', 'name': 'All Topics', 'count': 42, 'color': 'bg-blue-100 text-blue-800'}, {'id': 'anxiety', 'name': 'Anxiety Support', 'count': 15, 'color': 'bg-purple-100 text-purple-800'}, {'id': 'general', 'name': 'General Support', 'count': 2, 'color': 'bg-gray-100 text-gray-800'}]}" />
                        </c:if>

                        <c:forEach var="category" items="${categories}">
                            <%-- Mocking selected category based on a URL parameter or default value --%>
                            <a href="?category=${category.id}" 
                                class="flex items-center w-full justify-between p-2 rounded-lg transition-colors 
                                    <c:choose>
                                        <c:when test="${param.category eq category.id}">bg-primary text-primary-foreground hover:bg-primary/90</c:when>
                                        <c:otherwise>text-foreground hover:bg-gray-50</c:otherwise>
                                    </c:choose>
                                ">
                                <span class="text-sm font-medium">${category.name}</span>
                                <c:if test="${category.id ne 'all'}">
                                    <span class="ml-2 px-2 py-0.5 text-xs rounded-full ${category.color}">${category.count}</span>
                                </c:if>
                            </a>
                        </c:forEach>
                    </div>
                </div>

                <%-- Urgent Support Needed Card (Simplified Mock) --%>
                <c:if test="${not empty urgentPosts}">
                    <div class="bg-card p-4 rounded-lg shadow-sm border border-red-200">
                        <h2 class="text-lg font-semibold text-red-700 flex items-center mb-3 pb-3 border-b border-red-200/70">
                            <i data-lucide="alert-triangle" class="w-5 h-5 mr-2"></i>
                            Urgent Support Needed
                        </h2>
                        <div class="space-y-2">
                            <c:forEach var="post" items="${urgentPosts}" begin="0" end="2">
                                <div class="text-sm p-2 bg-red-50 rounded">
                                    <p class="font-medium truncate">${post.title}</p>
                                    <p class="text-gray-600 text-xs">${post.author} • ${post.timestamp}</p>
                                </div>
                            </c:forEach>
                            <a href="#" class="text-xs text-red-700 hover:underline block mt-2">View all urgent posts</a>
                        </div>
                    </div>
                </c:if>

                <%-- Peer Support Guidelines Card --%>
                <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
                    <h2 class="text-lg font-semibold text-foreground mb-3 pb-3 border-b border-border/70">
                        Peer Support Guidelines
                    </h2>
                    <div class="space-y-2 text-sm text-gray-600">
                        <p>• Listen with empathy and respect</p>
                        <p>• Share your experiences, not advice</p>
                        <p>• Respect anonymity and privacy</p>
                        <p>• Flag concerning content immediately</p>
                        <p>• Encourage professional help when needed</p>
                    </div>
                </div>
            </div>
            <%-- END SIDEBAR --%>

            <%-- START MAIN CONTENT (lg:col-span-3) --%>
            <div class="lg:col-span-3">
                
                <%-- Search and Filters (Converted from React state/hooks to static structure) --%>
                <div class="mb-6 space-y-4">
                    <div class="flex gap-4">
                        <div class="relative flex-1">
                            <i data-lucide="search" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4"></i>
                            <input 
                                type="text"
                                placeholder="Search posts, topics, or tags..."
                                class="w-full pl-10 px-3 py-2 border border-input rounded-md focus:ring-2 focus:ring-primary focus:border-primary"
                                aria-label="Search forum"
                            />
                        </div>
                        <select 
                            class="px-3 py-2 border border-input rounded-md bg-background appearance-none cursor-pointer"
                            aria-label="Sort by"
                        >
                            <option value="recent">Most Recent</option>
                            <option value="popular">Most Popular</option>
                            <option value="helpful">Most Helpful</option>
                            <option value="active">Most Active</option>
                        </select>
                    </div>
                </div>

                <%-- Posts Listing (Using JSTL to iterate mock data) --%>
                <div class="space-y-4">
                    <c:forEach var="post" items="${posts}">
                        <%-- Simulate dynamic background color based on supportLevel (React: getSupportLevelColor) --%>
                        <c:set var="level" value="${post.supportLevel}" />
                        <c:set var="levelClass">
                            <c:choose>
                                <c:when test="${level eq 'urgent'}">border-red-300 bg-red-50</c:when>
                                <c:when test="${level eq 'high'}">border-orange-300 bg-orange-50</c:when>
                                <c:when test="${level eq 'medium'}">border-yellow-300 bg-yellow-50</c:when>
                                <c:when test="${level eq 'positive'}">border-green-300 bg-green-50</c:when>
                                <c:otherwise>border-border bg-card</c:otherwise>
                            </c:choose>
                        </c:set>
                        
                        <a href="/student/forum/thread?id=${post.id}" class="block">
                            <div class="p-6 rounded-lg shadow-sm transition-shadow hover:shadow-lg border ${levelClass}">
                                <div class="flex justify-between items-start mb-3">
                                    <div class="flex items-center space-x-2 flex-wrap">
                                        <%-- Category Badge --%>
                                        <span class="text-xs px-2 py-0.5 rounded-full border border-gray-300 text-gray-700 bg-white">
                                            ${post.categoryName}
                                        </span>
                                        <%-- Support Level Badge (React: getSupportLevelBadge) --%>
                                        <c:if test="${level eq 'urgent'}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-red-600 text-white">Urgent Support Needed</span>
                                        </c:if>
                                        <c:if test="${level eq 'high'}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-orange-100 text-orange-800">High Priority</span>
                                        </c:if>
                                        <c:if test="${post.coachingRequested}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-purple-100 text-purple-800">Professional Support Requested</span>
                                        </c:if>
                                    </div>
                                    <div class="flex items-center text-xs text-gray-500">
                                        <i data-lucide="clock" class="w-3 h-3 mr-1"></i>
                                        ${post.timestamp}
                                    </div>
                                </div>

                                <h3 class="font-semibold text-lg mb-2 text-foreground">${post.title}</h3>
                                <p class="text-gray-700 mb-4 line-clamp-2">${post.content}</p>

                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-4 text-sm text-gray-500">
                                        <div class="flex items-center">
                                            <i data-lucide="user" class="w-4 h-4 mr-1"></i>
                                            <span>${post.author}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i data-lucide="message-circle" class="w-4 h-4 mr-1"></i>
                                            <span>${post.replies} responses</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i data-lucide="eye" class="w-4 h-4 mr-1"></i>
                                            <span>${post.views} views</span>
                                        </div>
                                    </div>

                                    <%-- Action Buttons (Simplified to show presence; full JS interaction not required for UI only) --%>
                                    <div class="flex items-center space-x-2 text-sm">
                                        <span class="text-gray-500 flex items-center">
                                            <i data-lucide="heart" class="w-4 h-4 mr-1"></i> ${post.likes}
                                        </span>
                                        <span class="text-gray-500 flex items-center">
                                            <i data-lucide="award" class="w-4 h-4 mr-1"></i> ${post.helpfulCount}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                    
                    <%-- Fallback if no posts are available --%>
                    <c:if test="${empty posts}">
                         <div class="text-center py-10 border border-dashed rounded-lg text-gray-500 bg-card">
                            <i data-lucide="help-circle" class="w-8 h-8 mx-auto mb-3"></i>
                            <p class="font-medium">No active discussion threads found.</p>
                            <p class="text-sm">Be the first to <a href="#" onclick="openNewPostModal(); return false;" class="text-primary hover:underline">Share or Ask for Support</a>.</p>
                        </div>
                    </c:if>
                </div>
            </div>
            <%-- END MAIN CONTENT --%>
        </div>
    </div>
</div>

<%-- 3. INCLUDE THE NEW POST MODAL FRAGMENT (Already defined in common) --%>
<jsp:include page="new-post-modal.jsp" />

<%-- 4. JAVASCRIPT TO CONTROL THE MODAL (Placed right before footer) --%>
<script>
    // NOTE: This assumes 'new-post-modal.jsp' is in '../common/'
    const postModal = document.getElementById('new-post-modal');

    function openNewPostModal() {
        if (postModal) {
            postModal.classList.remove('hidden');
            // Optional: Disable scrolling on the body when modal is open
            document.body.style.overflow = 'hidden'; 
        } else {
            console.error("New Post Modal element not found. Check if new-post-modal.jsp is included.");
        }
    }

    function closeNewPostModal() {
        if (postModal) {
            postModal.classList.add('hidden');
            // Optional: Re-enable scrolling
            document.body.style.overflow = ''; 
        }
    }
    
    // Ensure Lucide icons are processed again if this is the main content of the page
    if (typeof lucide !== 'undefined' && lucide.createIcons) {
        lucide.createIcons();
    }
</script>

<jsp:include page="../common/footer.jsp" />