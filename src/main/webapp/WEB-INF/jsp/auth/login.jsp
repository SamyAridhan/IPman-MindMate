<%-- src/main/webapp/WEB-INF/jsp/auth/login.jsp --%>
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

        <%-- Error Message Display --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="mb-4 p-3 bg-destructive/10 border border-destructive/20 rounded-md">
                <p class="text-sm text-destructive"><%= request.getAttribute("errorMessage") %></p>
            </div>
        <% } %>
        
        <form method="POST" action="/login" class="space-y-4">
            
            <%-- Email Input --%>
            <div>
                <label for="email" class="block text-sm font-medium text-foreground mb-1">Email</label>
                <input type="email" id="email" name="email" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       placeholder="your.email@example.com"
                       required>
            </div>
            
            <%-- Password Input --%>
            <div>
                <label for="password" class="block text-sm font-medium text-foreground mb-1">Password</label>
                <input type="password" id="password" name="password" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       placeholder="Enter your password"
                       required>
            </div>
            
            <%-- Login Button --%>
            <button type="submit" 
                    class="w-full bg-primary text-primary-foreground font-medium py-2 px-4 rounded-md hover:opacity-90 transition-opacity focus:outline-none focus:ring-2 focus:ring-ring">
                Login
            </button>
        </form>
        
        <%-- Registration Link --%>
        <div class="mt-6 text-center">
            <p class="text-sm text-muted-foreground mb-4">Don't have an account? 
                <a href="/register" class="text-primary hover:underline font-medium">Register as Student</a>
            </p>
        </div>
        
        <%-- Demo Access Section --%>
        <div class="mt-8 pt-6 border-t border-border">
            <p class="text-xs uppercase tracking-wide text-muted-foreground text-center mb-4">Test Credentials</p>
            <div class="space-y-2 text-xs">
                <div class="p-2 bg-secondary/30 rounded">
                    <strong>Student:</strong> demo@student.mindmate.com / student123
                </div>
                <div class="p-2 bg-secondary/30 rounded">
                    <strong>Counselor:</strong> sarah.johnson@mindmate.com / counselor123 <br>
                    <strong>Counselor:</strong> michael.chen@mindmate.com / counselor123 <br>
                    <strong>Counselor:</strong> emily.rodriguez@mindmate.com / counselor123 <br>
                </div>
                <div class="p-2 bg-secondary/30 rounded">
                    <strong>Admin:</strong> admin@mindmate.com / admin123
                </div>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>