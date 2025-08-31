<%-- 
Attendance Management Content Template 
Loaded via: /renderView?viewType=attendanceManagement&meetingDate=YYYY-MM-DD
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header with Search -->
    <div class="bg-gradient-to-r from-blue-600 to-green-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h1 class="text-2xl font-bold mb-2">Attendance Report - <g:formatDate format="MMMM dd, yyyy" date="${meetingDate}"/></h1>
                    <div class="text-blue-100">
                        View attendance records and student statistics
                    </div>
                </div>
                
                <!-- Back to Calendar Button -->
                <button hx-get="/renderView?viewType=attendance"
                        hx-target="#attendance-page-content"
                        hx-swap="innerHTML"
                        class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-2 rounded-lg flex items-center space-x-2 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                    </svg>
                    <span>Back to Calendar</span>
                </button>
            </div>
            
            <!-- Search Bar -->
            <div class="relative max-w-md">
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <input type="text" 
                       id="attendance-student-search"
                       name="attendanceSearch"
                       placeholder="Search students..."
                       class="w-full pl-10 pr-4 py-3 border border-blue-300 bg-white bg-opacity-90 rounded-lg focus:ring-2 focus:ring-blue-300 focus:border-transparent text-gray-900 text-sm"
                       hx-get="/renderView?viewType=attendanceStudentSearch"
                       hx-trigger="input changed delay:300ms"
                       hx-target="#attendance-content-area"
                       hx-swap="innerHTML"
                       hx-include="[name='meetingDate']"/>
                <input type="hidden" name="meetingDate" value="<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>"/>
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6">
        <!-- Main Content Area -->
        <div id="attendance-content-area">
            <!-- Default club overview loads here -->
            <div hx-get="/renderView?viewType=attendanceClubOverview&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>" 
                 hx-trigger="load"
                 hx-swap="outerHTML">
                <!-- Club overview loads here -->
            </div>
        </div>
    </div>
</div>