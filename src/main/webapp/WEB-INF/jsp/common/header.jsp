<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentUrl" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MindMate</title>
    
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>

    <script>
        tailwind.config = {
            darkMode: ["class"],
            theme: {
                extend: {
                    colors: {
                        border: "hsl(var(--border))",
                        input: "hsl(var(--input))",
                        ring: "hsl(var(--ring))",
                        background: "hsl(var(--background))",
                        foreground: "hsl(var(--foreground))",
                        primary: {
                            DEFAULT: "hsl(var(--primary))",
                            foreground: "hsl(var(--primary-foreground))",
                        },
                        secondary: {
                            DEFAULT: "hsl(var(--secondary))",
                            foreground: "hsl(var(--secondary-foreground))",
                        },
                        destructive: {
                            DEFAULT: "hsl(var(--destructive))",
                            foreground: "hsl(var(--destructive-foreground))",
                        },
                        muted: {
                            DEFAULT: "hsl(var(--muted))",
                            foreground: "hsl(var(--muted-foreground))",
                        },
                        card: {
                            DEFAULT: "hsl(var(--card))",
                            foreground: "hsl(var(--card-foreground))",
                        },
                    },
                    borderRadius: {
                        lg: "var(--radius)",
                        md: "calc(var(--radius) - 2px)",
                        sm: "calc(var(--radius) - 4px)",
                    },
                },
            },
        }
    </script>
</head>
<body class="bg-background text-foreground font-sans antialiased min-h-screen flex flex-col">
    
    <nav class="bg-card/80 backdrop-blur-md border-b border-border sticky top-0 z-50 w-full">
        <div class="container mx-auto px-4 py-3">
            <div class="flex items-center justify-between">
                
                <div class="flex items-center space-x-2">
                    <a href="${role == 'counselor' ? '/counselor/dashboard' : (role == 'admin' ? '/admin/dashboard' : '/student/dashboard')}" 
                       class="flex items-center gap-2 group">
                        <img src="${pageContext.request.contextPath}/images/MindMate.png" 
                             alt="Logo" 
                             class="h-10 w-10 object-contain logo-mindmate">
                        <span class="text-xl font-bold text-foreground tracking-tight">MindMate</span>
                    </a>
                </div>

                <!-- Desktop Navigation -->
                <div class="hidden md:flex items-center space-x-1">
                    
                    <!-- STUDENT NAVIGATION  -->
                    <c:if test="${role == 'student' || role == null}">
                        <a href="/student/dashboard" 
                           class="${fn:contains(currentUrl, '/student/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="home" class="w-4 h-4"></i>
                            Dashboard
                        </a>
                        
                        <a href="/student/assessment" 
                           class="${fn:contains(currentUrl, '/student/assessment') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="heart" class="w-4 h-4"></i>
                            Self-Check
                        </a>
                        
                        <a href="/student/library" 
                           class="${fn:contains(currentUrl, '/student/library') || fn:contains(currentUrl, 'content') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="book-open" class="w-4 h-4"></i>
                            Learning
                        </a>
                        
                        <a href="/student/forum" 
                           class="${fn:contains(currentUrl, '/student/forum') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="message-circle" class="w-4 h-4"></i>
                            Community
                        </a>
                        
                        <a href="/student/telehealth" 
                           class="${fn:contains(currentUrl, '/student/telehealth') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="calendar" class="w-4 h-4"></i>
                            Sessions
                        </a>
                        
                        <a href="/student/profile" 
                           class="${fn:contains(currentUrl, '/student/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="user" class="w-4 h-4"></i>
                            My Profile
                        </a>
                    </c:if>

                    <!-- COUNSELOR NAVIGATION -->
                    <c:if test="${role == 'counselor'}">
                        <a href="/counselor/dashboard" 
                           class="${fn:contains(currentUrl, '/counselor/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="home" class="w-4 h-4"></i>
                            Dashboard
                        </a>
                        
                        <a href="/counselor/schedule" 
                           class="${fn:contains(currentUrl, '/counselor/schedule') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="calendar" class="w-4 h-4"></i>
                            My Schedule
                        </a>
                        
                        <a href="/counselor/content" 
                           class="${fn:contains(currentUrl, '/counselor/content') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="file-text" class="w-4 h-4"></i>
                            Content Manager
                        </a>
                        
                        <a href="/counselor/profile" 
                           class="${fn:contains(currentUrl, '/counselor/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="user" class="w-4 h-4"></i>
                            My Profile
                        </a>
                    </c:if>

                    <!-- ADMIN NAVIGATION -->
                    <c:if test="${role == 'admin'}">
                        <a href="/admin/dashboard" 
                           class="${fn:contains(currentUrl, '/admin/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="home" class="w-4 h-4"></i>
                            Dashboard
                        </a>
                        
                        <a href="/admin/forum-moderation" 
                           class="${fn:contains(currentUrl, '/admin/forum') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="shield" class="w-4 h-4"></i>
                            Forum Moderation
                        </a>
                        
                        <a href="/admin/profile" 
                           class="${fn:contains(currentUrl, '/admin/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-muted-foreground hover:bg-secondary hover:text-foreground'} inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <i data-lucide="user" class="w-4 h-4"></i>
                            My Profile
                        </a>
                    </c:if>

                    <!-- Logout Button -->
                    <a href="/logout" 
                       class="inline-flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium text-destructive hover:bg-destructive/10 transition-colors ml-2">
                        <i data-lucide="log-out" class="w-4 h-4"></i>
                        Logout
                    </a>
                </div>

                <!-- Mobile Navigation -->
                <div class="md:hidden flex items-center gap-2">
                    <a href="/logout" 
                       class="inline-flex items-center gap-1 px-2 py-1.5 rounded-md text-sm font-medium text-destructive hover:bg-destructive/10 transition-colors">
                        <i data-lucide="log-out" class="w-4 h-4"></i>
                    </a>
                    
                    <button id="mobile-menu-button" 
                            class="inline-flex items-center justify-center p-2 rounded-md text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors">
                        <i data-lucide="menu" class="w-5 h-5"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Menu Dropdown -->
        <div id="mobile-menu" class="hidden md:hidden border-t border-border bg-card">
            <div class="container mx-auto px-4 py-3 space-y-1">
                
                <!-- STUDENT MOBILE NAVIGATION -->
                <c:if test="${role == 'student' || role == null}">
                    <a href="/student/dashboard" 
                       class="${fn:contains(currentUrl, '/student/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Dashboard
                    </a>
                    <a href="/student/assessment" 
                       class="${fn:contains(currentUrl, '/student/assessment') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="heart" class="w-4 h-4"></i>
                        Self-Check
                    </a>
                    <a href="/student/library" 
                       class="${fn:contains(currentUrl, '/student/library') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="book-open" class="w-4 h-4"></i>
                        Learning
                    </a>
                    
                    <a href="/student/forum" 
                       class="${fn:contains(currentUrl, '/student/forum') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="message-circle" class="w-4 h-4"></i>
                        Community
                    </a>
                    
                    <a href="/student/telehealth" 
                       class="${fn:contains(currentUrl, '/student/telehealth') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="calendar" class="w-4 h-4"></i>
                        Sessions
                    </a>
                    <a href="/student/profile" 
                       class="${fn:contains(currentUrl, '/student/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="user" class="w-4 h-4"></i>
                        My Profile
                    </a>
                </c:if>

                <!-- COUNSELOR MOBILE NAVIGATION -->
                <c:if test="${role == 'counselor'}">
                    <a href="/counselor/dashboard" 
                       class="${fn:contains(currentUrl, '/counselor/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Dashboard
                    </a>
                    <a href="/counselor/schedule" 
                       class="${fn:contains(currentUrl, '/counselor/schedule') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="calendar" class="w-4 h-4"></i>
                        My Schedule
                    </a>
                    <a href="/counselor/content" 
                       class="${fn:contains(currentUrl, '/counselor/content') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="file-text" class="w-4 h-4"></i>
                        Content Manager
                    </a>
                    <a href="/counselor/profile" 
                       class="${fn:contains(currentUrl, '/counselor/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="user" class="w-4 h-4"></i>
                        My Profile
                    </a>
                </c:if>

                <!-- ADMIN MOBILE NAVIGATION -->
                <c:if test="${role == 'admin'}">
                    <a href="/admin/dashboard" 
                       class="${fn:contains(currentUrl, '/admin/dashboard') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Dashboard
                    </a>
                    <a href="/admin/forum-moderation" 
                       class="${fn:contains(currentUrl, '/admin/forum') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="shield" class="w-4 h-4"></i>
                        Forum Moderation
                    </a>
                    <a href="/admin/profile" 
                       class="${fn:contains(currentUrl, '/admin/profile') ? 'bg-primary text-primary-foreground' : 'bg-transparent text-foreground hover:bg-secondary'} flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                        <i data-lucide="user" class="w-4 h-4"></i>
                        My Profile
                    </a>
                </c:if>
            </div>
        </div>
    </nav>

    <!-- Mobile Menu Toggle Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const menuButton = document.getElementById('mobile-menu-button');
            const mobileMenu = document.getElementById('mobile-menu');
            
            if (menuButton && mobileMenu) {
                menuButton.addEventListener('click', function() {
                    mobileMenu.classList.toggle('hidden');
                });
            }
        });
    </script>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">