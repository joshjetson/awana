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
        
        <!-- Primary Action - QR Code Check-In -->
        <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-green-500">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h2 class="text-xl font-bold text-gray-900">Quick Check-In</h2>
                    <p class="text-gray-600">Scan QR code to check in families</p>
                </div>
                <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/>
                    </svg>
                </div>
            </div>
            <g:set var="qrIcon"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/></svg></g:set>
            <g:render template="/components/touchButton" model="[
                text: 'Scan Family QR Code',
                style: 'success', 
                size: 'lg',
                icon: qrIcon,
                href: '/checkin'
            ]"/>
        </div>

        <!-- Club Overview Cards -->
        <div class="grid md:grid-cols-2 gap-4">
            <g:each in="${clubs}" var="club">
                <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-lg transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <h3 class="text-lg font-bold text-gray-900">${club.name}</h3>
                            <p class="text-sm text-gray-600">${club.ageRange}</p>
                        </div>
                        <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4 text-sm">
                        <div>
                            <div class="text-2xl font-bold text-gray-900">${club.students?.size() ?: 0}</div>
                            <div class="text-gray-600">Students</div>
                        </div>
                        <div>
                            <div class="text-2xl font-bold text-green-600">${club.students?.sum { it.calculateTotalBucks() } ?: 0}</div>
                            <div class="text-gray-600">Total Bucks</div>
                        </div>
                    </div>
                    <div class="mt-4">
                        <button class="w-full bg-blue-50 hover:bg-blue-100 text-blue-700 font-medium py-2 px-4 rounded-lg transition-colors">
                            Manage ${club.name}
                        </button>
                    </div>
                </div>
            </g:each>
        </div>

        <!-- Recent Families -->
        <div class="bg-white rounded-xl shadow-md p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900">Registered Families</h2>
                <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
                    ${householdCount} families
                </span>
            </div>
            
            <div class="space-y-4">
                <g:each in="${households}" var="household">
                    <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors">
                        <div class="flex items-center justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center text-white font-bold">
                                        ${household.name.substring(0, 2).toUpperCase()}
                                    </div>
                                    <div>
                                        <h3 class="font-semibold text-gray-900">${household.name}</h3>
                                        <p class="text-sm text-gray-600">${household.students?.size() ?: 0} students</p>
                                    </div>
                                </div>
                                <div class="mt-2 flex flex-wrap gap-2">
                                    <g:each in="${household.students}" var="student">
                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium 
                                            ${student.club.name == 'Cubbies' ? 'bg-yellow-100 text-yellow-800' :
                                              student.club.name == 'Sparks' ? 'bg-orange-100 text-orange-800' :
                                              student.club.name == 'Truth & Training' ? 'bg-blue-100 text-blue-800' :
                                              'bg-purple-100 text-purple-800'}">
                                            ${student.firstName} (${student.club.name})
                                        </span>
                                    </g:each>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-lg font-bold text-green-600">
                                    ${household.getTotalFamilyBucks()} bucks
                                </div>
                                <button class="mt-2 bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                                    Check In
                                </button>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
            <button class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center">
                <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Awana Store</div>
                <div class="text-sm text-gray-600">Manage Rewards</div>
            </button>

            <button onclick="showStudentSearch()" class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center w-full">
                <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Student Management</div>
                <div class="text-sm text-gray-600">Search & Track Progress</div>
            </button>

            <button class="bg-white p-4 rounded-xl shadow-md hover:shadow-lg transition-shadow text-center">
                <div class="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                    </svg>
                </div>
                <div class="font-medium text-gray-900">Reports</div>
                <div class="text-sm text-gray-600">View Analytics</div>
            </button>
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
window.showClubOverview = showClubOverview;
window.showVerseCompletion = showVerseCompletion;
window.hideSpaContent = hideSpaContent;
</script>

</body>
</html>