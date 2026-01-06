<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground">Self-Assessment</h1>
        <p class="text-muted-foreground">AI-guided assessment to identify areas for support</p>
    </div>

    <div class="max-w-2xl mx-auto">
        <div class="bg-card p-6 rounded-lg shadow-lg border border-border" style="--tw-bg-opacity: 1;">
            
            <c:choose>
                <c:when test="${requestScope.showResults == true}">
                    
                    <%--ASSESSMENT RESULTS UI (Uses Custom CSS Vars)--%>
                    <div class="text-center space-y-6">
                        <div class="p-6 rounded-lg" style="background-color: hsl(var(--secondary));">
                            <h3 class="text-xl font-semibold mb-4 text-card-foreground">Assessment Results</h3>
                            
                            <div class="space-y-4">
                                <div class="inline-flex items-center space-x-4">
                                    <div class="text-4xl font-bold" style="color: hsl(var(--primary));">
                                        ${requestScope.score}%
                                    </div>
                                    <div class="px-3 py-1 rounded-full ${requestScope.bg}">
                                        <span class="font-medium ${requestScope.color}">
                                            ${requestScope.level} Symptoms
                                        </span>
                                    </div>
                                </div>
                                
                                <p class="text-sm text-muted-foreground">
                                    ${requestScope.action}
                                </p>
                            </div>
                        </div>

                        <div class="flex space-x-4 justify-center">
                            <a href="/student/assessment/reset" 
                                class="border border-input text-foreground px-6 py-2.5 rounded-md hover:bg-secondary transition-colors font-medium focus:ring-2 focus:ring-ring focus:ring-offset-2">
                                Retake Assessment
                            </a>
                            <a href="/student/library" 
                                class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-opacity font-medium shadow-sm">
                                Explore Resources
                            </a>
                        </div>
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                    
                    <%-- QUESTION DISPLAY UI (Uses Custom CSS Vars) --%>
                    
                    <div class="card-header text-center">
                        <h2 class="flex items-center justify-center text-2xl font-semibold mb-2 text-card-foreground">
                            <i data-lucide="heart" class="w-6 h-6 mr-2" style="color: hsl(330 55% 60%);"></i>
                            Mental Health Self-Assessment
                        </h2>
                        <div class="space-y-2 text-sm text-muted-foreground">
                            <p>This validated assessment helps identify areas for support.</p>
                        </div>
                    </div>
                    
                    <form method="POST" action="/student/assessment/submit" class="space-y-6 mt-6">
                        <input type="hidden" name="currentQuestionIndex" value="${requestScope.currentQuestionIndex}">
                        
                        <c:set var="total" value="${requestScope.totalQuestions}" />
                        <c:set var="current" value="${requestScope.currentQuestionIndex}" />
                        <c:set var="progress" value="${(current / total) * 100}" />

                        <div class="space-y-2">
                            <div class="flex justify-between text-sm text-muted-foreground">
                                <span>Question ${current + 1} of ${total}</span>
                                <span><fmt:formatNumber value="${progress}" pattern="0" />% Complete</span>
                            </div>
                            <div class="progress h-2 rounded-full" style="background-color: hsl(var(--muted));">
                                <div class="progress-bar h-full rounded-full" style="width: ${progress}%; background-color: hsl(var(--primary));" role="progressbar" aria-valuenow="${progress}" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>

                        <%-- Question --%>
                        <div class="text-center py-8">
                            <h3 class="text-lg font-medium mb-6 leading-relaxed text-card-foreground">
                                ${requestScope.currentQuestion}
                            </h3>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <c:forEach var="option" items="${requestScope.responseOptions}" varStatus="loop">
                                    <c:set var="uniqueId" value="option_${option.value}"/>
                                    
                                    
                                    <label for="${uniqueId}" 
                                        class="h-auto p-4 text-center cursor-pointer border rounded-lg transition-all 
                                        text-card-foreground border-input 
                                        hover:bg-secondary hover:border-primary 
                                        has-[:checked]:bg-primary has-[:checked]:text-primary-foreground has-[:checked]:border-primary">
                                        
                                        <input type="radio" class="hidden" name="response" id="${uniqueId}" value="${option.value}" required>

                                        <div class="w-full">
                                            <div class="font-medium">${option.value}</div>
                                            <div class="text-xs mt-1">${option.label}</div>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <%-- Navigation --%>
                        <div class="flex justify-between pt-4">
                            <%-- Previous Button --%>
                            <button type="submit" name="direction" value="previous"
                                class="text-foreground px-4 py-2 hover:bg-muted rounded-md transition-colors"
                                <c:if test="${current == 0}">disabled</c:if>>
                                Previous
                            </button>
                            
                            <%-- Next/Complete Button --%>
                            <button type="submit" name="direction" value="next"
                                class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-opacity font-medium shadow-sm">
                                <c:choose>
                                    <c:when test="${current + 1 == total}">
                                        Complete Assessment
                                    </c:when>
                                    <c:otherwise>
                                        Next Question 
                                        <i data-lucide="arrow-right" class="w-4 h-4 ml-1 inline-block"></i>
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </form>
                    
                </c:otherwise>
            </c:choose>
            
        </div>
    </div>
</div>

<%-- HIGH-RISK CONSENT DIALOG--%>

<c:if test="${requestScope.showConsentDialog == true}">
    <div class="fixed inset-0 z-50 bg-background/80 flex items-center justify-center backdrop-blur-sm" 
         style="background-color: hsla(var(--background), 0.8);">
        
        <%-- Dialog Content --%>
        <div class="w-full max-w-md bg-card p-6 rounded-lg shadow-2xl animate-in fade-in zoom-in-95" 
             style="border: 1px solid hsl(var(--border)); background-color: hsl(var(--card));">
            
            <div class="space-y-4">
                <h3 class="flex items-center text-lg font-semibold text-card-foreground">
                    <i data-lucide="alert-triangle" class="w-5 h-5 mr-2" style="color: hsl(0 84.2% 60.2%);"></i>
                    Additional Support Available
                </h3>
                
                <p class="text-sm text-card-foreground">
                    Your assessment indicates you may benefit from additional professional support. 
                    Would you like us to share your results with a counselor who can provide personalized guidance?
                </p>
                
                <div class="p-3 rounded-md" style="background-color: hsl(var(--secondary));">
                    <p class="text-xs" style="color: hsl(var(--primary));">
                        🔒 Your privacy is important. Sharing is optional and you can withdraw consent at any time.
                    </p>
                </div>
                
                <div class="flex space-x-3 pt-2">
                    <%-- Yes Button --%>
                    <a href="/student/assessment/consent?share=true" 
                        class="flex-1 bg-primary text-primary-foreground text-center px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium shadow-sm">
                        Yes, Share Results
                    </a>
                    <%-- No Button --%>
                    <a href="/student/assessment/consent?share=false" 
                        class="flex-1 border border-input text-foreground text-center px-4 py-2 rounded-md hover:bg-secondary transition-colors font-medium">
                        Keep Private
                    </a>
                </div>
            </div>
        </div>
    </div>
</c:if>

<%-- Script to initialize Lucide/Feather icons --%>
<script>
    if (typeof feather !== 'undefined') {
        feather.replace();
    }
</script>

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />