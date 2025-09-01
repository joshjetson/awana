<%-- 
Main Attendance & Calendar Management Content Template 
Loaded via: /renderView?viewType=attendance
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header with Real Metrics -->
    <div class="bg-gradient-to-r from-blue-600 to-green-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h1 class="text-2xl font-bold mb-2">Attendance & Calendar</h1>
                    <div class="text-blue-100">
                        <span id="calendar-view-subtitle">Manage Awana calendar, track attendance, and view metrics</span>
                    </div>
                </div>
                
                <!-- Real-time Metrics -->
                <div class="flex space-x-6">
                    <div class="text-center">
                        <div class="text-2xl font-bold text-white" id="avg-attendance-metric">
                            ${attendanceMetrics?.averageAttendance ? (Math.round(attendanceMetrics.averageAttendance * 10) / 10) : '--'}%
                        </div>
                        <div class="text-blue-100 text-xs">Average Attendance</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-white" id="meetings-completed-metric">
                            ${attendanceMetrics?.meetingsCompleted ?: 0}/${attendanceMetrics?.totalMeetings ?: 0}
                        </div>
                        <div class="text-blue-100 text-xs">Meetings This Season</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-white" id="total-students-metric">
                            ${totalStudents ?: 0}
                        </div>
                        <div class="text-blue-100 text-xs">Total Students</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Calendar System -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Calendar Header -->
            <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold">Awana Calendar</h2>
                    <button <g:if test="${calendar}">hx-get="/renderView?viewType=calendarSetup&calendarId=${calendar.id}"</g:if><g:else>hx-get="/renderView?viewType=calendarSetup"</g:else>
                            hx-target="#attendance-page-content"
                            hx-swap="innerHTML"
                            class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-2 rounded-lg flex items-center space-x-2 transition-colors">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                        </svg>
                        <span>
                            <g:if test="${calendar}">
                                Update Calendar
                            </g:if>
                            <g:else>
                                Setup Calendar
                            </g:else>
                        </span>
                    </button>
                </div>
                
                <!-- Calendar Controls -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <!-- View Selector -->
                        <div class="flex bg-white bg-opacity-10 rounded-lg p-1">
                            <button data-calendar-view="dayGridMonth" class="px-3 py-1 text-sm font-medium bg-white text-blue-600 rounded-md">Month</button>
                            <button data-calendar-view="timeGridWeek" class="px-3 py-1 text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 rounded-md">Week</button>
                            <button data-calendar-view="timeGridDay" class="px-3 py-1 text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 rounded-md">Day</button>
                        </div>
                    </div>
                    
                    <!-- Navigation -->
                    <div class="flex items-center space-x-2">
                        <button data-calendar-prev class="p-2 hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </button>
                        <span id="calendar-title" class="text-lg font-semibold min-w-[140px] text-center">
                            <g:if test="${calendar}">
                                <g:formatDate format="MMMM yyyy" date="${calendar.startDate}"/>
                            </g:if>
                            <g:else>
                                Calendar
                            </g:else>
                        </span>
                        <button data-calendar-next class="p-2 hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Calendar and Metrics Layout -->
            <div class="flex flex-col lg:flex-row">
                <!-- Calendar Area -->
                <div class="flex-1 p-6">
                    <!-- FullCalendar will be mounted here -->
                    <div id="awana-calendar" class="min-h-[400px]">
                        <!-- Calendar loads here -->
                    </div>
                </div>
                
                <!-- Dynamic Controls Sidebar -->
                <div class="lg:w-80 border-t lg:border-t-0 lg:border-l border-gray-200 bg-gray-50 flex flex-col">
                    <!-- Sidebar Header -->
                    <div class="p-4 border-b border-gray-200 bg-white">
                        <div class="flex items-center justify-between">
                            <h3 class="text-lg font-semibold text-gray-900" id="sidebar-title">Clubs</h3>
                            <button id="sidebar-back-btn" style="display: none;" 
                                    onclick="resetCalendarView()"
                                    class="text-blue-600 hover:text-blue-800 text-sm font-medium flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                                </svg>
                                <span>Back</span>
                            </button>
                        </div>
                        <p class="text-sm text-gray-600 mt-1" id="sidebar-subtitle">Click a club to view students</p>
                    </div>
                    
                    <!-- Scrollable Content Area -->
                    <div class="flex-1 overflow-y-auto p-4 max-h-[440px]" id="sidebar-content">
                        <!-- Club Controls (Default View) -->
                        <div id="clubs-view" class="space-y-3">
                            <g:each in="${clubs}" var="club">
                                <div class="bg-white rounded-lg p-3 shadow-sm hover:shadow-md transition-shadow cursor-pointer border-l-4 ${club.name == 'Cubbies' ? 'border-yellow-400' : club.name == 'Sparks' ? 'border-orange-400' : club.name.contains('T&T') ? 'border-blue-400' : 'border-purple-400'}"
                                     onclick="showClubStudents('${club.id}', '${club.name}')">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <h4 class="font-semibold text-gray-900 text-sm">${club.name}</h4>
                                            <p class="text-xs text-gray-600">${club.students?.size() ?: 0} students</p>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-lg font-bold ${club.name == 'Cubbies' ? 'text-yellow-600' : club.name == 'Sparks' ? 'text-orange-600' : club.name.contains('T&T') ? 'text-blue-600' : 'text-purple-600'}">
                                                ${clubAttendanceRates[club.id] ?: 0}%
                                            </div>
                                            <div class="text-xs text-gray-500">Monthly Rate</div>
                                        </div>
                                    </div>
                                </div>
                            </g:each>
                        </div>
                        
                        <!-- Student Controls (Hidden by default) -->
                        <div id="students-view" style="display: none;" class="space-y-2">
                            <!-- Students will be loaded here dynamically -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar Setup Message (Only show if no calendar) -->
        <g:if test="${!calendar}">
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="text-center py-12">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No Calendar Set</h3>
                    <p class="text-gray-600 mb-4">Create an Awana calendar to start tracking attendance</p>
                    <button hx-get="/renderView?viewType=calendarSetup"
                            hx-target="#attendance-page-content"
                            hx-swap="innerHTML"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
                        Setup Calendar Now
                    </button>
                </div>
            </div>
        </g:if>

        <!-- Attendance Actions -->
        <div class="grid md:grid-cols-2 gap-6">
            <!-- Today's Attendance -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-900">Today's Meeting</h3>
                    <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Mark attendance for today's Awana meeting</p>
                <button class="w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-lg font-medium transition-colors">
                    Take Attendance
                </button>
            </div>

            <!-- View Records -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-900">Attendance Records</h3>
                    <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">View and analyze attendance history</p>
                <button class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-medium transition-colors">
                    View Records
                </button>
            </div>
        </div>

        <!-- Club Attendance Overview -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-6">Club Attendance Overview</h3>
            
            <div class="space-y-4">
                <g:each in="${clubs}" var="club">
                    <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <div class="w-12 h-12 ${club.name == 'Cubbies' ? 'bg-yellow-100' : 
                                                         club.name == 'Sparks' ? 'bg-orange-100' : 
                                                         club.name == 'Truth & Training' ? 'bg-blue-100' : 
                                                         'bg-purple-100'} rounded-lg flex items-center justify-center">
                                    <svg class="w-6 h-6 ${club.name == 'Cubbies' ? 'text-yellow-600' : 
                                                           club.name == 'Sparks' ? 'text-orange-600' : 
                                                           club.name == 'Truth & Training' ? 'text-blue-600' : 
                                                           'text-purple-600'}" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                    </svg>
                                </div>
                                <div>
                                    <h4 class="font-semibold text-gray-900">${club.name}</h4>
                                    <p class="text-sm text-gray-600">${club.students?.size() ?: 0} students</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-lg font-bold text-green-600">92%</div>
                                <div class="text-sm text-gray-500">Avg Attendance</div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>

        <!-- Attendance Metrics -->
        <div class="grid md:grid-cols-3 gap-6">
            <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                    </svg>
                </div>
                <div class="text-2xl font-bold text-gray-900 mb-2">87%</div>
                <div class="text-sm text-gray-600">This Month</div>
            </div>
            
            <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/>
                    </svg>
                </div>
                <div class="text-2xl font-bold text-gray-900 mb-2">${totalStudents}</div>
                <div class="text-sm text-gray-600">Total Students</div>
            </div>
            
            <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
                <div class="text-2xl font-bold text-gray-900 mb-2">12</div>
                <div class="text-sm text-gray-600">Meetings Left</div>
            </div>
        </div>
    </div>
</div>
<script>
    (function initFullCalendar() {
        console.log('FullCalendar script running...');
        const calendarEl = document.getElementById('awana-calendar');
        console.log('Calendar element found:', !!calendarEl);

        if (!calendarEl) return;

        console.log('Initializing FullCalendar...');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            headerToolbar: false, // We're using custom header

            // Theme and styling
            themeSystem: 'standard',
            height: 'auto',
            
            <g:if test="${calendar}">
            // Season date constraints
            validRange: {
                start: '<g:formatDate format="yyyy-MM-dd" date="${calendar.startDate}"/>',
                end: '<g:formatDate format="yyyy-MM-dd" date="${calendar.endDate}"/>'
            },
            initialDate: '<g:formatDate format="yyyy-MM-dd" date="${calendar.startDate}"/>',
            
            // Time settings for agenda views
            <g:if test="${calendar.startTime && calendar.endTime}">
            slotMinTime: '<fmt:timeInput time="${calendar.startTime}"/>',
            slotMaxTime: '<fmt:timeInput time="${calendar.endTime}"/>',
            </g:if>
            </g:if>

            // Event sources - load from HTMX endpoints
            events: function(info, successCallback, failureCallback) {
                console.log('FullCalendar requesting events for:', info.startStr, 'to', info.endStr);
                let url = '/renderView?viewType=calendarEvents&start=' + info.startStr + '&end=' + info.endStr;
                
                // Add student filter if active
                if (window.currentStudentFilter) {
                    url += '&studentId=' + window.currentStudentFilter;
                    console.log('Filtering calendar for student:', window.currentStudentFilter);
                }
                
                // Add club filter if active
                if (window.currentClubFilter) {
                    url += '&clubId=' + window.currentClubFilter;
                    console.log('Filtering calendar for club:', window.currentClubFilter);
                }
                
                fetch(url)
                    .then(response => {
                        console.log('Calendar events response:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('Calendar events data:', data);
                        successCallback(data.events || []);
                    })
                    .catch(error => {
                        console.error('Error loading calendar events:', error);
                        failureCallback(error);
                    });
            },
            
            <g:if test="${calendar}">
            // Highlight meeting days
            dayCellClassNames: function(arg) {
                const dayOfWeek = arg.date.toLocaleDateString('en-US', { weekday: 'long' });
                if (dayOfWeek === '${calendar.dayOfWeek}') {
                    return ['awana-meeting-day'];
                }
                return [];
            },
            </g:if>

            // Event styling
            eventClassNames: function(arg) {
                if (arg.event.extendedProps.type === 'meeting') {
                    const attendance = arg.event.extendedProps.attendanceRate || 0;
                    if (attendance >= 90) return ['awana-event-high'];
                    if (attendance >= 70) return ['awana-event-medium'];
                    if (attendance > 0) return ['awana-event-low'];
                    return ['awana-event-scheduled'];
                }
                if (arg.event.extendedProps.type === 'holiday') return ['awana-event-holiday'];
                return ['awana-event-default'];
            },

            // Click handlers
            eventClick: function(info) {
                showEventDetails(info.event);
            },
            dateClick: function(info) {
                showDateActions(info.date);
            },

            // View change handler - updates metrics sidebar and title
            datesSet: function(dateInfo) {
                window.currentDateInfo = dateInfo;  // Store current date info globally
                updateMetricsSidebar(dateInfo);
                updateCalendarTitle(dateInfo);
                updateSidebarStats(dateInfo);
            }
        });

        calendar.render();
        console.log('FullCalendar rendered successfully');

        // Store calendar globally for controls
        window.awanaCalendar = calendar;

        // Refresh events if this is a reload
        if (window.location.hash !== '#calendar-initial-load') {
            calendar.refetchEvents();
        }
        window.location.hash = '#calendar-initial-load';

        // Wire up view controls
        document.querySelectorAll('[data-calendar-view]').forEach(button => {
            button.addEventListener('click', function() {
                const view = this.getAttribute('data-calendar-view');
                calendar.changeView(view);

                // Update active button
                document.querySelectorAll('[data-calendar-view]').forEach(b => {
                    b.className = b.className.replace(
                        'bg-white text-blue-600',
                        'text-white hover:bg-white hover:bg-opacity-20'
                    );
                });
                this.className = this.className.replace(
                    'text-white hover:bg-white hover:bg-opacity-20',
                    'bg-white text-blue-600'
                );
            });
        });

        // Wire up navigation controls
        document.querySelector('[data-calendar-prev]')?.addEventListener('click', () => calendar.prev());
        document.querySelector('[data-calendar-next]')?.addEventListener('click', () => calendar.next());

        // Refresh calendar after HTMX swaps
        document.body.addEventListener('htmx:afterSwap', function(evt) {
            if (evt.detail.target.id === 'attendance-page-content') {
                setTimeout(() => {
                    if (window.awanaCalendar) {
                        window.awanaCalendar.refetchEvents();
                    }
                }, 100);
            }
        });
    })();

    // Calendar helper functions
    function showEventDetails(event) {
        console.log('Event clicked:', event);
        console.log('Event type:', event.extendedProps?.type);
        
        // Check if this is an Awana meeting event
        if (event.extendedProps?.type === 'meeting') {
            console.log('Awana meeting event clicked! Loading attendance...');
            // Get the date from the event and format as yyyy-MM-dd
            let meetingDate;
            if (event.start instanceof Date) {
                meetingDate = event.start.toISOString().split('T')[0];
            } else if (event.startStr) {
                meetingDate = event.startStr.split('T')[0];
            } else {
                meetingDate = new Date(event.start).toISOString().split('T')[0];
            }
            console.log('Meeting date from event:', meetingDate);
            
            // Navigate to attendance management for this date
            htmx.ajax('GET', '/renderView?viewType=attendanceManagement&meetingDate=' + meetingDate, {
                target: '#attendance-page-content',
                swap: 'innerHTML'
            });
        } else {
            console.log('Non-meeting event clicked, showing details...');
            // TODO: Show event details modal/sidebar for other events
        }
    }

    function showDateActions(date) {
        console.log('Date clicked:', date);
        console.log('Date type:', typeof date);
        
        // Check if this is an Awana meeting day
        const dayOfWeek = date.toLocaleDateString('en-US', { weekday: 'long' });
        console.log('Day of week:', dayOfWeek);
        
        <g:if test="${calendar}">
        console.log('Calendar day of week: ${calendar.dayOfWeek}');
        if (dayOfWeek === '${calendar.dayOfWeek}') {
            console.log('This is an Awana meeting day! Loading attendance...');
            // Navigate to attendance management for this date
            const meetingDate = date.toISOString().split('T')[0];
            console.log('Meeting date:', meetingDate);
            htmx.ajax('GET', '/renderView?viewType=attendanceManagement&meetingDate=' + meetingDate, {
                target: '#attendance-page-content',
                swap: 'innerHTML'
            });
        } else {
            console.log('Not a meeting day (' + dayOfWeek + ' !== ${calendar.dayOfWeek}) - no attendance available');
        }
        </g:if>
        <g:else>
        console.log('No calendar configured');
        </g:else>
    }

    function updateMetricsSidebar(dateInfo) {
        console.log('Update metrics for date range:', dateInfo);
        // TODO: Load metrics via HTMX based on current date range
    }
    
    function updateCalendarTitle(dateInfo) {
        const titleElement = document.getElementById('calendar-title');
        if (titleElement && window.awanaCalendar) {
            const currentDate = window.awanaCalendar.getDate();
            const formatter = new Intl.DateTimeFormat('en-US', { month: 'long', year: 'numeric' });
            titleElement.textContent = formatter.format(currentDate);
        }
    }

    // Global variables for calendar state
    window.currentCalendarView = 'all'; // 'all', 'club', 'student'
    window.currentClubId = null;
    window.currentStudentId = null;
    window.currentDateInfo = null;

    // Show students for a specific club
    function showClubStudents(clubId, clubName) {
        console.log('Showing students for club:', clubId, clubName);
        
        // Update state
        window.currentCalendarView = 'club';
        window.currentClubId = clubId;
        window.currentClubFilter = clubId;
        
        // Clear student filter when switching to club view
        window.currentStudentFilter = null;
        
        // Update sidebar UI
        document.getElementById('sidebar-title').textContent = clubName;
        document.getElementById('sidebar-subtitle').textContent = 'Click a student to filter calendar';
        document.getElementById('sidebar-back-btn').style.display = 'flex';
        document.getElementById('calendar-view-subtitle').textContent = `Viewing ${clubName} attendance data`;
        
        // Update calendar to show club-specific data
        if (window.awanaCalendar) {
            window.awanaCalendar.refetchEvents();
        }
        
        // Hide clubs, show loading
        document.getElementById('clubs-view').style.display = 'none';
        document.getElementById('students-view').style.display = 'block';
        document.getElementById('students-view').innerHTML = '<div class="text-center py-4 text-gray-500">Loading students...</div>';
        
        // Load students via HTMX with current date range
        let url = '/renderView?viewType=sidebarClubStudents&clubId=' + clubId;
        if (window.currentDateInfo) {
            url += '&start=' + window.currentDateInfo.startStr + '&end=' + window.currentDateInfo.endStr;
        }
        htmx.ajax('GET', url, {
            target: '#students-view',
            swap: 'innerHTML'
        });
    }

    // Show individual student's attendance on calendar
    function showStudentCalendar(studentId, studentName) {
        console.log('Filtering calendar for student:', studentId, studentName);
        
        // Update state
        window.currentCalendarView = 'student';
        window.currentStudentId = studentId;
        window.currentStudentFilter = studentId;
        
        // Clear club filter when switching to student view
        window.currentClubFilter = null;
        
        // Update UI
        document.getElementById('calendar-view-subtitle').textContent = `Viewing ${studentName}'s attendance`;
        
        // Update calendar to show only this student's events
        if (window.awanaCalendar) {
            window.awanaCalendar.refetchEvents();
        }
        
        // Update metrics for this student
        updateMetricsForStudent(studentId);
    }

    // Reset calendar to show all data
    function resetCalendarView() {
        console.log('Resetting calendar to full view');
        
        // Update state
        window.currentCalendarView = 'all';
        window.currentClubId = null;
        window.currentStudentId = null;
        window.currentStudentFilter = null;
        window.currentClubFilter = null;
        
        // Reset sidebar UI
        document.getElementById('sidebar-title').textContent = 'Clubs';
        document.getElementById('sidebar-subtitle').textContent = 'Click a club to view students';
        document.getElementById('sidebar-back-btn').style.display = 'none';
        document.getElementById('calendar-view-subtitle').textContent = 'Manage Awana calendar, track attendance, and view metrics';
        
        // Show clubs, hide students
        document.getElementById('clubs-view').style.display = 'block';
        document.getElementById('students-view').style.display = 'none';
        
        // Reset calendar to show all events
        if (window.awanaCalendar) {
            window.awanaCalendar.refetchEvents();
        }
        
        // Reset metrics to overall data
        resetMetricsToOverall();
    }

    // Update metrics for individual student
    function updateMetricsForStudent(studentId) {
        // This would fetch student-specific metrics
        // For now, just update the display
        document.getElementById('total-students-metric').textContent = '1';
        document.getElementById('total-students-metric').nextElementSibling.textContent = 'Selected Student';
    }

    // Reset metrics to overall data
    function resetMetricsToOverall() {
        document.getElementById('total-students-metric').textContent = '${totalStudents ?: 0}';
        document.getElementById('total-students-metric').nextElementSibling.textContent = 'Total Students';
    }

    // Update sidebar stats based on current calendar view period
    function updateSidebarStats(dateInfo) {
        console.log('Updating sidebar stats for period:', dateInfo.startStr, 'to', dateInfo.endStr);
        
        // Call the new endpoint with current view dates
        fetch('/renderView?viewType=updateSidebarStats&start=' + dateInfo.startStr + '&end=' + dateInfo.endStr)
            .then(response => response.json())
            .then(clubRates => {
                console.log('Received sidebar stats:', clubRates);
                
                // Update each club's percentage in the sidebar
                Object.entries(clubRates).forEach(([clubId, rate]) => {
                    console.log('Updating club', clubId, 'to', rate + '%');
                    // Find the club element and update its percentage
                    const clubElements = document.querySelectorAll('[onclick*="showClubStudents(\'' + clubId + '\',"]');
                    console.log('Found', clubElements.length, 'club elements for club', clubId);
                    clubElements.forEach(clubEl => {
                        const rateElement = clubEl.querySelector('.text-lg.font-bold');
                        if (rateElement) {
                            console.log('Updating rate element from', rateElement.textContent, 'to', rate + '%');
                            rateElement.textContent = rate + '%';
                        } else {
                            console.log('No rate element found for club', clubId);
                        }
                    });
                });
            })
            .catch(error => {
                console.error('Error updating sidebar stats:', error);
            });
    }
</script>


<!-- Custom CSS for calendar events using Tailwind colors -->
<style>
.awana-event-high {
    background-color: rgb(16 185 129) !important; /* green-500 */
    border-color: rgb(5 150 105) !important;       /* green-600 */
}

.awana-event-medium {
    background-color: rgb(245 158 11) !important;  /* amber-500 */
    border-color: rgb(217 119 6) !important;       /* amber-600 */
}

.awana-event-low {
    background-color: rgb(239 68 68) !important;   /* red-500 */
    border-color: rgb(220 38 38) !important;       /* red-600 */
}

.awana-event-scheduled {
    background-color: rgb(107 114 128) !important; /* gray-500 */
    border-color: rgb(75 85 99) !important;        /* gray-600 */
}

.awana-event-holiday {
    background-color: rgb(139 92 246) !important;  /* violet-500 */
    border-color: rgb(124 58 237) !important;      /* violet-600 */
}

.fc-daygrid-event {
    border-radius: 4px !important;
    font-size: 12px !important;
    font-weight: 500 !important;
}

.fc-daygrid-event-harness {
    margin: 1px !important;
}

/* Highlight meeting days */
.awana-meeting-day {
    background-color: rgb(239 246 255) !important; /* blue-50 */
    border: 1px solid rgb(147 197 253) !important; /* blue-300 */
}

.awana-meeting-day:hover {
    background-color: rgb(219 234 254) !important; /* blue-100 */
}
</style>