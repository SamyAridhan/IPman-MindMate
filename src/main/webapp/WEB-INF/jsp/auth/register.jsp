<%-- src/main/webapp/WEB-INF/jsp/auth/register.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - MindMate</title>
    
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
            
            <h1 class="text-3xl font-bold text-foreground">Register</h1>
            <p class="text-muted-foreground mt-2">Create your Student account</p>
        </div>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="mb-4 p-3 bg-destructive/10 border border-destructive/20 rounded-md">
                <p class="text-sm text-destructive text-center"><%= request.getAttribute("errorMessage") %></p>
            </div>
        <% } %>
        
        <form method="POST" action="/register" class="space-y-4">
            <div>
                <label for="name" class="block text-sm font-medium text-foreground mb-1">Full Name</label>
                <input type="text" id="name" name="name" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       required>
            </div>
            
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
            
            <div>
                <label for="confirmPassword" class="block text-sm font-medium text-foreground mb-1">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       required>
            </div>
            
            <button type="submit" 
                    class="w-full bg-primary text-primary-foreground font-medium py-2 px-4 rounded-md hover:opacity-90 transition-opacity focus:outline-none focus:ring-2 focus:ring-ring">
                Register
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <p class="text-sm text-muted-foreground">Already have an account? 
                <a href="/login" class="text-primary hover:underline font-medium">Login here</a>
            </p>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>