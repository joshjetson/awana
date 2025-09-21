<!-- Family Check-In Card -->
<div class="bg-white rounded-2xl shadow-xl p-6 border-l-4 border-blue-500 animate-fade-in">
    <!-- Family Header -->
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center space-x-4">
            <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-500 
                        rounded-full flex items-center justify-center text-white font-bold text-xl">
                ${household.name.substring(0, 2).toUpperCase()}
            </div>
            <div>
                <h2 class="text-2xl font-bold text-gray-900">${household.name}</h2>
                <p class="text-gray-600">${students.size()} children • ${household.qrCode}</p>
            </div>
        </div>
        <div class="text-right">
            <div class="text-2xl font-bold text-green-600">
                ${household.getTotalFamilyBucks()} bucks
            </div>
            <div class="text-sm text-gray-500">Family Total</div>
        </div>
    </div>

    <!-- Student Tabs -->
    <div class="space-y-4">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Check In Children:</h3>

        <!-- Tab Navigation -->
        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8 overflow-x-auto" aria-label="Students">
                <g:each in="${students}" var="student" status="i">
                    <g:set var="attendance" value="${attendanceMap[student.id]}"/>
                    <button
                        hx-get="/renderView?viewType=checkinStudent&studentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${today}'/>&targetElement=%23student-checkin-form"
                        hx-target="#student-checkin-form"
                        hx-swap="innerHTML"
                        onclick="setActiveTab(this)"
                        class="student-tab ${i == 0 ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}
                               whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200
                               min-w-0 flex-shrink-0 touch-manipulation min-h-[44px] flex items-center">
                        <div class="flex items-center space-x-2">
                            <!-- Student Avatar -->
                            <div class="w-8 h-8 bg-gradient-to-br from-orange-400 to-pink-500
                                        rounded-full flex items-center justify-center text-white font-bold text-xs">
                                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                            </div>
                            <!-- Student Name -->
                            <span class="truncate">${student.firstName}</span>
                            <!-- Status Indicator -->
                            <g:if test="${attendance?.present}">
                                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                            </g:if>
                            <g:else>
                                <div class="w-3 h-3 bg-gray-300 rounded-full"></div>
                            </g:else>
                        </div>
                    </button>
                </g:each>
            </nav>
        </div>

        <!-- Student Check-in Form Area -->
        <div id="student-checkin-form" class="mt-6">
            <!-- First student's form will load here by default -->
            <g:if test="${students}">
                <g:set var="firstStudent" value="${students[0]}"/>
                <g:set var="firstAttendance" value="${attendanceMap[firstStudent.id]}"/>
                <g:render template="/universal/attendance/checkinStudent"
                          model="[student: firstStudent,
                                  meetingDate: today,
                                  attendance: firstAttendance,
                                  calendar: calendar,
                                  targetElement: '#student-checkin-form']"/>
            </g:if>
        </div>
    </div>
</div>

<script>
// Tab switching function
function setActiveTab(clickedTab) {
    // Remove active classes from all tabs
    document.querySelectorAll('.student-tab').forEach(tab => {
        tab.classList.remove('border-blue-500', 'text-blue-600');
        tab.classList.add('border-transparent', 'text-gray-500');
    });

    // Add active classes to clicked tab
    clickedTab.classList.remove('border-transparent', 'text-gray-500');
    clickedTab.classList.add('border-blue-500', 'text-blue-600');
}

// Add missing showClubOverview function for this page
function showClubOverview(clubId, clubName) {
    htmx.ajax('GET', '/renderView', {
        values: {
            viewType: 'clubOverview',
            clubId: clubId
        },
        target: '#family-checkin-area',
        swap: 'innerHTML'
    });
}
</script>