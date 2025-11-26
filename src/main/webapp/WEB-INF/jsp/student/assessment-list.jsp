<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <div>
        <h1 class="text-3xl font-bold text-foreground">Assessment List</h1>
        <p class="text-muted-foreground mt-2">Select an assessment to begin or view your previous results.</p>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <h2 class="text-xl font-semibold mb-6 text-foreground">Available Assessments</h2>
        
        <ul class="space-y-4">
            <li class="border-b border-border pb-4 last:border-0 last:pb-0">
                <div class="flex items-start gap-4">
                    <div class="p-2 bg-secondary rounded-full mt-1 shrink-0">
                        <i data-lucide="clipboard-list" class="h-5 w-5 text-primary"></i>
                    </div>
                    
                    <div>
                        <a href="/student/assessment/take" class="text-lg font-medium text-primary hover:text-primary/80 hover:underline transition-colors">
                            Mental Health Screening Assessment
                        </a>
                        <p class="text-muted-foreground text-sm mt-1">A comprehensive assessment to evaluate your mental health status.</p>
                    </div>
                    
                    <div class="ml-auto hidden sm:block">
                        <a href="/student/assessment/take" class="bg-primary text-primary-foreground px-4 py-2 rounded-md text-sm font-medium hover:opacity-90 transition-opacity">
                            Start
                        </a>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />