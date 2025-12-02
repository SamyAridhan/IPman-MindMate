<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto py-3">
    <div class="flex items-center justify-between mb-2 border-b pb-4">
        <div class="flex items-center space-x-4">
            <%-- Assuming header/nav handles the back button --%>
            <div>
                <h1 class="text-3xl font-bold text-foreground mb-2">Peer Support Forum</h1>
                <p class="text-gray-600 mt-1">Safe, anonymous community support • Join discussions, share experiences, and find support.</p>
            </div>
        </div>
        
        <%-- New Post Button (DialogTrigger converted to simple button/onclick) --%>
        <button onclick="openNewPostModal()" class="flex items-center bg-primary text-primary-foreground hover:bg-primary/90 px-4 py-2 rounded-lg font-semibold shadow-md transition-colors">
            <i data-lucide="plus" class="w-4 h-4 mr-2"></i>
            Share or Ask for Support
        </button>
    </div>

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
                        <%-- 🔥 START CATEGORY LIST LOOP 🔥 --%>
                        <c:forEach var="category" items="${forumCategories}">
                            <%-- Mocking selected category based on a URL parameter or default value --%>
                            <a href="?category=${category.id}" 
                                class="flex items-center w-full justify-between p-2 rounded-lg transition-colors 
                                    <c:choose>
                                        <c:when test="${param.category eq category.id}">bg-primary text-primary-foreground hover:bg-primary/90</c:when>
                                        <c:otherwise>text-foreground hover:bg-gray-50</c:otherwise>
                                    </c:choose>
                                ">
                                <span class="text-sm font-medium">${category.name}</span>
                                <c:if test="${category.count > 0}">
                                    <%-- The count comes from the controller now --%>
                                    <span class="ml-2 px-2 py-0.5 text-xs rounded-full ${category.color}">${category.count}</span>
                                </c:if>
                            </a>
                        </c:forEach>
                        <%-- 🔥 END CATEGORY LIST LOOP 🔥 --%>
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
                                <a href="/student/forum/thread?id=${post.id}" class="block text-sm p-2 bg-red-50 rounded hover:bg-red-100 transition-colors">
                                    <p class="font-medium truncate">${post.title}</p>
                                    <p class="text-gray-600 text-xs">${post.author} • ${post.timestamp}</p>
                                </a>
                            </c:forEach>
                            <a href="#" class="text-xs text-red-700 hover:underline block mt-2">View all urgent posts</a>
                        </div>
                    </div>
                </c:if>

                <%-- Peer Support Guidelines Card (No change needed) --%>
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
                
                <%-- Search and Filters (Combined and Fixed) --%>
                <div class="mb-6 space-y-4">
                    
                    <%-- 1. Use ONE Form for both Search and Sort --%>
                    <form method="GET" action="/student/forum">
                        <div class="flex gap-4 items-center">
                            
                            <%-- Search Input Section (Flex-1) --%>
                            <div class="relative flex-1">
                                <i data-lucide="search" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4"></i>
                                <input 
                                    name="searchQuery"
                                    type="text"
                                    placeholder="Search posts, topics, or tags..."
                                    value="${currentSearch}" 
                                    class="w-full pl-10 px-3 py-2 border border-input rounded-md focus:ring-2 focus:ring-primary focus:border-primary"
                                    aria-label="Search forum"
                                />
                            </div>
                            
                            <%-- Sort Dropdown Section (Relative Container for Icon) --%>
                            <div class="relative shrink-0">
                                <select 
                                    id="sort-select"
                                    name="sortBy" 
                                    onchange="this.form.submit()"

                                    class="px-3 py-2 border border-input rounded-md bg-background appearance-none cursor-pointer pr-8" aria-label="Sort by"
                                >
                                    <option value="recent" <c:if test="${currentSort eq 'recent' or empty currentSort}">selected</c:if>>Most Recent</option>
                                    <option value="popular" <c:if test="${currentSort eq 'popular'}">selected</c:if>>Most Popular</option>
                                    <option value="helpful" <c:if test="${currentSort eq 'helpful'}">selected</c:if>>Most Helpful</option>
                                    <option value="active" <c:if test="${currentSort eq 'active'}">selected</c:if>>Most Active</option>
                                </select>
                                
                                <i 
                                    data-lucide="chevron-down" 
                                    class="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4 pointer-events-none"
                                ></i>
                            </div>
                            
                            <%-- Hidden button to allow form submission on Enter key --%>
                            <button type="submit" class="hidden">Apply Filters</button>
                        </div>
                    </form>
                </div>

<%-- 🔥 START POSTS LISTING 🔥 --%>
<div class="space-y-4">
    <c:forEach var="post" items="${posts}">
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
                
                <%-- HEADER: Category Badges & Timestamp (No change needed) --%>
                <div class="flex justify-between items-start mb-3">
                    <div class="flex items-center space-x-2 flex-wrap">
                        <span class="text-xs px-2 py-0.5 rounded-full border border-gray-300 text-gray-700 bg-white">${post.categoryName}</span>
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

                <%-- BODY: Title & Content (No change needed) --%>
                <h3 class="font-semibold text-lg mb-2 text-foreground">${post.title}</h3>
                <p class="text-gray-700 mb-4 line-clamp-2">${post.content}</p>

                <%-- FOOTER: User Stats (Left) and Action Buttons (Right) --%>
                <div class="flex items-center justify-between">
                    
                    <%-- Left: User Stats (Author, Replies, Views) --%>
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

            <%-- Right: Interaction Buttons & CTAs --%>
        <div class="flex items-center space-x-4 text-sm">
            
            <%-- 🔥 FIX: Group Like, Helpful, and Flag horizontally in one container 🔥 --%>
            <div class="flex items-center space-x-2 text-base"> 
                
                <button 
                    onclick="recordInteraction(${post.id}, 'like', this)" 
                    class="text-gray-500 flex items-center p-1 rounded hover:bg-secondary transition-colors disabled:opacity-50" 
                    aria-label="Like Post"
                >
                    <i data-lucide="heart" class="w-4 h-4 mr-1"></i> 
                    <span id="likes-count-${post.id}">${post.likes}</span>
                </button>
                
                <button 
                    onclick="recordInteraction(${post.id}, 'helpful', this)" 
                    class="text-gray-500 flex items-center p-1 rounded hover:bg-secondary transition-colors disabled:opacity-50" 
                    aria-label="Mark as helpful"
                >
                    <i data-lucide="award" class="w-4 h-4 mr-1"></i> 
                    <span id="helpful-count-${post.id}">${post.helpfulCount}</span>
                </button>

                <button 
                    id="flag-button-${post.id}"
                    onclick="flagPost(${post.id}, this)" 
                    class="p-1 rounded transition-colors disabled:opacity-50 
                        <c:if test="${post.isFlagged}">text-[#dc2626] hover:bg-[#ffb2ae]</c:if> <%-- Already flagged --%>
                        <c:if test="${not post.isFlagged}">text-gray-500 hover:bg-[#ffb2ae] hover:text-[#dc2626]</c:if>" <%-- Not flagged yet --%>
                    aria-label="Flag post for review"
                >
                    <i data-lucide="flag" class="w-4 h-4"></i>
                </button>
            </div>
    
    <%-- Offer/Request CTA Buttons (This group is separate and uses space-x-4 from parent) --%>
    <a href="/student/forum/thread?id=${post.id}" class="inline-flex items-center px-3 py-1.5 border border-green-300 rounded-lg text-sm font-semibold text-green-700 bg-green-50 hover:bg-green-100 transition-colors">
        Offer Support
    </a>
    <a href="/student/telehealth" class="inline-flex items-center px-3 py-1.5 border border-purple-300 rounded-lg text-sm font-semibold text-purple-700 bg-purple-50 hover:bg-purple-100 transition-colors">
        Request Help
    </a>
    
</div>
</div>
                
            </div> <%-- Closes p-6 div --%>
        </a> <%-- Closes a tag --%>
    </c:forEach>
    
    <%-- Fallback if no posts are available --%>
    </div>
                    
                    <%-- Fallback if no posts are available --%>
                    <c:if test="${empty posts}">
                           <div class="text-center py-10 border border-dashed rounded-lg text-gray-500 bg-card">
                               <i data-lucide="help-circle" class="w-8 h-8 mx-auto mb-3"></i>
                               <p class="font-medium">No active discussion threads found.</p>
                               <p class="text-sm">Be the first to <a href="#" onclick="openNewPostModal(); return false;" class="text-primary hover:underline">Share or Ask for Support</a>.</p>
                           </div>
                    </c:if>
                </div>
                <%-- 🔥 END POSTS LISTING 🔥 --%>
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

    // Add this function inside your existing <script> block in forum-list.jsp

    /**
     * Sends an AJAX request to record a like or helpful vote and updates the UI.
     * @param {number} postId - The ID of the post to update.
     * @param {string} type - 'like' or 'helpful'.
     * @param {HTMLElement} buttonElement - The button that was clicked.
     */
    function recordInteraction(postId, type, buttonElement) {
        // Prevent double-clicking
        buttonElement.disabled = true;

        fetch('/student/forum/interact', {
            method: 'POST',
            headers: {
                // Ensure the content type is correct for Spring to parse @RequestParam
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            // Send the postId and interaction type
            body: `postId=${postId}&type=${type}`
        })
        .then(response => {
            if (!response.ok) {
                // Handle non-200 responses
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                console.error("Error recording interaction:", data.error);
                return;
            }
            
            // Update the specific count on the page using the unique IDs
            const likesSpan = document.getElementById(`likes-count-${postId}`);
            const helpfulSpan = document.getElementById(`helpful-count-${postId}`);

            if (likesSpan && data.likes !== undefined) {
                likesSpan.textContent = data.likes;
            }
            if (helpfulSpan && data.helpfulCount !== undefined) {
                helpfulSpan.textContent = data.helpfulCount;
            }

        })
        .catch(error => {
            console.error('Fetch error:', error);
            alert('Could not record your vote. Please try again.');
        })
        .finally(() => {
            // Re-enable the button
            buttonElement.disabled = false;
        });
    }

    // Add this function inside your existing <script> block in forum-list.jsp

    /**
     * Sends an AJAX request to flag a post for admin review.
     * @param {number} postId - The ID of the post to flag.
     * @param {HTMLElement} buttonElement - The button that was clicked.
     */
    function flagPost(postId, buttonElement) {
        // Prevent double-clicking
        buttonElement.disabled = true;

        // Confirmation dialog (optional but good practice for irreversible action)
        if (!confirm("Are you sure you want to flag this post for admin review?")) {
            buttonElement.disabled = false;
            return;
        }

        fetch('/student/forum/flag', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `postId=${postId}`
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success && data.isFlagged === true) {
                // Update button style to indicate it has been flagged
                buttonElement.classList.remove('text-gray-500', 'hover:bg-secondary');
                buttonElement.classList.add('text-red-600', 'hover:bg-red-50');
                alert('Post has been flagged for admin review.');
            } else {
                alert('Flagging failed.');
            }
        })
        .catch(error => {
            console.error('Fetch error during flagging:', error);
            alert('Could not flag the post. Please try again.');
        })
        .finally(() => {
            // Re-enable the button
            buttonElement.disabled = false;
        });
    }
</script>

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />