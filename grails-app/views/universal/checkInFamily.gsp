<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Family Check-In</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body>

<content tag="nav">
    <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2">
            <g:link uri="/checkin" class="flex items-center space-x-2 text-blue-600 hover:text-blue-800">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
                <span class="font-semibold">Back to Check-In</span>
            </g:link>
        </div>
        <span class="font-bold text-lg text-gray-900">Family Check-In</span>
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
        </g:link>
    </div>
</content>

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-green-50 pb-20">
    <div class="max-w-4xl mx-auto px-4 py-6">
        
        <!-- Include the family check-in template -->
        <g:render template="familyCheckIn" model="[household: household, students: students, attendanceMap: attendanceMap, today: today]"/>
        
    </div>
</div>

</body>
</html>