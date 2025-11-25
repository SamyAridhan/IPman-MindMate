<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Assessment List</h1>
<p class="text-muted-foreground mb-6">Select an assessment to begin or view your previous results.</p>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <h2 class="text-xl font-semibold mb-4 text-foreground">Available Assessments</h2>
    <ul class="space-y-3">
        <li class="border-b border-border pb-3">
            <a href="/student/assessment/take" class="text-primary hover:text-primary/80 hover:underline font-medium transition-colors duration-300">
                Mental Health Screening Assessment
            </a>
            <p class="text-muted-foreground text-sm mt-1">A comprehensive assessment to evaluate your mental health status.</p>
        </li>
    </ul>
</div>
<jsp:include page="../common/footer.jsp" />

