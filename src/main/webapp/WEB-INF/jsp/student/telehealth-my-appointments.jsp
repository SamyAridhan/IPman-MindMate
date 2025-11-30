<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">My Appointments</h1>

    <div class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3">
        <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600 mt-0.5"></i>
        <div>
            <h3 class="text-sm font-medium text-green-800">Success</h3>
            <p class="text-sm text-green-700 mt-1">
                Your appointment has been booked successfully.
            </p>
        </div>
    </div>

    <div class="bg-card shadow-sm border border-border rounded-lg overflow-hidden">
        <div class="px-6 py-5 border-b border-border">
            <h3 class="text-lg font-semibold text-foreground">Upcoming Sessions</h3>
        </div>
        
        <ul class="divide-y divide-border">
            <li class="px-6 py-5 hover:bg-secondary/20 transition-colors">
                <div class="flex items-center justify-between mb-2">
                    <p class="text-lg font-medium text-foreground">
                        Session with <span class="text-primary">Dr. Emily Chen</span>
                    </p>
                    <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-green-100 text-green-800 border border-green-200">
                        Confirmed
                    </span>
                </div>
                
                <div class="sm:flex sm:justify-between">
                    <div class="sm:flex gap-6">
                        <p class="flex items-center text-sm text-muted-foreground">
                            <i data-lucide="calendar" class="mr-2 h-4 w-4 text-primary"></i>
                            Nov 28, 2025
                        </p>
                        <p class="mt-2 flex items-center text-sm text-muted-foreground sm:mt-0">
                            <i data-lucide="clock" class="mr-2 h-4 w-4 text-primary"></i>
                            10:00 AM
                        </p>
                    </div>
                    </div>
            </li>
            
            </ul>
    </div>
</div>

<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />