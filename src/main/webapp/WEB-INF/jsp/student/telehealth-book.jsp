<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-2">
<div class="space-y-6">
    <h1 class="text-3xl font-bold text-foreground">Book Telehealth Appointment</h1>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border max-w-2xl">
        <form method="POST" action="/student/telehealth/book" class="space-y-4">
            
            <div>
                <label for="counselor" class="block text-sm font-medium text-foreground mb-1">Select Counselor</label>
                <div class="relative">
                    <select id="counselor" name="counselor" 
                            class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground appearance-none">
                        <option value="1">Dr. Jane Smith - Licensed Therapist</option>
                        <option value="2">Dr. John Doe - Clinical Psychologist</option>
                    </select>
                    <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-muted-foreground">
                        <i data-lucide="chevron-down" class="h-4 w-4"></i>
                    </div>
                </div>
            </div>

            <div>
                <label for="date" class="block text-sm font-medium text-foreground mb-1">Select Date</label>
                <input type="date" id="date" name="date" 
                       class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground" 
                       required>
            </div>

            <div>
                <label for="time" class="block text-sm font-medium text-foreground mb-1">Select Time</label>
                <div class="relative">
                    <select id="time" name="time" 
                            class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground appearance-none">
                        <option value="09:00">9:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="11:00">11:00 AM</option>
                        <option value="14:00">2:00 PM</option>
                        <option value="15:00">3:00 PM</option>
                    </select>
                     <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-muted-foreground">
                        <i data-lucide="chevron-down" class="h-4 w-4"></i>
                    </div>
                </div>
            </div>

            <div>
                <label for="reason" class="block text-sm font-medium text-foreground mb-1">Reason for Appointment</label>
                <textarea id="reason" name="reason" rows="4" 
                          class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-white text-foreground placeholder:text-muted-foreground resize-y" 
                          placeholder="Briefly describe the reason for your appointment..."></textarea>
            </div>

            <button type="submit" class="bg-primary text-primary-foreground px-6 py-2.5 rounded-md hover:opacity-90 transition-opacity font-medium focus:outline-none focus:ring-2 focus:ring-ring shadow-sm">
                Book Appointment
            </button>
        </form>
    </div>
</div>
</div>
<jsp:include page="chatbot-widget.jsp" /> 
<jsp:include page="../common/footer.jsp" />