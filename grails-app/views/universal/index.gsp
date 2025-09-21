<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Awana Club Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body>

<content tag="nav">
    <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2">
            <div class="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                </svg>
            </div>
            <span class="font-semibold text-gray-900">Awana Club</span>
        </div>
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
        </g:link>
    </div>
</content>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Quick Stats Header -->
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Club Dashboard</h1>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                <div>
                    <div class="text-2xl font-bold">${studentCount}</div>
                    <div class="text-blue-100 text-sm">Active Students</div>
                </div>
                <div>
                    <div class="text-2xl font-bold">${householdCount}</div>
                    <div class="text-blue-100 text-sm">Families</div>
                </div>
                <div>
                    <div class="text-2xl font-bold">${clubCount}</div>
                    <div class="text-blue-100 text-sm">Clubs</div>
                </div>
                <div>
                    <div class="text-2xl font-bold"><g:formatDate date="${new Date()}" format="MMM d"/></div>
                    <div class="text-blue-100 text-sm">Today</div>
                </div>
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">

        <!-- Today's Daily Activity -->
        <div class="bg-white rounded-xl shadow-md p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900">Today's Activity</h2>
                <div class="flex items-center space-x-2">
                    <div class="w-3 h-3 bg-green-400 rounded-full"></div>
                    <span class="text-sm text-gray-600">Live Updates</span>
                </div>
            </div>

            <!-- Real-time Activity List -->
            <div id="activity-feed" class="space-y-3">
                <div class="text-center py-8 text-gray-500">
                    <svg class="w-12 h-12 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <p class="text-lg font-medium">No activity yet today</p>
                    <p class="text-sm">Activity will appear here as students check in and complete tasks</p>
                </div>
            </div>
        </div>

        <!-- Club Performance Today -->
        <div class="bg-white rounded-xl shadow-md p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6">Club Performance Today</h2>
            <div class="grid md:grid-cols-2 gap-4">
                <g:each in="${clubs}" var="club">
                    <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                        <div class="flex items-center justify-between mb-4">
                            <div>
                                <h3 class="text-lg font-bold text-gray-900">${club.name}</h3>
                                <p class="text-sm text-gray-600">${club.ageRange} • ${club.students?.size() ?: 0} students</p>
                            </div>
                            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-500 rounded-lg flex items-center justify-center">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                </svg>
                            </div>
                        </div>

                        <!-- Today's Club Metrics -->
                        <div class="grid grid-cols-3 gap-3 text-sm mb-4">
                            <div class="text-center p-3 bg-green-50 rounded-lg">
                                <div class="text-lg font-bold text-green-600 club-attendance" data-club-id="${club.id}">0</div>
                                <div class="text-green-800 text-xs">Present</div>
                            </div>
                            <div class="text-center p-3 bg-yellow-50 rounded-lg">
                                <div class="text-lg font-bold text-yellow-600 club-bucks" data-club-id="${club.id}">0</div>
                                <div class="text-yellow-800 text-xs">Bucks</div>
                            </div>
                            <div class="text-center p-3 bg-purple-50 rounded-lg">
                                <div class="text-lg font-bold text-purple-600 club-verses" data-club-id="${club.id}">0</div>
                                <div class="text-purple-800 text-xs">Verses</div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
            <a href="/checkin" class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center">
                <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Check In</div>
                <div class="text-sm text-gray-600">Family QR Scan</div>
            </a>

            <a href="/students" class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center">
                <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Students</div>
                <div class="text-sm text-gray-600">Manage Progress</div>
            </a>

            <a href="/clubs" class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center">
                <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Clubs</div>
                <div class="text-sm text-gray-600">Club Management</div>
            </a>
        </div>

    </div>
    
    <!-- Dynamic Content Area for SPA -->
    <div id="spa-content" class="max-w-4xl mx-auto px-4 py-6" style="display: none;">
        <div class="flex items-center justify-between mb-4">
            <button onclick="hideSpaContent()" class="flex items-center space-x-2 text-blue-600 hover:text-blue-800">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to Dashboard</span>
            </button>
        </div>
        <div id="dynamic-content">
            <!-- Dynamic views load here -->
        </div>
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'dashboard']"/>

<script>
// SPA functionality
function showStudentSearch() {
    // Load student search view
    htmx.ajax('GET', '/renderView', {
        values: { viewType: 'studentSearch' },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.querySelector('.min-h-screen').style.display = 'none';
        document.getElementById('spa-content').style.display = 'block';
    });
}

// Functions are now defined globally in application.js

function hideSpaContent() {
    document.getElementById('spa-content').style.display = 'none';
    document.querySelector('.min-h-screen').style.display = 'block';
}

// Make these functions available globally for the rendered views
// window.showClubOverview = showClubOverview; // Not used in this dashboard
// window.showVerseCompletion = showVerseCompletion; // Not used in this dashboard
window.hideSpaContent = hideSpaContent;

// Simple test - load today's attendance count and display it
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format

    fetch('/api/universal/Attendance?format=json')
        .then(response => response.json())
        .then(data => {
            // Filter for today's attendance where present=true
            const todayAttendance = data.filter(attendance => {
                const attendanceDate = new Date(attendance.attendanceDate).toISOString().split('T')[0];
                return attendanceDate === today && attendance.present === true;
            });

            console.log('Today attendance count:', todayAttendance.length);

            // Update the dashboard if the element exists
            const todayAttendanceElement = document.getElementById('today-attendance');
            if (todayAttendanceElement) {
                todayAttendanceElement.textContent = todayAttendance.length;
            }
        })
        .catch(error => {
            console.error('API test failed:', error);
        });
});
</script>

</body>
</html>