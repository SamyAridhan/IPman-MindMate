<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="min-h-[80vh] flex items-center justify-center px-4">
    <div class="w-full max-w-md space-y-8 animate-fade-in bg-white p-8 rounded-2xl shadow-lg border border-border">
        
        <div class="text-center space-y-2">
            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-primary/10 mb-4">
                <i data-lucide="log-in" class="w-6 h-6 text-primary"></i>
            </div>
            <h2 class="text-3xl font-bold tracking-tight text-foreground">Welcome back</h2>
            <p class="text-sm text-muted-foreground">Enter your details to sign in to your account</p>
        </div>

        <form action="/login" method="POST" class="space-y-6">
            <div class="space-y-2">
                <label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70" for="email">Email</label>
                <input class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" id="email" placeholder="m@example.com" type="email" name="username">
            </div>
            <div class="space-y-2">
                <label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70" for="password">Password</label>
                <input class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" id="password" type="password" name="password">
            </div>
            <button class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 w-full" type="submit">
                Sign In
            </button>
        </form>

        <div class="relative">
            <div class="absolute inset-0 flex items-center"><span class="w-full border-t"></span></div>
            <div class="relative flex justify-center text-xs uppercase"><span class="bg-white px-2 text-muted-foreground">Demo Access</span></div>
        </div>
        
        <div class="grid grid-cols-3 gap-2">
            <form action="/login" method="post">
                <input type="hidden" name="role" value="student">
                <button type="submit" class="w-full inline-flex items-center justify-center rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9">
                    Student
                </button>
            </form>
            <form action="/login" method="post">
                <input type="hidden" name="role" value="counselor">
                <button type="submit" class="w-full inline-flex items-center justify-center rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9">
                    Counselor
                </button>
            </form>
            <form action="/login" method="post">
                <input type="hidden" name="role" value="admin">
                <button type="submit" class="w-full inline-flex items-center justify-center rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9">
                    Admin
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />