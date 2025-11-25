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
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="bg-gray-50 text-gray-900 font-sans antialiased">
    <nav class="bg-white border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <div class="shrink-0 flex items-center">
                        <a href="${role == 'counselor' ? '/counselor/dashboard' : (role == 'admin' ? '/admin/dashboard' : '/student/dashboard')}" 
                           class="text-2xl font-bold text-indigo-600">MindMate</a>
                    </div>
    
                    <c:if test="${role == 'student' || role == null}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/student/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Dashboard
                            </a>
                            
                            <a href="/student/assessment" 
                               class="${fn:contains(currentUrl, 'assessment') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Assessment
                            </a>
                            
                            <a href="/student/library" 
                               class="${fn:contains(currentUrl, 'library') || fn:contains(currentUrl, 'content') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Library
                            </a>
                            
                            <a href="/student/telehealth" 
                               class="${fn:contains(currentUrl, 'telehealth') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Telehealth
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'counselor'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/counselor/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Dashboard
                            </a>
                            <a href="/counselor/schedule" 
                               class="${fn:contains(currentUrl, 'schedule') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Schedule
                            </a>
                            <a href="/counselor/content" 
                               class="${fn:contains(currentUrl, 'content') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Content
                            </a>
                        </div>
                    </c:if>
    
                    <c:if test="${role == 'admin'}">
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/admin/dashboard" 
                               class="${fn:contains(currentUrl, 'dashboard') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                               Analytics
                            </a>
                        </div>
                    </c:if>
                </div>
                
                <div class="flex items-center">
                    <a href="/logout" class="text-sm text-red-600 hover:text-red-800">Logout</a>
                </div>
            </div>
        </div>
    </nav>
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">