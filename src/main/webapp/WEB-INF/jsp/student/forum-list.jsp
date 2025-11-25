<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Forum</h1>
<p class="text-muted-foreground mb-6">Join discussions and share experiences with the community.</p>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <h2 class="text-xl font-semibold mb-4 text-foreground">Discussion Threads</h2>
    <ul class="space-y-4">
        <c:forEach var="thread" items="${forumThreads}">
            <li class="border-b border-border pb-4">
                <a href="/student/forum/thread" class="text-primary hover:text-primary/80 hover:underline font-medium text-lg transition-colors duration-300">
                    ${thread}
                </a>
                <p class="text-muted-foreground text-sm mt-1">Click to view replies and join the discussion.</p>
            </li>
        </c:forEach>
    </ul>
</div>
<jsp:include page="../common/footer.jsp" />

