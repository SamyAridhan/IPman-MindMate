<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6">Assessment List</h1>
<p class="text-gray-600 mb-6">Select an assessment to begin or view your previous results.</p>
<div class="bg-white p-6 rounded-lg shadow-md">
    <h2 class="text-xl font-semibold mb-4">Available Assessments</h2>
    <ul class="space-y-3">
        <li class="border-b pb-3">
            <a href="/student/assessment/take" class="text-blue-600 hover:underline font-medium">
                Mental Health Screening Assessment
            </a>
            <p class="text-gray-600 text-sm mt-1">A comprehensive assessment to evaluate your mental health status.</p>
        </li>
    </ul>
</div>
<jsp:include page="../common/footer.jsp" />

