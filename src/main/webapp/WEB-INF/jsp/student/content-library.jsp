<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
    <div>
        <h1 class="text-3xl font-bold text-foreground">Content Library</h1>
        <p class="text-muted-foreground mt-2">Browse articles, videos, and resources to support your mental health journey.</p>
    </div>

    <div class="flex justify-center mt-6">
        <div class="flex bg-secondary p-1 rounded-full space-x-2 tab-bar-container">
            <button id="learningModulesTab" class="tab-button active-tab">
                Learning Modules
            </button>
            <button id="myProgressTab" class="tab-button">
                My Progress
            </button>
        </div>
    </div>
    <div id="learningModulesSection" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full learning-card">
            <div class="mb-4 flex-grow">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="brain-circuit" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Understanding Anxiety</h3>
                <p class="text-muted-foreground text-sm">Learn about anxiety and effective coping strategies.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full learning-card">
             <div class="mb-4 flex-grow">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="leaf" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Stress Management Techniques</h3>
                <p class="text-muted-foreground text-sm">Practical tips for managing daily stress.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>

        <div class="bg-card p-6 rounded-lg shadow-sm border border-border hover:shadow-md transition-shadow flex flex-col h-full learning-card">
             <div class="mb-4 flex-grow">
                <div class="p-3 bg-secondary w-fit rounded-full mb-3">
                    <i data-lucide="shield-check" class="h-6 w-6 text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-2 text-foreground">Building Resilience</h3>
                <p class="text-muted-foreground text-sm">Develop resilience to overcome life's challenges.</p>
            </div>
            <div class="mt-auto pt-4">
                <a href="/student/library/view" class="text-primary font-medium hover:text-primary/80 hover:underline inline-flex items-center gap-1 transition-colors">
                    Read More <i data-lucide="arrow-right" class="h-4 w-4"></i>
                </a>
            </div>
        </div>
    </div>
    <div id="myProgressSection" class="hidden space-y-8 py-4">

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border text-center">
                <div class="text-primary mx-auto mb-3">
                    <i data-lucide="award" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-3xl font-bold text-foreground">3</p>
                <p class="text-sm text-muted-foreground mt-1">Modules Completed</p>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border text-center">
                <div class="text-green-600 mx-auto mb-3">
                    <i data-lucide="star" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-3xl font-bold text-foreground">350</p>
                <p class="text-sm text-muted-foreground mt-1">Points Earned</p>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border text-center">
                <div class="text-blue-500 mx-auto mb-3">
                    <i data-lucide="trending-up" class="h-10 w-10 mx-auto"></i>
                </div>
                <p class="text-3xl font-bold text-foreground">7 day</p>
                <p class="text-sm text-muted-foreground mt-1">Learning Streak</p>
            </div>

        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <h3 class="text-xl font-bold text-green-600 mb-4 flex items-center gap-2">
                    <i data-lucide="check-circle" class="h-6 w-6"></i>
                    Completed Modules
                </h3>
                <div class="space-y-3">
                    
                    <div class="flex justify-between items-center border-b border-secondary pb-3 last:border-b-0">
                        <div class="flex items-center gap-3">
                            <i data-lucide="leaf" class="h-5 w-5 text-primary"></i>
                            <span class="font-medium text-foreground">Stress Management Techniques</span>
                        </div>
                        <span class="text-sm text-green-600 font-semibold">Done</span>
                    </div>
                    
                    <div class="flex justify-between items-center border-b border-secondary pb-3 last:border-b-0">
                        <div class="flex items-center gap-3">
                            <i data-lucide="shield-check" class="h-5 w-5 text-primary"></i>
                            <span class="font-medium text-foreground">Building Resilience</span>
                        </div>
                        <span class="text-sm text-green-600 font-semibold">Done</span>
                    </div>
                    
                </div>
                
                <p class="text-sm text-muted-foreground mt-4 italic">Successfully completed your learning goals.</p>
            </div>

            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <h3 class="text-xl font-bold text-primary mb-4 flex items-center gap-2">
                    <i data-lucide="refresh-cw" class="h-6 w-6"></i>
                    Modules In Progress
                </h3>
                <div class="space-y-3">
                    
                    <div class="flex justify-between items-center border-b border-secondary pb-3 last:border-b-0">
                        <div class="flex items-center gap-3">
                            <i data-lucide="brain-circuit" class="h-5 w-5 text-primary"></i>
                            <span class="font-medium text-foreground">Understanding Anxiety</span>
                        </div>
                        <a href="/student/library/view" class="text-sm text-primary hover:underline font-medium">Continue</a>
                    </div>
                    
                    <div class="flex justify-between items-center border-b border-secondary pb-3 last:border-b-0">
                        <div class="flex items-center gap-3">
                            <i data-lucide="heart" class="h-5 w-5 text-primary"></i>
                            <span class="font-medium text-foreground">Sleep Hygiene Workshop</span>
                        </div>
                        <a href="/student/library/view" class="text-sm text-primary hover:underline font-medium">Start Now</a>
                    </div>
                    
                </div>
                
                <p class="text-sm text-muted-foreground mt-4 italic">Click 'Continue' or 'Start Now' to proceed.</p>
            </div>
        </div>
    </div>
    </div>
</div>

<jsp:include page="chatbot-widget.jsp" /> 

<script>
    // Initialize Lucide icons when page loads
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // START: Tab Switching Logic
    const learningModulesTab = document.getElementById('learningModulesTab');
    const myProgressTab = document.getElementById('myProgressTab');
    const learningModulesSection = document.getElementById('learningModulesSection');
    const myProgressSection = document.getElementById('myProgressSection');

    // Utility function to set active tab styles
    function setActiveTab(activeTab, inactiveTab) {
        activeTab.classList.add('active-tab');
        inactiveTab.classList.remove('active-tab');
    }

    // Tab click listeners
    learningModulesTab.addEventListener('click', () => {
        // Show Learning Modules and Hide Progress
        learningModulesSection.classList.remove('hidden');
        myProgressSection.classList.add('hidden');
        setActiveTab(learningModulesTab, myProgressTab);
        
        // Re-initialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    });

    myProgressTab.addEventListener('click', () => {
        // Show Progress and Hide Learning Modules
        learningModulesSection.classList.add('hidden');
        myProgressSection.classList.remove('hidden');
        setActiveTab(myProgressTab, learningModulesTab);
        
        // Re-initialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    });
</script>

<style>
    /* Custom styles for the new pill-shaped tab bar */
    .tab-bar-container {
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }
    
    .tab-button {
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        font-weight: 500;
        text-align: center;
        color: hsl(var(--foreground));
        background: transparent;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        outline: none;
    }
    
    .tab-button.active-tab {
        background: hsl(var(--card));
        color: hsl(var(--foreground));
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1); 
    }
</style>

<jsp:include page="../common/footer.jsp" />