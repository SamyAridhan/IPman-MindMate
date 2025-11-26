<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">Schedule</h1>
    
    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <h2 class="text-xl font-semibold mb-4 text-foreground">Upcoming Appointments</h2>
        
        <div class="space-y-4">
            <div class="border border-border rounded-md p-4 bg-white/50">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h3 class="text-lg font-semibold text-foreground">Student: John Doe</h3>
                        <div class="flex items-center gap-2 mt-1">
                            <i data-lucide="calendar" class="h-4 w-4 text-primary"></i>
                            <p class="text-muted-foreground">January 15, 2024 at 10:00 AM</p>
                        </div>
                        <p class="text-muted-foreground text-sm mt-1">Reason: General consultation</p>
                    </div>
                    
                    <div class="flex space-x-2 w-full sm:w-auto">
                        <button class="flex-1 sm:flex-none bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity text-sm font-medium focus:outline-none focus:ring-2 focus:ring-ring">
                            View Details
                        </button>
                        
                        <button class="flex-1 sm:flex-none bg-destructive text-destructive-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity text-sm font-medium focus:outline-none focus:ring-2 focus:ring-destructive">
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
            
            </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />