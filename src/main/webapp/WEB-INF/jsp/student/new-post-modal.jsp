<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modal Fragment for creating a new Forum Post.
    Controlled by JavaScript on the calling page (e.g., forum-list.jsp).
--%>
<div id="new-post-modal" class="fixed inset-0 z-[60] bg-black/50 backdrop-blur-sm flex items-center justify-center hidden">
    
    <div class="bg-card w-full max-w-lg p-6 rounded-xl shadow-2xl transform transition-all scale-100 opacity-100 border border-primary/20">
        
        <%-- Header --%>
        <div class="flex justify-between items-center pb-4 border-b border-border">
            <h3 class="text-xl font-bold text-foreground">Share Your Experience or Ask for Support</h3>
            <button onclick="closeNewPostModal()" class="p-1 rounded-full text-muted-foreground hover:bg-gray-100 transition-colors" aria-label="Close">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>
        
        <%-- Form Content --%>
        <form class="mt-6 space-y-4">
            
            <%-- Support Category (Matching the drop-down visual) --%>
            <div class="space-y-2">
                <label for="support-category" class="text-sm font-medium text-foreground block">Support Category</label>
                <select id="support-category" name="category" 
                    class="w-full px-4 py-2 border border-input rounded-lg bg-background text-foreground focus:ring-2 focus:ring-primary focus:border-primary transition duration-150 appearance-none">
                    
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
                <input type="text" id="post-title" name="title" placeholder="What would you like to share or ask about?" 
                    class="w-full px-4 py-2 border border-primary/50 rounded-lg bg-primary/5 text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-primary focus:border-primary transition duration-150" required>
            </div>
            
            <%-- Story or Question Textarea --%>
            <div class="space-y-2">
                <label for="post-story" class="text-sm font-medium text-foreground block">Your Story or Question</label>
                <textarea id="post-story" name="story" rows="5" placeholder="Share your experience, ask for advice, or offer support to others. This is a judgment-free space..." 
                    class="w-full px-4 py-2 border border-input rounded-lg bg-background text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-primary focus:border-primary transition duration-150 resize-y" required></textarea>
            </div>
            
            <%-- Anonymity Checkbox and Warning --%>
            <div class="space-y-3">
                <label class="flex items-center space-x-2 cursor-pointer">
                    <input type="checkbox" id="post-anonymous" name="anonymous" checked class="form-checkbox text-primary rounded border-gray-300 focus:ring-primary h-4 w-4">
                    <span class="text-sm font-medium text-foreground">Post anonymously (recommended)</span>
                </label>
                
                <div class="flex items-start p-3 bg-secondary/50 rounded-lg text-sm text-primary border border-primary/20">
                    <i data-lucide="lock" class="h-4 w-4 text-primary shrink-0 mt-0.5"></i>
                    <p class="ml-2">Anonymous posts protect your privacy with randomly generated usernames. Your identity is never revealed.</p>
                </div>
            </div>
            
            <%-- Submit Button --%>
            <div class="pt-2">
                <button type="submit" onclick="alert('Post submitted! (Demo Mode)')" class="w-full bg-primary text-primary-foreground py-2.5 rounded-xl font-semibold text-lg shadow-lg hover:bg-primary/90 transition-colors">
                    Share with Community
                </button>
            </div>
        </form>
        
    </div>
</div>