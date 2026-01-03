<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
    <%-- HEADER SECTION --%>
    <div class="flex items-center justify-between mb-2 border-b pb-4">
        <div>
            <h1 class="text-3xl font-bold text-foreground mb-2">Peer Support Forum</h1>
            <p class="text-gray-600 mt-1">Safe, anonymous community support • Join discussions, share experiences, and find support.</p>
        </div>
        
        <button onclick="openNewPostModal()" class="flex items-center bg-primary text-primary-foreground hover:bg-primary/90 px-4 py-2 rounded-lg font-semibold shadow-md transition-all active:scale-95">
            <i data-lucide="plus" class="w-4 h-4 mr-2"></i>
            Share or Ask for Support
        </button>
    </div>

    <div class="w-full">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            
            <%-- SIDEBAR --%>
            <div class="lg:col-span-1 space-y-6">
                <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
                    <h2 class="text-lg font-semibold text-foreground flex items-center mb-3 pb-3 border-b border-border/70">
                        <i data-lucide="handshake" class="w-5 h-5 mr-2 text-primary"></i>
                        Support Categories
                    </h2>
                    <div class="space-y-1">
                        <c:set var="totalCount" value="${forumCategories[0].count}" />

                        <a href="${pageContext.request.contextPath}/student/forum" 
                           class="flex items-center w-full justify-between p-2 rounded-lg transition-colors 
                           ${empty param.category ? 'bg-primary text-primary-foreground shadow-sm' : 'text-foreground hover:bg-secondary/50'}">
                            <span class="text-sm font-medium">All Topics</span>
                            <span class="text-[10px] font-bold">${totalCount}</span>
                        </a>

                        <hr class="my-2 border-border/50" />

                        <c:set var="fixedCategories" value="General Support,Anxiety Support,Depression Support,Stress Management,Sleep Issues,Relationships,Academic Pressure" />
                        <c:forEach var="catName" items="${fixedCategories}">
                            <a href="?category=${catName}" 
                               class="flex items-center w-full justify-between p-2 rounded-lg transition-colors 
                               ${param.category eq catName ? 'bg-primary text-primary-foreground shadow-sm' : 'text-foreground hover:bg-secondary/50'}">
                                <span class="text-sm font-medium">${catName}</span>
                                
                                <c:set var="foundCount" value="0" />
                                <c:forEach var="dbCat" items="${forumCategories}">
                                    <c:if test="${dbCat.name eq catName}"><c:set var="foundCount" value="${dbCat.count}" /></c:if>
                                </c:forEach>
                                <span class="ml-2 px-2 py-0.5 text-[10px] rounded-full ${foundCount > 0 ? 'bg-secondary text-primary font-bold' : 'text-gray-400'}">
                                    ${foundCount}
                                </span>
                            </a>
                        </c:forEach>
                    </div>
                </div>

                <%-- Guidelines Card --%>
                <div class="bg-card p-4 rounded-lg shadow-sm border border-border">
                    <h2 class="text-lg font-semibold text-foreground mb-3 pb-3 border-b border-border/70">Peer Support Guidelines</h2>
                    <div class="space-y-2 text-sm text-gray-600 italic">
                        <p>• Listen with empathy and respect</p>
                        <p>• Share experiences, not advice</p>
                        <p>• Flag concerning content immediately</p>
                    </div>
                </div>
            </div>

            <%-- MAIN CONTENT --%>
            <div class="lg:col-span-3">
                <%-- Search & Filters --%>
                <div class="mb-6">
                    <form method="GET" action="${pageContext.request.contextPath}/student/forum">
                        <div class="flex gap-4 items-center">
                            <div class="relative flex-1">
                                <i data-lucide="search" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4"></i>
                                <input name="searchQuery" type="text" placeholder="Search posts, topics, or tags..." value="${currentSearch}" 
                                       class="w-full pl-10 px-3 py-2 border border-input rounded-md focus:ring-2 focus:ring-primary focus:border-primary outline-none">
                            </div>
                            <div class="relative">
                                <select name="sortBy" onchange="this.form.submit()" class="px-3 py-2 border border-input rounded-md bg-background appearance-none cursor-pointer pr-8">
                                    <option value="recent" ${currentSort eq 'recent' ? 'selected' : ''}>Most Recent</option>
                                    <option value="popular" ${currentSort eq 'popular' ? 'selected' : ''}>Most Popular</option>
                                    <option value="helpful" ${currentSort eq 'helpful' ? 'selected' : ''}>Most Helpful</option>
                                </select>
                                <i data-lucide="chevron-down" class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4 pointer-events-none"></i>
                            </div>
                        </div>
                    </form>
                </div>

                <%-- POSTS LISTING --%>
                <div class="space-y-4">
                    <c:forEach var="post" items="${posts}">
                        <%-- Logic for Card Shading if Flagged --%>
                        <c:set var="cardClass" value="${post.flaggedByCurrentUser ? 'bg-red-50/50 border-red-200' : 'bg-card border-border'}" />

                        <a href="${pageContext.request.contextPath}/student/forum/thread?id=${post.id}" class="block group">
                            <div class="p-6 rounded-lg shadow-sm transition-all group-hover:shadow-md border ${cardClass}">
                                
                                <%-- Post Header --%>
                                <div class="flex justify-between items-start mb-3">
                                    <div class="flex items-center space-x-2 flex-wrap">
                                        <span class="text-xs px-2 py-0.5 rounded-full border border-gray-300 text-gray-700 bg-white">${post.category}</span>
                                        <c:if test="${post.helpfulCount > 5}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-green-100 text-green-800">Highly Helpful</span>
                                        </c:if>
                                        <c:if test="${post.flagged}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-red-600 text-white font-medium">Under Review</span>
                                        </c:if>
                                    </div>
                                    <div class="flex items-center text-xs text-gray-500">
                                        <i data-lucide="clock" class="w-3 h-3 mr-1"></i>
                                        ${post.timestamp}
                                    </div>
                                </div>

                                <%-- Title & Content --%>
                                <h3 class="font-semibold text-lg mb-2 text-foreground group-hover:text-primary transition-colors">${post.title}</h3>
                                <p class="text-gray-700 mb-4 line-clamp-2">${post.content}</p>

                                <%-- Footer --%>
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-4 text-sm text-gray-500">
                                        <div class="flex items-center">
                                            <i data-lucide="user" class="w-4 h-4 mr-1"></i>
                                            <span class="${post.anonymous ? 'italic text-gray-400' : ''}">${post.anonymous ? 'Anonymous' : post.author}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i data-lucide="message-circle" class="w-4 h-4 mr-1"></i>
                                            <span>${post.totalReplies} responses</span>
                                        </div>
                                    </div>

                                    <%-- Action Buttons (FIXED TRANSIT PROPERTY NAMES) --%>
                                    <div class="flex items-center space-x-2">
                                        <%-- LIKE BUTTON --%>
                                        <button onclick="event.preventDefault(); recordInteraction('${post.id}', 'like', this)" 
                                                class="flex items-center px-2 py-1 rounded transition-colors ${post.likedByCurrentUser ? 'bg-red-100 text-red-600' : 'hover:bg-red-50 hover:text-red-600 text-gray-500'}">
                                            <i data-lucide="heart" class="w-4 h-4 mr-1 ${post.likedByCurrentUser ? 'fill-current' : ''}"></i> 
                                            <span id="likes-count-${post.id}">${post.likes}</span>
                                        </button>
                                        
                                        <%-- HELPFUL BUTTON --%>
                                        <button onclick="event.preventDefault(); recordInteraction('${post.id}', 'helpful', this)" 
                                                class="flex items-center px-2 py-1 rounded transition-colors ${post.helpfulByCurrentUser ? 'bg-green-100 text-green-600' : 'hover:bg-blue-50 hover:text-blue-600 text-gray-500'}">
                                            <i data-lucide="award" class="w-4 h-4 mr-1"></i> 
                                            <span id="helpful-count-${post.id}">${post.helpfulCount}</span>
                                        </button>

                                        <%-- FLAG BUTTON --%>
                                        <button onclick="event.preventDefault(); flagPost('${post.id}', this)" 
                                                class="p-1 rounded transition-colors ${post.flaggedByCurrentUser ? 'text-red-600 bg-red-100' : 'text-gray-400 hover:bg-red-50 hover:text-red-600'}">
                                            <i data-lucide="flag" class="w-4 h-4 ${post.flaggedByCurrentUser ? 'fill-current' : ''}"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>

                    <c:if test="${empty posts}">
                        <div class="text-center py-20 border border-dashed rounded-lg text-gray-400 bg-gray-50/50">
                            <i data-lucide="inbox" class="w-12 h-12 mx-auto mb-4 opacity-20"></i>
                            <p class="text-lg font-medium">No posts found.</p>
                            <p class="text-sm">Be the first to share your journey!</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="new-post-modal.jsp" />

<script>
    const postModal = document.getElementById('new-post-modal');
    function openNewPostModal() { postModal?.classList.remove('hidden'); document.body.style.overflow = 'hidden'; }
    function closeNewPostModal() { postModal?.classList.add('hidden'); document.body.style.overflow = ''; }

    function recordInteraction(postId, type, btn) {
        btn.disabled = true;
        fetch('${pageContext.request.contextPath}/student/forum/interact', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `postId=`+postId+`&type=`+type
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                // Update text count
                const countSpan = type === 'like' ? 
                    document.getElementById(`likes-count-`+postId) : 
                    document.getElementById(`helpful-count-`+postId);
                countSpan.textContent = data.newCount;

                // Handle visual shading toggle
                const icon = btn.querySelector('i');
                if (type === 'like') {
                    btn.classList.toggle('bg-red-100', data.isActive);
                    btn.classList.toggle('text-red-600', data.isActive);
                    btn.classList.toggle('text-gray-500', !data.isActive);
                    icon.classList.toggle('fill-current', data.isActive);
                } else if (type === 'helpful') {
                    btn.classList.toggle('bg-green-100', data.isActive);
                    btn.classList.toggle('text-green-600', data.isActive);
                    btn.classList.toggle('text-gray-500', !data.isActive);
                }
            }
        })
        .finally(() => {
            btn.disabled = false;
            if (window.lucide) lucide.createIcons();
        });
    }

    function flagPost(postId, btn) {
        if (!confirm("Flag this content for review?")) return;
        fetch('${pageContext.request.contextPath}/student/forum/flag', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `postId=`+postId
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                btn.classList.add('text-red-600', 'bg-red-100');
                btn.querySelector('i').classList.add('fill-current');
                // Shade the entire card
                btn.closest('.p-6').classList.add('bg-red-50/50', 'border-red-200');
                alert('Thank you. Our moderators will review this post.');
            }
        });
    }

    window.addEventListener('DOMContentLoaded', () => { if (window.lucide) lucide.createIcons(); });
</script>

<jsp:include page="../common/footer.jsp" />