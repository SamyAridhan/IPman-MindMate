<jsp:include page="../common/header.jsp" />
<div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
    <div class="bg-success/10 border-l-4 border-success p-4 mb-6 rounded-lg">
        <div class="flex">
            <div class="ml-3">
                <p class="text-sm text-success">
                    Success! Your appointment has been booked.
                </p>
            </div>
        </div>
    </div>

    <div class="bg-card shadow-sm overflow-hidden rounded-xl border border-border">
        <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-foreground">My Upcoming Appointments</h3>
        </div>
        <div class="border-t border-border">
            <ul class="divide-y divide-border">
                <li class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                        <p class="text-sm font-medium text-primary truncate">Session with Dr. Emily Chen</p>
                        <div class="ml-2 flex-shrink-0 flex">
                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-success/20 text-success">Confirmed</span>
                        </div>
                    </div>
                    <div class="mt-2 sm:flex sm:justify-between">
                        <div class="sm:flex">
                            <p class="flex items-center text-sm text-muted-foreground">
                                <i data-lucide="calendar" class="mr-1.5 h-5 w-5 text-muted-foreground"></i>
                                Nov 28, 2025
                            </p>
                            <p class="mt-2 flex items-center text-sm text-muted-foreground sm:mt-0 sm:ml-6">
                                <i data-lucide="clock" class="mr-1.5 h-5 w-5 text-muted-foreground"></i>
                                10:00 AM
                            </p>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />