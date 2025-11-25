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
    
        <script src="https://cdn.tailwindcss.com"></script>
    
        <script>
            tailwind.config = {
                darkMode: ["class"],
                theme: {
                    container: {
                        center: true,
                        padding: "2rem",
                        screens: { "2xl": "1400px" },
                    },
                    extend: {
                        colors: {
                            // Base Colors - Matching React Prototype
                            border: "hsl(337 20% 90%)",
                            input: "hsl(337 20% 90%)",
                            ring: "hsl(325 96% 90%)",
                            background: "hsl(340 100% 98%)", // Very pale pink #FFF5F9
                            foreground: "hsl(320 8% 44%)", // Dark desaturated mauve
    
                            // Main Brand Colors - Soft Pink/Mauve
                            primary: {
                                DEFAULT: "hsl(325 96% 90%)", // Soft pink/mauve
                                foreground: "hsl(320 8% 44%)", // Dark mauve text
                            },
                            secondary: {
                                DEFAULT: "hsl(0 0% 100%)", // White
                                foreground: "hsl(320 8% 44%)", // Dark mauve text
                            },
                            destructive: {
                                DEFAULT: "hsl(0 84.2% 60.2%)",
                                foreground: "hsl(0 0% 98%)",
                            },
                            muted: {
                                DEFAULT: "hsl(337 30% 90%)",
                                foreground: "hsl(320 8% 44%)",
                            },
                            accent: {
                                DEFAULT: "hsl(337 30% 90%)",
                                foreground: "hsl(320 8% 44%)",
                            },
                            // Semantic Colors
                            success: {
                                DEFAULT: "hsl(142 76% 36%)",
                                foreground: "hsl(0 0% 100%)",
                            },
                            info: {
                                DEFAULT: "hsl(217 91% 60%)",
                                foreground: "hsl(0 0% 100%)",
                            },
                            // Cards are White in this theme
                            card: {
                                DEFAULT: "hsl(0 0% 100%)",
                                foreground: "hsl(320 8% 44%)",
                            },
                        },
                        borderRadius: {
                            lg: "0.75rem", // 12px - softer, bubble-like
                            md: "calc(0.75rem - 2px)",
                            sm: "calc(0.75rem - 4px)",
                        },
                    },
                },
            }
        </script>
        
        <style type="text/tailwindcss">
            @layer base {
                body {
                    @apply bg-background text-foreground font-sans; 
                }
            }
            .glass-card {
                @apply bg-white/80 backdrop-blur-sm border border-white/20 shadow-lg;
            }
        </style>
    
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>
<body class="bg-background text-foreground font-sans antialiased">
    <nav class="bg-card border-b border-border">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <div class="shrink-0 flex items-center">
                        <a href="${role == 'counselor' ? '/counselor/dashboard' : (role == 'admin' ? '/admin/dashboard' : '/student/dashboard')}" 
                           class="text-2xl font-bold text-primary">MindMate</a>
                    </div>
    
                    <c:if test="${role == 'student' || role == null}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/student/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Dashboard
                            </a>
                            
                            <a href="/student/assessment" 
                               class="${fn:contains(currentUrl, 'assessment') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Assessment
                            </a>
                            
                            <a href="/student/library" 
                               class="${fn:contains(currentUrl, 'library') || fn:contains(currentUrl, 'content') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Library
                            </a>
                            
                            <a href="/student/telehealth" 
                               class="${fn:contains(currentUrl, 'telehealth') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Telehealth
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'counselor'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/counselor/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Dashboard
                            </a>
                            <a href="/counselor/schedule" 
                               class="${fn:contains(currentUrl, 'schedule') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Schedule
                            </a>
                            <a href="/counselor/content" 
                               class="${fn:contains(currentUrl, 'content') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Content
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'admin'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/admin/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-primary text-foreground' : 'border-transparent text-muted-foreground hover:border-border hover:text-foreground'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium transition-colors duration-300">
                               Analytics
                            </a>
                        </div>
                    </c:if>
                </div>
                
                <div class="flex items-center">
                    <a href="/logout" class="text-sm text-destructive hover:text-destructive/80 transition-colors duration-300">Logout</a>
                </div>
            </div>
        </div>
    </nav>
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">