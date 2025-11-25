<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MindMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-3xl font-bold text-center mb-6 text-blue-600">MindMate</h1>
        <h2 class="text-2xl font-semibold text-center mb-6">Login</h2>
        
        <form method="POST" action="/login" class="space-y-4">
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input type="email" id="email" name="email" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                       required>
            </div>
            
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <input type="password" id="password" name="password" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                       required>
            </div>
            
            <button type="submit" 
                    class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                Login
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <p class="text-sm text-gray-600 mb-4">Don't have an account? 
                <a href="/register" class="text-blue-600 hover:underline">Register here</a>
            </p>
        </div>
        
        <div class="mt-8 pt-6 border-t border-gray-300">
            <p class="text-sm text-gray-500 text-center mb-4">Demo Access (Bypass Login):</p>
            <div class="space-y-2">
                <a href="/student/dashboard" 
                   class="block w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700 text-center">
                    Login as Student
                </a>
                <a href="/counselor/dashboard" 
                   class="block w-full bg-purple-600 text-white py-2 px-4 rounded-md hover:bg-purple-700 text-center">
                    Login as Counselor
                </a>
                <a href="/admin/dashboard" 
                   class="block w-full bg-red-600 text-white py-2 px-4 rounded-md hover:bg-red-700 text-center">
                    Login as Admin
                </a>
            </div>
        </div>
    </div>
</body>
</html>

