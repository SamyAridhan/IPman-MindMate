<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Forum Thread</h1>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <div class="mb-6">
        <h2 class="text-2xl font-semibold mb-2 text-foreground">Thread Title</h2>
        <p class="text-muted-foreground text-sm">Posted by: User123 • 2 days ago</p>
    </div>
    <div class="border-b border-border pb-4 mb-4">
        <p class="text-foreground leading-relaxed">Original post content will be displayed here...</p>
    </div>
    <h3 class="text-xl font-semibold mb-4 text-foreground">Replies</h3>
    <div class="space-y-4">
        <div class="bg-muted p-4 rounded-lg border border-border">
            <p class="font-medium mb-2 text-foreground">Reply Author</p>
            <p class="text-foreground">Reply content will be displayed here...</p>
        </div>
    </div>
    <div class="mt-6">
        <h3 class="text-lg font-semibold mb-3 text-foreground">Post a Reply</h3>
        <form method="POST" action="/student/forum/thread/reply" class="space-y-4">
            <textarea name="reply" rows="4" class="w-full px-3 py-2 border border-input bg-background rounded-lg focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 placeholder:text-muted-foreground" placeholder="Write your reply..."></textarea>
            <button type="submit" class="bg-primary text-primary-foreground px-6 py-2 rounded-lg hover:bg-primary/90 transition-all duration-300">
                Post Reply
            </button>
        </form>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

