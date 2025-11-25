<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Forum Thread</h1>
<div class="bg-white p-6 rounded-lg shadow-md">
    <div class="mb-6">
        <h2 class="text-2xl font-semibold mb-2">Thread Title</h2>
        <p class="text-gray-500 text-sm">Posted by: User123 • 2 days ago</p>
    </div>
    <div class="border-b pb-4 mb-4">
        <p class="text-gray-700 leading-relaxed">Original post content will be displayed here...</p>
    </div>
    <h3 class="text-xl font-semibold mb-4">Replies</h3>
    <div class="space-y-4">
        <div class="bg-gray-50 p-4 rounded-md">
            <p class="font-medium mb-2">Reply Author</p>
            <p class="text-gray-700">Reply content will be displayed here...</p>
        </div>
    </div>
    <div class="mt-6">
        <h3 class="text-lg font-semibold mb-3">Post a Reply</h3>
        <form method="POST" action="/student/forum/thread/reply" class="space-y-4">
            <textarea name="reply" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Write your reply..."></textarea>
            <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700">
                Post Reply
            </button>
        </form>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

