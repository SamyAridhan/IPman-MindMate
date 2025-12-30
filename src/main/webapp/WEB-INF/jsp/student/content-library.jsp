<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
<div>
<h1 class="text-3xl font-bold text-foreground">Content Library</h1>
<p class="text-muted-foreground mt-2">Browse articles, videos, and resources to support your mental health journey.</p>
</div>

    <!-- Tab Bar -->
    <div class="flex justify-center mt-6">
        <div class="flex bg-secondary p-1 rounded-full space-x-2 tab-bar-container border border-border/50">
            <button id="learningModulesTab" class="tab-button active-tab">
                Learning Modules
            </button>
            <button id="myProgressTab" class="tab-button">
                My Progress
            </button>
        </div>
    </div>

    <!-- Learning Modules Section -->
    <div id="learningModulesSection" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <c:forEach var="item" items="${modules}">
            <%-- Logic to check if this specific module is completed --%>
            <c:set var="isDone" value="false" />
            <c:forEach var="p" items="${progressList}">
                <c:if test="${p.content.id == item.id && p.completed}">
                    <c:set var="isDone" value="true" />
                </c:if>
            </c:forEach>

            <div class="bg-card p-6 rounded-xl shadow-sm border border-border hover:shadow-lg hover:border-primary/20 transition-all duration-300 flex flex-col h-full learning-card relative group">
                
                <!-- Completed Badge -->
                <c:if test="${isDone}">
                    <div class="absolute top-4 right-4 z-10">
                        <span class="bg-green-100 text-green-700 text-[10px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1 uppercase tracking-wider border border-green-200 shadow-sm">
                            <i data-lucide="check-circle" class="h-3 w-3"></i> Completed
                        </span>
                    </div>
                </c:if>

                <div class="mb-4 flex-grow">
                    <!-- Icon and Points Area -->
                    <div class="flex justify-between items-center mb-4">
                        <div class="p-3 bg-primary/10 w-fit rounded-xl group-hover:bg-primary/20 transition-colors">
                            <c:choose>
                                <c:when test="${item.contentType == 'Video'}">
                                    <i data-lucide="play-circle" class="h-6 w-6 text-primary"></i>
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="file-text" class="h-6 w-6 text-primary"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Points Visibility -->
                        <div class="flex items-center gap-1.5 px-3 py-1 bg-secondary rounded-lg text-xs font-bold text-foreground">
                            <i data-lucide="sparkles" class="h-3.5 w-3.5 text-yellow-500"></i>
                            ${item.pointsValue} Pts
                        </div>
                    </div>

                    <h3 class="text-xl font-bold mb-2 text-foreground group-hover:text-primary transition-colors">${item.title}</h3>
                    <p class="text-muted-foreground text-sm line-clamp-2 leading-relaxed">${item.description}</p>
                </div>

                <!-- Beautiful Link Button -->
                <div class="mt-auto pt-4">
                    <a href="${pageContext.request.contextPath}/student/view-module?id=${item.id}" 
                       class="w-full flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg font-semibold transition-all duration-200 
                       ${isDone ? 'bg-secondary text-foreground hover:bg-secondary/80' : 'bg-primary text-primary-foreground shadow-sm hover:shadow-md hover:translate-y-[-1px] active:translate-y-0'}">
                        <span>${isDone ? 'Review Module' : 'Start Learning'}</span>
                    </a>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty modules}">
            <div class="col-span-full py-20 text-center text-muted-foreground bg-secondary/20 rounded-xl border-2 border-dashed border-border">
                <i data-lucide="book-open" class="h-12 w-12 mx-auto mb-4 opacity-20"></i>
                <p class="text-lg font-medium">No learning modules available yet.</p>
                <p class="text-sm">Check back later for new resources.</p>
            </div>
        </c:if>
    </div>

    <!-- My Progress Section (Stats and Lists) -->
    <div id="myProgressSection" class="hidden space-y-8 py-4">
        <!-- Stats Row -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
            <div class="bg-card p-6 rounded-xl shadow-sm border border-border text-center">
                <div class="text-primary mx-auto mb-3">
                    <i data-lucide="award" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-4xl font-black text-foreground">
                    <c:set var="completedCount" value="0" />
                    <c:forEach var="p" items="${progressList}">
                        <c:if test="${p.completed}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
                    </c:forEach>
                    ${completedCount}
                </p>
                <p class="text-sm font-medium text-muted-foreground mt-1">Modules Completed</p>
            </div>

            <div class="bg-card p-6 rounded-xl shadow-sm border border-border text-center">
                <div class="text-green-600 mx-auto mb-3">
                    <i data-lucide="star" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-4xl font-black text-foreground">${student.totalPoints != null ? student.totalPoints : 0}</p>
                <p class="text-sm font-medium text-muted-foreground mt-1">Total Points</p>
            </div>

            <div class="bg-card p-6 rounded-xl shadow-sm border border-border text-center">
                <div class="text-orange-500 mx-auto mb-3">
                    <i data-lucide="flame" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-4xl font-black text-foreground">${student.currentStreak != null ? student.currentStreak : 0}</p>
                <p class="text-sm font-medium text-muted-foreground mt-1">Day Streak</p>
            </div>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Completed Modules List -->
            <div class="bg-card p-6 rounded-xl shadow-sm border border-border">
                <h3 class="text-xl font-bold text-green-600 mb-6 flex items-center gap-2">
                    <i data-lucide="check-circle" class="h-6 w-6"></i>
                    Completed Modules
                </h3>
                <div class="space-y-4">
                    <c:forEach var="p" items="${progressList}">
                        <c:if test="${p.completed}">
                            <div class="flex justify-between items-center bg-secondary/30 p-3 rounded-lg border border-transparent hover:border-green-200 transition-all">
                                <div class="flex items-center gap-3">
                                    <div class="h-8 w-8 rounded-full bg-green-100 flex items-center justify-center">
                                        <i data-lucide="file-check" class="h-4 w-4 text-green-600"></i>
                                    </div>
                                    <span class="font-semibold text-foreground text-sm">${p.content.title}</span>
                                </div>
                                <span class="text-[10px] font-bold text-green-600 bg-green-50 px-2 py-1 rounded">DONE</span>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${completedCount == 0}">
                         <div class="text-center py-8 text-muted-foreground">
                            <p class="text-sm italic">You haven't completed any modules yet.</p>
                         </div>
                    </c:if>
                </div>
            </div>

            <!-- Available List -->
            <div class="bg-card p-6 rounded-xl shadow-sm border border-border">
                <h3 class="text-xl font-bold text-primary mb-6 flex items-center gap-2">
                    <i data-lucide="refresh-cw" class="h-6 w-6"></i>
                    Next to Learn
                </h3>
                <div class="space-y-4">
                    <c:forEach var="item" items="${modules}">
                        <c:set var="isDone" value="false" />
                        <c:forEach var="p" items="${progressList}">
                            <c:if test="${p.content.id == item.id && p.completed}"><c:set var="isDone" value="true" /></c:if>
                        </c:forEach>
                        
                        <c:if test="${!isDone}">
                            <div class="flex justify-between items-center bg-secondary/30 p-3 rounded-lg border border-transparent hover:border-primary/20 transition-all group">
                                <div class="flex items-center gap-3">
                                    <div class="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
                                        <i data-lucide="book-open" class="h-4 w-4 text-primary"></i>
                                    </div>
                                    <span class="font-semibold text-foreground text-sm">${item.title}</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/student/view-module?id=${item.id}" 
                                   class="text-xs font-bold text-primary hover:underline flex items-center gap-1 group-hover:translate-x-1 transition-transform">
                                    CONTINUE <i data-lucide="chevron-right" class="h-3 w-3"></i>
                                </a>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>


</div>

<jsp:include page="chatbot-widget.jsp" />

<script>
// Initialize Lucide icons
function initIcons() {
if (typeof lucide !== 'undefined') {
lucide.createIcons();
}
}

document.addEventListener('DOMContentLoaded', initIcons);

// Tab Switching Logic
const learningModulesTab = document.getElementById('learningModulesTab');
const myProgressTab = document.getElementById('myProgressTab');
const learningModulesSection = document.getElementById('learningModulesSection');
const myProgressSection = document.getElementById('myProgressSection');

function setActiveTab(activeTab, inactiveTab) {
activeTab.classList.add('active-tab');
inactiveTab.classList.remove('active-tab');
}

learningModulesTab.addEventListener('click', () => {
learningModulesSection.classList.remove('hidden');
myProgressSection.classList.add('hidden');
setActiveTab(learningModulesTab, myProgressTab);
initIcons();
});

myProgressTab.addEventListener('click', () => {
learningModulesSection.classList.add('hidden');
myProgressSection.classList.remove('hidden');
setActiveTab(myProgressTab, learningModulesTab);
initIcons();
});
</script>

<style>
.tab-bar-container { box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); }
.tab-button {
padding: 0.5rem 1.5rem;
border-radius: 9999px;
font-weight: 600;
text-align: center;
color: hsl(var(--muted-foreground));
background: transparent;
transition: all 0.2s ease;
border: none;
cursor: pointer;
outline: none;
}
.tab-button.active-tab {
background: hsl(var(--card));
color: hsl(var(--primary));
box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}
.learning-card {
transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
}
.learning-card:hover {
transform: translateY(-4px);
}
</style>

<jsp:include page="../common/footer.jsp" />