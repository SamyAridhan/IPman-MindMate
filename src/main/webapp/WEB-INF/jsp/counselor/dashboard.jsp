<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="min-h-screen pb-20">
    <section class="pt-24 pb-12 px-6">
        <div class="max-w-4xl mx-auto text-center space-y-6 animate-fade-in">
            <span class="px-3 py-1 rounded-full bg-primary/10 text-primary text-sm font-medium inline-block">
                Welcome to MindMate
            </span>
            <h1 class="text-4xl md:text-6xl font-bold text-foreground tracking-tight">
                Your Journey to <br />
                <span class="text-primary">Mental Wellness</span> Starts Here
            </h1>
            <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
                A safe space for students to access support, track their well-being, and connect with professionals.
            </p>
        </div>
    </section>

    <section class="px-6 py-12">
        <div class="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            
            <a href="/student/assessment" class="group relative overflow-hidden p-6 rounded-2xl bg-card hover:shadow-xl transition-all duration-300 border border-border/50 hover:border-primary/20">
                <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                    <i data-lucide="clipboard-check" class="w-24 h-24 text-primary"></i>
                </div>
                <div class="relative space-y-4">
                    <div class="p-3 bg-primary/10 w-fit rounded-xl">
                        <i data-lucide="clipboard-check" class="w-6 h-6 text-primary"></i>
                    </div>
                    <h3 class="text-xl font-semibold">Self Assessment</h3>
                    <p class="text-muted-foreground text-sm">Track your mental well-being with our guided assessment tools.</p>
                </div>
            </a>

            <a href="/student/library" class="group relative overflow-hidden p-6 rounded-2xl bg-white hover:shadow-xl transition-all duration-300 border border-border/50 hover:border-primary/20">
                <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                    <i data-lucide="book-open" class="w-24 h-24 text-primary"></i>
                </div>
                <div class="relative space-y-4">
                    <div class="p-3 bg-primary/10 w-fit rounded-xl">
                        <i data-lucide="book-open" class="w-6 h-6 text-primary"></i>
                    </div>
                    <h3 class="text-xl font-semibold">Resource Library</h3>
                    <p class="text-muted-foreground text-sm">Access curated articles and videos to support your journey.</p>
                </div>
            </a>

            <a href="/student/telehealth" class="group relative overflow-hidden p-6 rounded-2xl bg-white hover:shadow-xl transition-all duration-300 border border-border/50 hover:border-primary/20">
                <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                    <i data-lucide="video" class="w-24 h-24 text-primary"></i>
                </div>
                <div class="relative space-y-4">
                    <div class="p-3 bg-primary/10 w-fit rounded-xl">
                        <i data-lucide="video" class="w-6 h-6 text-primary"></i>
                    </div>
                    <h3 class="text-xl font-semibold">Telehealth</h3>
                    <p class="text-muted-foreground text-sm">Connect with counselors for professional support sessions.</p>
                </div>
            </a>

            <a href="/student/forum" class="group relative overflow-hidden p-6 rounded-2xl bg-white hover:shadow-xl transition-all duration-300 border border-border/50 hover:border-primary/20">
                <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                    <i data-lucide="users" class="w-24 h-24 text-primary"></i>
                </div>
                <div class="relative space-y-4">
                    <div class="p-3 bg-primary/10 w-fit rounded-xl">
                        <i data-lucide="users" class="w-6 h-6 text-primary"></i>
                    </div>
                    <h3 class="text-xl font-semibold">Community</h3>
                    <p class="text-muted-foreground text-sm">Join the discussion and find peer support.</p>
                </div>
            </a>

        </div>
    </section>
</div>

<jsp:include page="../common/footer.jsp" />