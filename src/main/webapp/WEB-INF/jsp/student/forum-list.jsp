<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Forum</h1>
<p class="text-gray-600 mb-6">Join discussions and share experiences with the community.</p>
<div class="bg-white p-6 rounded-lg shadow-md">
    <h2 class="text-xl font-semibold mb-4">Discussion Threads</h2>
    <ul class="space-y-4">
        <c:forEach var="thread" items="${forumThreads}">
            <li class="border-b pb-4">
                <a href="/student/forum/thread" class="text-blue-600 hover:underline font-medium text-lg">
                    ${thread}
                </a>
                <p class="text-gray-500 text-sm mt-1">Click to view replies and join the discussion.</p>
            </li>
        </c:forEach>
    </ul>
</div>
<jsp:include page="../common/footer.jsp" />

