<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Content Manager</h1>
<div class="mb-6">
    <a href="/counselor/content/new" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 inline-block">
        Create New Content
    </a>
</div>
<div class="bg-white p-6 rounded-lg shadow-md">
    <h2 class="text-xl font-semibold mb-4">Published Content</h2>
    <div class="space-y-4">
        <div class="border-b pb-4">
            <h3 class="text-lg font-semibold">Understanding Anxiety</h3>
            <p class="text-gray-600 text-sm mb-2">Published on: January 1, 2024</p>
            <div class="flex space-x-2">
                <button class="bg-blue-600 text-white px-3 py-1 rounded-md hover:bg-blue-700 text-sm">
                    Edit
                </button>
                <button class="bg-red-600 text-white px-3 py-1 rounded-md hover:bg-red-700 text-sm">
                    Delete
                </button>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

