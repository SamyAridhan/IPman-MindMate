<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <div>
        <a href="/student/forum" class="text-muted-foreground hover:text-foreground inline-flex items-center gap-2 transition-colors text-sm font-medium mb-4">
            <i data-lucide="arrow-left" class="h-4 w-4"></i>
            Back to Forum
        </a>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        
        <div class="mb-8">
            <div class="flex items-start justify-between mb-4">
                <div>
                    <h1 class="text-2xl font-bold text-foreground mb-1">Thread Title</h1>
                    <div class="flex items-center gap-2 text-sm text-muted-foreground">
                        <div class="bg-secondary p-1 rounded-full">
                            <i data-lucide="user" class="h-3 w-3 text-primary"></i>
                        </div>
                        <span>Posted by: User123 • 2 days ago</span>
                    </div>
                </div>
                <span class="px-2.5 py-0.5 bg-secondary text-primary text-xs font-semibold rounded-full border border-primary/20">Discussion</span>
            </div>
            
            <div class="border-b border-border pb-6">
                <p class="text-foreground leading-relaxed text-lg">Original post content will be displayed here...</p>
            </div>
        </div>

        <div class="space-y-6">
            <h3 class="text-xl font-semibold text-foreground flex items-center gap-2">
                <i data-lucide="message-square" class="h-5 w-5 text-primary"></i>
                Replies
            </h3>
            
            <div class="space-y-4">
                <div class="bg-secondary/20 p-5 rounded-lg border border-border/50">
                    <div class="flex items-center gap-2 mb-3">
                        <span class="font-semibold text-foreground text-sm">Reply Author</span>
                        <span class="text-xs text-muted-foreground">• 1 day ago</span>
                    </div>
                    <p class="text-muted-foreground leading-relaxed">Reply content will be displayed here...</p>
                </div>
            </div>
        </div>

        <div class="mt-8 pt-6 border-t border-border">
            <h3 class="text-lg font-semibold mb-4 text-foreground">Post a Reply</h3>
            <form method="POST" action="/student/forum/thread/reply" class="space-y-4">
                <textarea name="reply" rows="4" 
                          class="w-full px-4 py-3 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground shadow-sm resize-y" 
                          placeholder="Write your reply..."></textarea>
                
                <button type="submit" class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring shadow-sm">
                    Post Reply
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />