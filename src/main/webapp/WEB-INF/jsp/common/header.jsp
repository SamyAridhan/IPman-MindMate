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
    
    <nav class="sticky top-0 z-50 w-full border-b border-border bg-white/80 backdrop-blur-md supports-[backdrop-filter]:bg-white/60">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <div class="shrink-0 flex items-center">
                        <a href="${role == 'counselor' ? '/counselor/dashboard' : (role == 'admin' ? '/admin/dashboard' : '/student/dashboard')}" 
                           class="flex items-center gap-2 group">
                            
                            <img src="${pageContext.request.contextPath}/images/MindMate.png" 
                                 alt="Logo" 
                                 class="h-10 w-10 object-contain logo-mindmate">
                            
                            <span class="text-xl font-bold text-foreground tracking-tight">MindMate</span>
                        </a>
                    </div>
    
                    <c:if test="${role == 'student' || role == null}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/student/dashboard" 
                               class="${fn:contains(currentUrl, '/student/dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Dashboard
                            </a>
                            
                            <a href="/student/assessment" 
                               class="${fn:contains(currentUrl, '/student/assessment') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Assessment
                            </a>
                            
                            <a href="/student/library" 
                               class="${fn:contains(currentUrl, '/student/library') || fn:contains(currentUrl, 'content') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Library
                            </a>
                            
                            <a href="/student/telehealth" 
                               class="${fn:contains(currentUrl, '/student/telehealth') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Telehealth
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'counselor'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/counselor/dashboard" 
                               class="${fn:contains(currentUrl, '/counselor/dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Dashboard
                            </a>
                            <a href="/counselor/schedule" 
                               class="${fn:contains(currentUrl, '/counselor/schedule') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Schedule
                            </a>
                            <a href="/counselor/content" 
                               class="${fn:contains(currentUrl, '/counselor/content') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Content
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'admin'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/admin/dashboard" 
                               class="${fn:contains(currentUrl, '/admin/dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors">
                               Analytics
                            </a>
                        </div>
                    </c:if>
                </div>
                
                <div class="flex items-center">
                    <a href="/logout" class="text-sm font-medium text-destructive hover:text-red-700 transition-colors">Logout</a>
                </div>
            </div>
        </div>
    </nav>
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 flex-grow w-full">