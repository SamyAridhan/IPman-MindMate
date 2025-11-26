<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">Assessment Questions</h1>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <form method="POST" action="/student/assessment/submit" class="space-y-8">
            
            <div>
                <label class="block text-lg font-medium mb-4 text-foreground">Question 1: How often do you feel anxious?</label>
                <div class="space-y-3">
                    <label class="flex items-center cursor-pointer">
                        <input type="radio" name="q1" value="never" class="mr-3 h-4 w-4 accent-primary text-primary focus:ring-primary border-input"> 
                        <span class="text-foreground">Never</span>
                    </label>
                    <label class="flex items-center cursor-pointer">
                        <input type="radio" name="q1" value="rarely" class="mr-3 h-4 w-4 accent-primary text-primary focus:ring-primary border-input"> 
                        <span class="text-foreground">Rarely</span>
                    </label>
                    <label class="flex items-center cursor-pointer">
                        <input type="radio" name="q1" value="sometimes" class="mr-3 h-4 w-4 accent-primary text-primary focus:ring-primary border-input"> 
                        <span class="text-foreground">Sometimes</span>
                    </label>
                    <label class="flex items-center cursor-pointer">
                        <input type="radio" name="q1" value="often" class="mr-3 h-4 w-4 accent-primary text-primary focus:ring-primary border-input"> 
                        <span class="text-foreground">Often</span>
                    </label>
                    <label class="flex items-center cursor-pointer">
                        <input type="radio" name="q1" value="always" class="mr-3 h-4 w-4 accent-primary text-primary focus:ring-primary border-input"> 
                        <span class="text-foreground">Always</span>
                    </label>
                </div>
            </div>

            <button type="submit" class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring shadow-sm">
                Submit Assessment
            </button>
        </form>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />