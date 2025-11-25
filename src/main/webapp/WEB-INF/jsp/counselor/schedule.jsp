<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />
<h1 class="text-3xl font-bold mb-6 text-foreground">Schedule</h1>
<div class="bg-card p-6 rounded-xl shadow-sm border border-border">
    <h2 class="text-xl font-semibold mb-4 text-foreground">Upcoming Appointments</h2>
    <div class="space-y-4">
        <div class="border border-border rounded-lg p-4 hover:shadow-md transition-all duration-300">
            <div class="flex justify-between items-center">
                <div>
                    <h3 class="text-lg font-semibold text-foreground">Student: John Doe</h3>
                    <p class="text-muted-foreground">January 15, 2024 at 10:00 AM</p>
                    <p class="text-muted-foreground text-sm mt-1">Reason: General consultation</p>
                </div>
                <div class="flex space-x-2">
                    <button class="bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90 text-sm transition-all duration-300">
                        View Details
                    </button>
                    <button class="bg-destructive text-destructive-foreground px-4 py-2 rounded-lg hover:bg-destructive/90 text-sm transition-all duration-300">
                        Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />

