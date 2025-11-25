<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Assessment Questions</h1>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <form method="POST" action="/student/assessment/submit" class="space-y-6">
        <div>
            <label class="block text-lg font-medium mb-2 text-foreground">Question 1: How often do you feel anxious?</label>
            <div class="space-y-2">
                <label class="flex items-center text-foreground"><input type="radio" name="q1" value="never" class="mr-2"> Never</label>
                <label class="flex items-center text-foreground"><input type="radio" name="q1" value="rarely" class="mr-2"> Rarely</label>
                <label class="flex items-center text-foreground"><input type="radio" name="q1" value="sometimes" class="mr-2"> Sometimes</label>
                <label class="flex items-center text-foreground"><input type="radio" name="q1" value="often" class="mr-2"> Often</label>
                <label class="flex items-center text-foreground"><input type="radio" name="q1" value="always" class="mr-2"> Always</label>
            </div>
        </div>
        <button type="submit" class="bg-primary text-primary-foreground px-6 py-2 rounded-lg hover:bg-primary/90 transition-all duration-300">
            Submit Assessment
        </button>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />

