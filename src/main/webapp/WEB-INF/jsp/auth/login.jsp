<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MindMate</title>
    
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>

    <script>
        tailwind.config = {
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
<body class="bg-background min-h-screen flex items-center justify-center font-sans antialiased">
    
    <div class="bg-card p-8 rounded-lg shadow-lg border border-border w-full max-w-md">
        
        <div class="flex flex-col items-center mb-6">
            <img src="${pageContext.request.contextPath}/images/MindMate.png" 
     alt="MindMate Logo" 
     class="h-16 w-16 mb-2 object-contain logo-mindmate">
            
            <h1 class="text-3xl font-bold text-foreground">MindMate</h1>
            <h2 class="text-xl font-medium text-muted-foreground mt-1">Welcome back</h2>
        </div>
        
        <form method="POST" action="/login" class="space-y-4">
            <div>
                <label for="email" class="block text-sm font-medium text-foreground mb-1">Email</label>
                <input type="email" id="email" name="email" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       required>
            </div>
            
            <div>
                <label for="password" class="block text-sm font-medium text-foreground mb-1">Password</label>
                <input type="password" id="password" name="password" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       required>
            </div>
            
            <button type="submit" 
                    class="w-full bg-primary text-primary-foreground font-medium py-2 px-4 rounded-md hover:opacity-90 transition-opacity focus:outline-none focus:ring-2 focus:ring-ring">
                Login
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <p class="text-sm text-muted-foreground mb-4">Don't have an account? 
                <a href="/register" class="text-primary hover:underline font-medium">Register here</a>
            </p>
        </div>
        
        <div class="mt-8 pt-6 border-t border-border">
            <p class="text-xs uppercase tracking-wide text-muted-foreground text-center mb-4">Demo Access (Bypass Login)</p>
            <div class="space-y-2">
                <a href="/student/dashboard" 
                   class="block w-full border border-green-200 bg-green-50 text-green-700 py-2 px-4 rounded-md hover:bg-green-100 text-center text-sm font-medium transition-colors">
                    Login as Student
                </a>
                <a href="/counselor/dashboard" 
                   class="block w-full border border-purple-200 bg-purple-50 text-purple-700 py-2 px-4 rounded-md hover:bg-purple-100 text-center text-sm font-medium transition-colors">
                    Login as Counselor
                </a>
                <a href="/admin/dashboard" 
                   class="block w-full border border-red-200 bg-red-50 text-red-700 py-2 px-4 rounded-md hover:bg-red-100 text-center text-sm font-medium transition-colors">
                    Login as Admin
                </a>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>