<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">Book Counseling Session</h1>
        <p class="text-muted-foreground">Schedule your appointment with a counselor</p>
    </div>

    <%-- Error Messages --%>
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
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="lg:col-span-1">
            <div class="space-y-6">
                <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                    <div class="flex items-center mb-4">
                        <i data-lucide="calendar" class="w-5 h-5 mr-2 text-success"></i>
                        <h2 class="text-xl font-semibold text-foreground">Select Date</h2>
                    </div>
                    
                    <div class="flex items-center justify-between mb-4">
                        <button type="button" id="prev-month" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-left" class="w-5 h-5"></i>
                        </button>
                        <span class="font-semibold" id="current-month">December 2025</span>
                        <button type="button" id="next-month" class="p-1 hover:bg-secondary rounded">
                            <i data-lucide="chevron-right" class="w-5 h-5"></i>
                        </button>
                    </div>

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
                        </div>
                </div>

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

        <div class="lg:col-span-1">
            <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
                <div class="flex items-center mb-2">
                    <i data-lucide="clock" class="w-5 h-5 mr-2 text-primary"></i>
                    <h2 class="text-xl font-semibold text-foreground">Available Times</h2>
                </div>
                <p class="text-sm text-muted-foreground mb-4" id="selected-date-display">Please select a date</p>

                <div id="time-slots-container">
                    <div class="text-center py-8 text-muted-foreground" id="no-counselor-message">
                        <i data-lucide="alert-triangle" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                        <p>Please select a counselor first</p>
                    </div>

                    <div class="hidden text-center py-8" id="loading-slots">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-2"></div>
                        <p class="text-sm text-muted-foreground">Loading available times...</p>
                    </div>

                    <div class="hidden text-center py-8 text-muted-foreground" id="no-slots-message">
                        <i data-lucide="calendar-x" class="w-8 h-8 mx-auto mb-2 text-muted-foreground/50"></i>
                        <p>No available time slots for this date</p>
                        <p class="text-xs mt-1">Please try another date</p>
                    </div>

                    <div class="space-y-3 hidden" id="time-slots-list">
                        </div>
                </div>

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
    renderCalendar(currentMonth);
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
            document.querySelectorAll('.counselor-card').forEach(c => {
                c.classList.remove('border-primary', 'bg-primary/10');
                c.classList.add('border-border');
            });
            this.classList.add('border-primary', 'bg-primary/10');
            this.classList.remove('border-border');
            selectedCounselor = {
                id: this.dataset.id,
                name: this.dataset.name,
                specialization: this.dataset.specialization
            };
            if (selectedDate) fetchAvailableSlots();
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
    const monthNames = ["January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"];
    document.getElementById('current-month').textContent = monthNames[month] + ' ' + year;
    
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const calendarDays = document.getElementById('calendar-days');
    calendarDays.innerHTML = '';
    
    for (let i = 0; i < firstDay; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.className = 'p-2 text-muted-foreground/50';
        calendarDays.appendChild(emptyCell);
    }
    
    for (let day = 1; day <= daysInMonth; day++) {
        const dayDate = new Date(year, month, day);
        dayDate.setHours(0, 0, 0, 0);
        const isPast = dayDate < today;
        const isToday = dayDate.getTime() === today.getTime();
        
        const dayCell = document.createElement('div');
        dayCell.className = 'p-2 rounded cursor-pointer';
        dayCell.textContent = day;
        
        const yearStr = dayDate.getFullYear();
        const monthStr = String(dayDate.getMonth() + 1).padStart(2, '0');
        const dayStr = String(dayDate.getDate()).padStart(2, '0');
        dayCell.dataset.date = yearStr + "-" + monthStr + "-" + dayStr;
        
        if (isPast) {
            dayCell.className += ' text-muted-foreground/30 cursor-not-allowed';
        } else {
            dayCell.className += ' hover:bg-secondary';
            dayCell.addEventListener('click', function() {
                if (!isPast) selectDate(this);
            });
        }
        
        if (isToday && !isPast) {
            dayCell.classList.add('font-bold', 'text-primary', 'is-today'); 
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
    document.querySelectorAll('#calendar-days > div').forEach(d => {
        d.classList.remove('bg-primary', 'text-primary-foreground');
        if (d.classList.contains('is-today')) {
            d.classList.add('text-primary');
        }
    });
    
    element.classList.add('bg-primary', 'text-primary-foreground');
    element.classList.remove('text-primary'); 
    
    const dateStr = element.dataset.date;
    const [y, m, d] = dateStr.split('-').map(Number);
    selectedDate = new Date(y, m - 1, d); 
    
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('selected-date-display').textContent = selectedDate.toLocaleDateString('en-US', options);
    
    if (selectedCounselor) fetchAvailableSlots();
    updateSummary();
}

// ============================================
// AJAX & TIME SLOTS
// ============================================
function fetchAvailableSlots() {
    if (!selectedCounselor || !selectedDate) return;
    
    document.getElementById('no-counselor-message').classList.add('hidden');
    document.getElementById('no-slots-message').classList.add('hidden');
    document.getElementById('time-slots-list').classList.add('hidden');
    document.getElementById('loading-slots').classList.remove('hidden');
    
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    const day = String(selectedDate.getDate()).padStart(2, '0');
    const month = months[selectedDate.getMonth()];
    const year = selectedDate.getFullYear();
    const dateStr = month + " " + day + ", " + year;
    
    const url = '/student/telehealth/available-slots?counselorId=' + selectedCounselor.id + '&date=' + encodeURIComponent(dateStr);    
    
    fetch(url)
        .then(response => response.json())
        .then(slots => displayTimeSlots(slots))
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('loading-slots').classList.add('hidden');
            document.getElementById('no-slots-message').classList.remove('hidden');
        });
}

function displayTimeSlots(slots) {
    const container = document.getElementById('time-slots-list');
    container.innerHTML = '';
    document.getElementById('loading-slots').classList.add('hidden');

    if (!slots || slots.length === 0) {
        document.getElementById('no-slots-message').classList.remove('hidden');
        return;
    }

    document.getElementById('time-slots-list').classList.remove('hidden');

    const now = new Date();
    const todayStr = now.getFullYear() + "-" + String(now.getMonth()+1).padStart(2,'0') + "-" + String(now.getDate()).padStart(2,'0');
    const selectedDateStr = selectedDate.getFullYear() + "-" + String(selectedDate.getMonth()+1).padStart(2,'0') + "-" + String(selectedDate.getDate()).padStart(2,'0');
    
    const isToday = (selectedDateStr === todayStr);
    const currentHour = now.getHours();

    slots.forEach(timeStr => {
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'time-slot w-full flex items-center justify-start px-4 py-2 border border-border rounded-md hover:bg-secondary transition-colors';
        button.dataset.time = timeStr;
        button.innerHTML = '<i data-lucide="clock" class="w-4 h-4 mr-2"></i><span>' + formatTime(timeStr) + '</span>';
        
        const slotHour = parseInt(timeStr.split(':')[0]);

        if (isToday && slotHour <= currentHour) {
            button.disabled = true;
            button.classList.add('opacity-50', 'cursor-not-allowed', 'bg-muted');
            button.classList.remove('hover:bg-secondary');
            button.title = "This time has passed";
        } else {
            button.addEventListener('click', function() { selectTimeSlot(this); });
        }
        
        container.appendChild(button);
    });
    lucide.createIcons();
}

function formatTime(timeStr) {
    const parts = timeStr.split(':');
    const hour = parseInt(parts[0]);
    const minutes = parts[1] || '00';
    const ampm = hour >= 12 ? 'PM' : 'AM';
    const hour12 = hour % 12 || 12;
    return hour12 + ":" + minutes + " " + ampm;
}

function selectTimeSlot(element) {
    document.querySelectorAll('.time-slot').forEach(s => {
        if (!s.disabled) {
            s.classList.remove('bg-primary', 'text-primary-foreground');
            s.classList.add('border-border');
        }
    });
    element.classList.add('bg-primary', 'text-primary-foreground');
    element.classList.remove('border-border');
    selectedTime = element.dataset.time;
    updateSummary();
}

function setupSessionTypeSelection() {
    const sessionSelect = document.getElementById('session-type');
    if (sessionSelect.value) selectedSessionType = sessionSelect.value;
    sessionSelect.addEventListener('change', function() {
        selectedSessionType = this.value;
        updateSummary();
    });
}

function updateSummary() {
    if (selectedCounselor && selectedDate && selectedTime && selectedSessionType) {
        document.getElementById('summary-counselor').textContent = selectedCounselor.name;
        document.getElementById('summary-date').textContent = document.getElementById('selected-date-display').textContent;
        document.getElementById('summary-time').textContent = formatTime(selectedTime);
        document.getElementById('summary-type').textContent = selectedSessionType;
        document.getElementById('booking-summary').classList.remove('hidden');
    } else {
        document.getElementById('booking-summary').classList.add('hidden');
    }
}

function setupBookingButton() {
    document.getElementById('book-button').addEventListener('click', function() {
        const dateTimeStr = document.getElementById('summary-date').textContent + ' at ' + formatTime(selectedTime);
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        const day = String(selectedDate.getDate()).padStart(2, '0');
        const month = months[selectedDate.getMonth()];
        const year = selectedDate.getFullYear();
        const dateForBackend = month + " " + day + ", " + year;

        document.getElementById('confirm-counselor').textContent = selectedCounselor.name;
        document.getElementById('confirm-specialization').textContent = selectedCounselor.specialization;
        document.getElementById('confirm-datetime').textContent = dateTimeStr;
        document.getElementById('confirm-type').textContent = selectedSessionType;
        
        document.getElementById('form-counselor-id').value = selectedCounselor.id;
        document.getElementById('form-date').value = dateForBackend;
        document.getElementById('form-time').value = selectedTime;
        document.getElementById('form-session-type').value = selectedSessionType;
        
        document.getElementById('confirmation-modal').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    });
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