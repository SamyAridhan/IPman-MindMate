<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">Book Counseling Session</h1>
        <p class="text-muted-foreground">Schedule your appointment with a counselor</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left Column - Counselor Selection -->
        <div class="lg:col-span-1">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center mb-4">
                    <i data-lucide="user" class="w-5 h-5 mr-2 text-info"></i>
                    <h2 class="text-xl font-semibold text-foreground">Choose Your Counselor</h2>
                </div>

                <div class="space-y-4" id="counselor-list">
                    <c:forEach var="counselor" items="${counselors}">
                        <div class="counselor-card p-4 border rounded-lg cursor-pointer transition-all hover:border-primary/50" 
                             data-id="${counselor.id}" 
                             data-name="${counselor.name}"
                             data-specialization="${counselor.specialization}"
                             data-rating="${counselor.rating}"
                             data-experience="${counselor.experience}"
                             data-availability="${counselor.availability}">
                            <div class="flex items-start space-x-3">
                                <div class="w-12 h-12 bg-primary rounded-full flex items-center justify-center text-primary-foreground font-semibold">
                                    ${counselor.avatar}
                                </div>
                                <div class="flex-1">
                                    <h4 class="font-semibold text-foreground">${counselor.name}</h4>
                                    <p class="text-sm text-muted-foreground mb-2">${counselor.specialization}</p>
                                    <div class="flex items-center space-x-2 text-xs">
                                        <div class="flex items-center">
                                            <i data-lucide="star" class="w-3 h-3 text-yellow-500 mr-1"></i>
                                            <span>${counselor.rating}</span>
                                        </div>
                                        <span class="text-muted-foreground">•</span>
                                        <span>${counselor.experience}</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${counselor.availability == 'High'}">
                                            <span class="inline-block mt-2 px-2 py-0.5 text-xs rounded-full bg-green-100 text-green-800">
                                                High Availability
                                            </span>
                                        </c:when>
                                        <c:when test="${counselor.availability == 'Medium'}">
                                            <span class="inline-block mt-2 px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-800">
                                                Medium Availability
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-block mt-2 px-2 py-0.5 text-xs rounded-full bg-red-100 text-red-800">
                                                Low Availability
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Middle Column - Date & Session Type -->
        <div class="lg:col-span-1">
            <div class="space-y-6">
                
                <!-- Simple Calendar -->
                <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                    <div class="flex items-center mb-4">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-success"></i>
                        <h2 class="text-xl font-semibold text-foreground">Select Date</h2>
                    </div>
                    
                    <!-- Month Header -->
                    <div class="flex items-center justify-between mb-4">
                        <button type="button" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-left" class="w-5 h-5"></i>
                        </button>
                        <span class="font-semibold" id="current-month">December 2025</span>
                        <button type="button" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-right" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <!-- Calendar Grid -->
                    <div class="grid grid-cols-7 gap-1 text-center text-sm">
                        <!-- Week Headers -->
                        <div class="text-muted-foreground font-medium p-2">Su</div>
                        <div class="text-muted-foreground font-medium p-2">Mo</div>
                        <div class="text-muted-foreground font-medium p-2">Tu</div>
                        <div class="text-muted-foreground font-medium p-2">We</div>
                        <div class="text-muted-foreground font-medium p-2">Th</div>
                        <div class="text-muted-foreground font-medium p-2">Fr</div>
                        <div class="text-muted-foreground font-medium p-2">Sa</div>

                        <!-- Calendar dates (simplified for demo) -->
                        <div class="p-2 text-muted-foreground/50">30</div>
                        <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-01">1</div>
                        <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-02">2</div>
                        <div class="p-2 bg-primary text-primary-foreground rounded cursor-pointer calendar-date" data-date="2025-12-03">3</div>
                        <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-04">4</div>
                        <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-05">5</div>
                        <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-06">6</div>
                        
                        <!-- Additional weeks would go here -->
                        <c:forEach begin="7" end="31" var="day">
                            <div class="p-2 hover:bg-secondary rounded cursor-pointer calendar-date" data-date="2025-12-${day}">${day}</div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Session Type -->
                <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                    <h2 class="text-xl font-semibold text-foreground mb-4">Session Type</h2>
                    <select id="session-type" class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background">
                        <option value="">Choose session type</option>
                        <option value="Individual Session (50 min)">Individual Session (50 min) - Free</option>
                        <option value="Group Session (90 min)">Group Session (90 min) - Free</option>
                        <option value="Crisis Support (30 min)">Crisis Support (30 min) - Free</option>
                    </select>
                </div>

            </div>
        </div>

        <!-- Right Column - Time Slots & Booking -->
        <div class="lg:col-span-1">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center mb-2">
                    <i data-lucide="clock" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Available Times</h2>
                </div>
                <p class="text-sm text-muted-foreground mb-4" id="selected-date-display">Wednesday, December 03, 2025</p>

                <div id="time-slots-container">
                    <!-- Default: No counselor selected -->
                    <div class="text-center py-8 text-muted-foreground" id="no-counselor-message">
                        <i data-lucide="alert-triangle" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                        <p>Please select a counselor first</p>
                    </div>

                    <!-- Time Slots (Hidden by default) -->
                    <div class="space-y-3 hidden" id="time-slots-list">
                        <button type="button" class="time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors" data-time="09:00">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            09:00 AM
                        </button>
                        <button type="button" class="time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors" data-time="10:00">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            10:00 AM
                        </button>
                        <button type="button" class="time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors" data-time="14:00">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            02:00 PM
                        </button>
                        <button type="button" class="time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors" data-time="15:00">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            03:00 PM
                        </button>
                        <button type="button" class="time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors" data-time="16:00">
                            <i data-lucide="clock" class="w-4 h-4 mr-2"></i>
                            04:00 PM
                        </button>
                    </div>
                </div>

                <!-- Booking Summary (Hidden by default) -->
                <div class="mt-6 pt-6 border-t hidden" id="booking-summary">
                    <div class="bg-muted p-4 rounded-lg mb-4">
                        <h4 class="font-semibold mb-2">Booking Summary</h4>
                        <div class="space-y-1 text-sm">
                            <p><strong>Counselor:</strong> <span id="summary-counselor">-</span></p>
                            <p><strong>Date:</strong> <span id="summary-date">-</span></p>
                            <p><strong>Time:</strong> <span id="summary-time">-</span></p>
                            <p><strong>Type:</strong> <span id="summary-type">-</span></p>
                        </div>
                        <div class="mt-3 p-3 bg-info/10 rounded-md">
                            <p class="text-xs text-foreground">
                                <strong>Note:</strong> Join Telehealth button will be enabled 10 minutes before your session.
                            </p>
                        </div>
                    </div>

                    <button type="button" id="book-button" class="w-full bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity font-medium flex items-center justify-center gap-2">
                        <i data-lucide="check-circle" class="w-4 h-4"></i>
                        Book Appointment
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div id="confirmation-modal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center p-4">
    <div class="bg-card rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-border">
            <h2 class="text-xl font-semibold text-foreground">Confirm Your Appointment</h2>
        </div>
        
        <div class="p-6">
            <p class="mb-4 text-foreground">Please confirm the details of your counseling session:</p>
            <div class="bg-info/10 p-4 rounded-lg space-y-2 border border-info/20">
                <p class="text-foreground"><strong>Counselor:</strong> <span id="confirm-counselor">-</span></p>
                <p class="text-foreground"><strong>Specialization:</strong> <span id="confirm-specialization">-</span></p>
                <p class="text-foreground"><strong>Date & Time:</strong> <span id="confirm-datetime">-</span></p>
                <p class="text-foreground"><strong>Session Type:</strong> <span id="confirm-type">-</span></p>
            </div>
            <div class="mt-4 text-sm text-muted-foreground space-y-1">
                <p>• You will receive a confirmation email shortly</p>
                <p>• You can reschedule or cancel up to 24 hours before your appointment</p>
                <p>• Please arrive 5 minutes early for your session</p>
            </div>
        </div>

        <div class="p-6 border-t border-border flex justify-end gap-3">
            <button type="button" id="cancel-button" class="px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                Cancel
            </button>
            <form method="POST" action="/student/telehealth/book" id="booking-form">
                <input type="hidden" name="counselorId" id="form-counselor-id">
                <input type="hidden" name="counselorName" id="form-counselor-name">
                <input type="hidden" name="date" id="form-date">
                <input type="hidden" name="time" id="form-time">
                <input type="hidden" name="sessionType" id="form-session-type">
                <button type="submit" class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:opacity-90 transition-opacity">
                    Confirm Booking
                </button>
            </form>
        </div>
    </div>
</div>

<script>
// Booking state
let selectedCounselor = null;
let selectedDate = '2025-12-03';
let selectedTime = null;
let selectedSessionType = null;

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    lucide.createIcons();
    
    // Counselor selection
    document.querySelectorAll('.counselor-card').forEach(card => {
        card.addEventListener('click', function() {
            // Remove previous selection
            document.querySelectorAll('.counselor-card').forEach(c => {
                c.classList.remove('border-primary', 'bg-primary/10');
                c.classList.add('border-border');
            });
            
            // Mark as selected
            this.classList.add('border-primary', 'bg-primary/10');
            this.classList.remove('border-border');
            
            // Store selection
            selectedCounselor = {
                id: this.dataset.id,
                name: this.dataset.name,
                specialization: this.dataset.specialization,
                rating: this.dataset.rating,
                experience: this.dataset.experience,
                availability: this.dataset.availability
            };
            
            // Show time slots
            document.getElementById('no-counselor-message').classList.add('hidden');
            document.getElementById('time-slots-list').classList.remove('hidden');
            
            updateSummary();
        });
    });
    
    // Calendar date selection
    document.querySelectorAll('.calendar-date').forEach(date => {
        date.addEventListener('click', function() {
            document.querySelectorAll('.calendar-date').forEach(d => {
                d.classList.remove('bg-primary', 'text-primary-foreground');
            });
            this.classList.add('bg-primary', 'text-primary-foreground');
            
            selectedDate = this.dataset.date;
            updateDateDisplay();
            updateSummary();
        });
    });
    
    // Time slot selection
    document.querySelectorAll('.time-slot').forEach(slot => {
        slot.addEventListener('click', function() {
            // Remove previous selection
            document.querySelectorAll('.time-slot').forEach(s => {
                s.classList.remove('bg-primary', 'text-primary-foreground');
                s.classList.add('border-border');
            });
            
            // Mark as selected
            this.classList.add('bg-primary', 'text-primary-foreground');
            this.classList.remove('border-border');
            
            selectedTime = this.dataset.time;
            updateSummary();
        });
    });
    
    // Session type selection
    document.getElementById('session-type').addEventListener('change', function() {
        selectedSessionType = this.value;
        updateSummary();
    });
    
    // Book button
    document.getElementById('book-button').addEventListener('click', function() {
        openConfirmationModal();
    });
    
    // Modal actions
    document.getElementById('cancel-button').addEventListener('click', closeConfirmationModal);
    document.getElementById('confirmation-modal').addEventListener('click', function(e) {
        if (e.target === this) closeConfirmationModal();
    });
});

function updateDateDisplay() {
    const dateObj = new Date(selectedDate);
    const formatted = dateObj.toLocaleDateString('en-US', { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
    document.getElementById('selected-date-display').textContent = formatted;
}

function updateSummary() {
    const allSelected = selectedCounselor && selectedTime && selectedSessionType;
    
    if (allSelected) {
        const dateObj = new Date(selectedDate);
        const formattedDate = dateObj.toLocaleDateString('en-US', { 
            month: 'short', 
            day: 'numeric', 
            year: 'numeric' 
        });
        
        document.getElementById('summary-counselor').textContent = selectedCounselor.name;
        document.getElementById('summary-date').textContent = formattedDate;
        document.getElementById('summary-time').textContent = selectedTime;
        document.getElementById('summary-type').textContent = selectedSessionType;
        document.getElementById('booking-summary').classList.remove('hidden');
    } else {
        document.getElementById('booking-summary').classList.add('hidden');
    }
}

function openConfirmationModal() {
    const dateObj = new Date(selectedDate);
    const formattedDateTime = dateObj.toLocaleDateString('en-US', { 
        weekday: 'long', 
        month: 'long', 
        day: 'numeric', 
        year: 'numeric' 
    }) + ' at ' + selectedTime;
    
    const formattedDate = dateObj.toLocaleDateString('en-US', { 
        month: 'short', 
        day: 'numeric', 
        year: 'numeric' 
    });
    
    document.getElementById('confirm-counselor').textContent = selectedCounselor.name;
    document.getElementById('confirm-specialization').textContent = selectedCounselor.specialization;
    document.getElementById('confirm-datetime').textContent = formattedDateTime;
    document.getElementById('confirm-type').textContent = selectedSessionType;
    
    // Set form values
    document.getElementById('form-counselor-id').value = selectedCounselor.id;
    document.getElementById('form-counselor-name').value = selectedCounselor.name;
    document.getElementById('form-date').value = formattedDate;
    document.getElementById('form-time').value = selectedTime;
    document.getElementById('form-session-type').value = selectedSessionType;
    
    document.getElementById('confirmation-modal').classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function closeConfirmationModal() {
    document.getElementById('confirmation-modal').classList.add('hidden');
    document.body.style.overflow = 'auto';
}
</script>

<jsp:include page="../common/footer.jsp" />