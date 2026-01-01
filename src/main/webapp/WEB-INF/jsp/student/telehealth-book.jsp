<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">Book Counseling Session</h1>
        <p class="text-muted-foreground">Schedule your appointment with a counselor</p>
    </div>

    <!-- Error Messages -->
    <c:if test="${param.error == 'unavailable'}">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-red-800">Slot Unavailable</h3>
                <p class="text-sm text-red-700 mt-1">This time slot has been booked by another student. Please choose a different time.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'invaliddate'}">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-red-800">Invalid Date</h3>
                <p class="text-sm text-red-700 mt-1">You cannot book appointments in the past.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'bookingfailed'}">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 mt-0.5"></i>
            <div>
                <h3 class="text-sm font-medium text-red-800">Booking Failed</h3>
                <p class="text-sm text-red-700 mt-1">An error occurred while booking your appointment. Please try again.</p>
            </div>
        </div>
    </c:if>

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
                        <button type="button" id="prev-month" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-left" class="w-5 h-5"></i>
                        </button>
                        <span class="font-semibold" id="current-month">December 2025</span>
                        <button type="button" id="next-month" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-right" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <!-- Calendar Grid -->
                    <div class="grid grid-cols-7 gap-1 text-center text-sm mb-2">
                        <div class="text-muted-foreground font-medium p-2">Su</div>
                        <div class="text-muted-foreground font-medium p-2">Mo</div>
                        <div class="text-muted-foreground font-medium p-2">Tu</div>
                        <div class="text-muted-foreground font-medium p-2">We</div>
                        <div class="text-muted-foreground font-medium p-2">Th</div>
                        <div class="text-muted-foreground font-medium p-2">Fr</div>
                        <div class="text-muted-foreground font-medium p-2">Sa</div>
                    </div>
                    
                    <div id="calendar-days" class="grid grid-cols-7 gap-1 text-center text-sm">
                        <!-- Days will be populated by JavaScript -->
                    </div>
                </div>

                <!-- Session Type -->
                <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                    <h2 class="text-xl font-semibold text-foreground mb-4">Session Type</h2>
                    <select id="session-type" class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background">
                        <option value="">Choose session type</option>
                        <option value="Video Call">Video Call (50 min) - Free</option>
                        <option value="Chat Session">Chat Session (50 min) - Free</option>
                        <option value="Phone Call">Phone Call (30 min) - Free</option>
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
                <p class="text-sm text-muted-foreground mb-4" id="selected-date-display">Please select a date</p>

                <div id="time-slots-container">
                    <!-- Default: No counselor selected -->
                    <div class="text-center py-8 text-muted-foreground" id="no-counselor-message">
                        <i data-lucide="alert-triangle" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                        <p>Please select a counselor first</p>
                    </div>

                    <!-- Loading State -->
                    <div class="hidden text-center py-8" id="loading-slots">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-2"></div>
                        <p class="text-sm text-muted-foreground">Loading available times...</p>
                    </div>

                    <!-- No Slots Available -->
                    <div class="hidden text-center py-8 text-muted-foreground" id="no-slots-message">
                        <i data-lucide="calendar-x" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                        <p>No available time slots for this date</p>
                        <p class="text-xs mt-1">Please try another date</p>
                    </div>

                    <!-- Time Slots List -->
                    <div class="space-y-3 hidden" id="time-slots-list">
                        <!-- Slots will be populated by AJAX -->
                    </div>
                </div>

                <!-- Booking Summary -->
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
                                <strong>Note:</strong> Your appointment will be pending until the counselor confirms it.
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
                <p>• You will receive a notification once the counselor confirms</p>
                <p>• You can cancel up to 24 hours before your appointment</p>
                <p>• Please arrive 5 minutes early for your session</p>
            </div>
        </div>

        <div class="p-6 border-t border-border flex justify-end gap-3">
            <button type="button" id="cancel-button" class="px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors">
                Cancel
            </button>
            <form method="POST" action="/student/telehealth/book" id="booking-form">
                <input type="hidden" name="counselorId" id="form-counselor-id">
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
// ============================================
// BOOKING STATE MANAGEMENT
// ============================================
let selectedCounselor = null;
let selectedDate = null;
let selectedTime = null;
let selectedSessionType = null;
let currentMonth = new Date();

// ============================================
// INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    lucide.createIcons();
    
    // Initialize calendar with current month
    renderCalendar(currentMonth);
    
    // Event Listeners
    setupCounselorSelection();
    setupCalendarNavigation();
    setupSessionTypeSelection();
    setupBookingButton();
    setupModalHandlers();
});

// ============================================
// COUNSELOR SELECTION
// ============================================
function setupCounselorSelection() {
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
                specialization: this.dataset.specialization
            };
            
            console.log('Counselor selected:', selectedCounselor);
            
            // If date is also selected, fetch slots
            if (selectedDate) {
                fetchAvailableSlots();
            }
            
            updateSummary();
        });
    });
}

// ============================================
// CALENDAR RENDERING
// ============================================
function renderCalendar(date) {
    const year = date.getFullYear();
    const month = date.getMonth();
    
    // Update header
    const monthNames = ["January", "February", "March", "April", "May", "June",
                       "July", "August", "September", "October", "November", "December"];
    document.getElementById('current-month').textContent = monthNames[month] + ' ' + year;
    
    // Get first day of month and number of days
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const calendarDays = document.getElementById('calendar-days');
    calendarDays.innerHTML = '';
    
    // Add empty cells for days before month starts
    for (let i = 0; i < firstDay; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.className = 'p-2 text-muted-foreground/50';
        calendarDays.appendChild(emptyCell);
    }
    
    // Add day cells
    for (let day = 1; day <= daysInMonth; day++) {
        const dayDate = new Date(year, month, day);
        dayDate.setHours(0, 0, 0, 0);
        const isPast = dayDate < today;
        const isToday = dayDate.getTime() === today.getTime();
        
        const dayCell = document.createElement('div');
        dayCell.className = 'p-2 rounded cursor-pointer';
        dayCell.textContent = day;
        
        if (isPast) {
            dayCell.className += ' text-muted-foreground/30 cursor-not-allowed';
        } else {
            dayCell.className += ' hover:bg-secondary';
            dayCell.dataset.date = dayDate.toISOString().split('T')[0];
            
            dayCell.addEventListener('click', function() {
                if (!isPast) {
                    selectDate(this);
                }
            });
        }
        
        if (isToday && !isPast) {
            dayCell.classList.add('font-bold', 'text-primary');
        }
        
        calendarDays.appendChild(dayCell);
    }
}

function setupCalendarNavigation() {
    document.getElementById('prev-month').addEventListener('click', function() {
        currentMonth.setMonth(currentMonth.getMonth() - 1);
        renderCalendar(currentMonth);
    });
    
    document.getElementById('next-month').addEventListener('click', function() {
        currentMonth.setMonth(currentMonth.getMonth() + 1);
        renderCalendar(currentMonth);
    });
}

function selectDate(element) {
    // Remove previous selection
    document.querySelectorAll('#calendar-days > div').forEach(d => {
        d.classList.remove('bg-primary', 'text-primary-foreground');
    });
    
    // Mark as selected
    element.classList.add('bg-primary', 'text-primary-foreground');
    
    // Store date
    const dateStr = element.dataset.date;
    const dateObj = new Date(dateStr + 'T00:00:00');
    selectedDate = dateObj;
    
    // Format display date
    const formatted = dateObj.toLocaleDateString('en-US', { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
    document.getElementById('selected-date-display').textContent = formatted;
    
    console.log('Date selected:', dateStr);
    
    // Fetch slots if counselor is selected
    if (selectedCounselor) {
        fetchAvailableSlots();
    }
    
    updateSummary();
}

// ============================================
// AJAX: FETCH AVAILABLE TIME SLOTS
// ============================================
function fetchAvailableSlots() {
    if (!selectedCounselor || !selectedDate) return;
    
    // Show loading state
    document.getElementById('no-counselor-message').classList.add('hidden');
    document.getElementById('no-slots-message').classList.add('hidden');
    document.getElementById('time-slots-list').classList.add('hidden');
    document.getElementById('loading-slots').classList.remove('hidden');
    
    // Format date for backend
    const dateStr = selectedDate.toLocaleDateString('en-US', { 
        month: 'short', 
        day: '2-digit', 
        year: 'numeric' 
    });
    
    const url = `/student/telehealth/available-slots?counselorId=${selectedCounselor.id}&date=${encodeURIComponent(dateStr)}`;
    
    console.log('Fetching slots from:', url);
    
    fetch(url)
        .then(response => response.json())
        .then(slots => {
            console.log('Received slots:', slots);
            displayTimeSlots(slots);
        })
        .catch(error => {
            console.error('Error fetching slots:', error);
            document.getElementById('loading-slots').classList.add('hidden');
            document.getElementById('no-slots-message').classList.remove('hidden');
        });
}

function displayTimeSlots(slots) {
    const container = document.getElementById('time-slots-list');
    container.innerHTML = '';
    
    document.getElementById('loading-slots').classList.add('hidden');
    
    if (slots.length === 0) {
        document.getElementById('no-slots-message').classList.remove('hidden');
        return;
    }
    
    // Show slots
    document.getElementById('time-slots-list').classList.remove('hidden');
    
    slots.forEach(timeStr => {
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors';
        button.dataset.time = timeStr;
        
        const icon = document.createElement('i');
        icon.setAttribute('data-lucide', 'clock');
        icon.className = 'w-4 h-4 mr-2';
        
        const text = document.createTextNode(formatTime(timeStr));
        
        button.appendChild(icon);
        button.appendChild(text);
        
        button.addEventListener('click', function() {
            selectTimeSlot(this);
        });
        
        container.appendChild(button);
    });
    
    lucide.createIcons();
}

function formatTime(timeStr) {
    const [hours, minutes] = timeStr.split(':');
    const hour = parseInt(hours);
    const ampm = hour >= 12 ? 'PM' : 'AM';
    const hour12 = hour % 12 || 12;
    return `${hour12}:${minutes} ${ampm}`;
}

function selectTimeSlot(element) {
    // Remove previous selection
    document.querySelectorAll('.time-slot').forEach(s => {
        s.classList.remove('bg-primary', 'text-primary-foreground');
        s.classList.add('border-border');
    });
    
    // Mark as selected
    element.classList.add('bg-primary', 'text-primary-foreground');
    element.classList.remove('border-border');
    
    selectedTime = element.dataset.time;
    
    console.log('Time selected:', selectedTime);
    
    updateSummary();
}

// ============================================
// SESSION TYPE SELECTION
// ============================================
function setupSessionTypeSelection() {
    document.getElementById('session-type').addEventListener('change', function() {
        selectedSessionType = this.value;
        console.log('Session type selected:', selectedSessionType);
        updateSummary();
    });
}

// ============================================
// BOOKING SUMMARY UPDATE
// ============================================
function updateSummary() {
    const allSelected = selectedCounselor && selectedDate && selectedTime && selectedSessionType;
    
    if (allSelected) {
        const dateStr = selectedDate.toLocaleDateString('en-US', { 
            month: 'short', 
            day: 'numeric', 
            year: 'numeric' 
        });
        
        document.getElementById('summary-counselor').textContent = selectedCounselor.name;
        document.getElementById('summary-date').textContent = dateStr;
        document.getElementById('summary-time').textContent = formatTime(selectedTime);
        document.getElementById('summary-type').textContent = selectedSessionType;
        document.getElementById('booking-summary').classList.remove('hidden');
    } else {
        document.getElementById('booking-summary').classList.add('hidden');
    }
}

// ============================================
// BOOKING CONFIRMATION
// ============================================
function setupBookingButton() {
    document.getElementById('book-button').addEventListener('click', openConfirmationModal);
}

function openConfirmationModal() {
    const dateTimeStr = selectedDate.toLocaleDateString('en-US', { 
        weekday: 'long', 
        month: 'long', 
        day: 'numeric', 
        year: 'numeric' 
    }) + ' at ' + formatTime(selectedTime);
    
    const dateForBackend = selectedDate.toLocaleDateString('en-US', { 
        month: 'short', 
        day: '2-digit', 
        year: 'numeric' 
    });
    
    document.getElementById('confirm-counselor').textContent = selectedCounselor.name;
    document.getElementById('confirm-specialization').textContent = selectedCounselor.specialization;
    document.getElementById('confirm-datetime').textContent = dateTimeStr;
    document.getElementById('confirm-type').textContent = selectedSessionType;
    
    // Set form values
    document.getElementById('form-counselor-id').value = selectedCounselor.id;
    document.getElementById('form-date').value = dateForBackend;
    document.getElementById('form-time').value = selectedTime;
    document.getElementById('form-session-type').value = selectedSessionType;
    
    document.getElementById('confirmation-modal').classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function setupModalHandlers() {
    document.getElementById('cancel-button').addEventListener('click', closeConfirmationModal);
    document.getElementById('confirmation-modal').addEventListener('click', function(e) {
        if (e.target === this) closeConfirmationModal();
    });
}

function closeConfirmationModal() {
    document.getElementById('confirmation-modal').classList.add('hidden');
    document.body.style.overflow = 'auto';
}
</script>

<jsp:include page="../common/footer.jsp" />