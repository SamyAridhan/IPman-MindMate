<jsp:include page="../common/header.jsp" />
<div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
    <div class="bg-green-50 border-l-4 border-green-400 p-4 mb-6">
        <div class="flex">
            <div class="ml-3">
                <p class="text-sm text-green-700">
                    Success! Your appointment has been booked.
                </p>
            </div>
        </div>
    </div>

    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">My Upcoming Appointments</h3>
        </div>
        <div class="border-t border-gray-200">
            <ul class="divide-y divide-gray-200">
                <li class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                        <p class="text-sm font-medium text-indigo-600 truncate">Session with Dr. Emily Chen</p>
                        <div class="ml-2 flex-shrink-0 flex">
                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Confirmed</span>
                        </div>
                    </div>
                    <div class="mt-2 sm:flex sm:justify-between">
                        <div class="sm:flex">
                            <p class="flex items-center text-sm text-gray-500">
                                <i data-lucide="calendar" class="mr-1.5 h-5 w-5 text-gray-400"></i>
                                Nov 28, 2025
                            </p>
                            <p class="mt-2 flex items-center text-sm text-gray-500 sm:mt-0 sm:ml-6">
                                <i data-lucide="clock" class="mr-1.5 h-5 w-5 text-gray-400"></i>
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