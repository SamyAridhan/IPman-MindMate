<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modal Fragment for creating or editing a Forum Post.
--%>
<div id="new-post-modal" class="fixed inset-0 z-[60] bg-black/50 backdrop-blur-sm flex items-center justify-center hidden">
    
    <div class="bg-card w-full max-w-lg p-6 rounded-xl shadow-2xl border border-primary/20">
        
        <%-- Header --%>
        <div class="flex justify-between items-center pb-4 border-b border-border">
            <%-- Added id="modal-title" to change text dynamically --%>
            <h3 id="modal-title" class="text-xl font-bold text-foreground">Share Your Experience or Ask for Support</h3>
            <button onclick="closeNewPostModal()" class="p-1 rounded-full text-muted-foreground hover:bg-gray-100 transition-colors" aria-label="Close">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>
        
        <%-- Form Content --%>
        <%-- Added id="post-form" to target the action URL via JS --%>
        <form id="post-form" action="${pageContext.request.contextPath}/student/forum/create" method="POST" class="mt-6 space-y-4">
            
            <%-- Hidden Post ID: Essential for Update operations --%>
            <input type="hidden" name="postId" id="modal-post-id" value="0">
            
            <%-- Support Category --%>
            <div class="space-y-2">
                <label for="support-category" class="text-sm font-medium text-foreground block">Support Category</label>
                <select id="support-category" name="category" 
                    class="w-full px-4 py-2 border border-input rounded-lg bg-background text-foreground focus:ring-2 focus:ring-primary focus:border-primary transition appearance-none">
                    <option value="General Support" selected>General Support</option>
                    <option value="Anxiety Support">Anxiety Support</option>
                    <option value="Depression Support">Depression Support</option>
                    <option value="Stress Management">Stress Management</option>
                    <option value="Sleep Issues">Sleep Issues</option>
                    <option value="Relationships">Relationships</option>
                    <option value="Academic Pressure">Academic Pressure</option>
                </select>
            </div>
            
            <%-- Title Input --%>
            <div class="space-y-2">
                <label for="post-title" class="text-sm font-medium text-foreground block">Title</label>
                <input type="text" id="post-title" name="title" placeholder="What is on your mind?" 
                    class="w-full px-4 py-2 border border-primary/50 rounded-lg bg-primary/5 text-foreground focus:ring-2 focus:ring-primary outline-none" required>
            </div>
            
            <%-- Story Textarea --%>
            <div class="space-y-2">
                <label for="post-story" class="text-sm font-medium text-foreground block">Your Story or Question</label>
                <textarea id="post-story" name="story" rows="5" placeholder="This is a safe space..." 
                    class="w-full px-4 py-2 border border-input rounded-lg bg-background text-foreground focus:ring-2 focus:ring-primary resize-y" required></textarea>
            </div>
            
            <%-- Anonymity Checkbox --%>
            <div class="space-y-3">
                <label class="flex items-center space-x-2 cursor-pointer">
                    <input type="checkbox" id="post-anonymous" name="anonymous" value="true" checked 
                           class="form-checkbox text-primary rounded border-gray-300 focus:ring-primary h-4 w-4">
                    <span class="text-sm font-medium text-foreground">Post anonymously (recommended)</span>
                </label>
                
                <div class="flex items-start p-3 bg-secondary/50 rounded-lg text-sm text-primary border border-primary/20">
                    <i data-lucide="lock" class="h-4 w-4 text-primary shrink-0 mt-0.5"></i>
                    <p class="ml-2">Your identity is protected. Only your anonymous alias will be visible to others.</p>
                </div>
            </div>
            
            <%-- Submit Button --%>
            <div class="pt-2">
                <%-- Added id="modal-submit-btn" to change text dynamically --%>
                <button type="submit" id="modal-submit-btn" class="w-full bg-primary text-primary-foreground py-2.5 rounded-xl font-semibold text-lg shadow-lg hover:bg-primary/90 transition-all active:scale-[0.98]">
                    Share with Community
                </button>
            </div>
        </form>
    </div>
</div>