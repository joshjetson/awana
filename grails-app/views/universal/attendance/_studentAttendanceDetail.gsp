<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=attendanceClubOverview&meetingDate=${meetingDate}"
            hx-target="#attendance-content-area"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to Clubs</span>
    </button>
</div>

<!-- Student Attendance Detail -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <!-- Student Header -->
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center space-x-4">
            <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold text-xl">
                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
            </div>
            <div>
                <h2 class="text-2xl font-bold text-gray-900">${student.firstName} ${student.lastName}</h2>
                <p class="text-gray-600">${student.getAge()} years old • ${student.club?.name ?: 'No Club'}</p>
                <p class="text-sm text-gray-500">${student.household.name} • <g:formatDate format="MMMM dd, yyyy" date="${meetingDate}"/></p>
            </div>
        </div>
    </div>

    <!-- Attendance Status for This Meeting -->
    <div class="grid md:grid-cols-2 gap-6 mb-8">
        <!-- Attendance Status -->
        <div class="bg-gray-50 rounded-lg p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Meeting Attendance</h3>
            
            <g:if test="${attendance}">
                <div class="space-y-4">
                    <!-- Present Status -->
                    <div class="flex items-center justify-between">
                        <span class="text-gray-700">Present</span>
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${attendance.present ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                            ${attendance.present ? 'Present' : 'Absent'}
                        </span>
                    </div>
                    
                    <g:if test="${attendance.present}">
                        <!-- Additional Items -->
                        <div class="space-y-2">
                            <div class="flex items-center justify-between">
                                <span class="text-gray-700">Uniform</span>
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${attendance.hasUniform ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 text-gray-600'}">
                                    ${attendance.hasUniform ? 'Yes' : 'No'}
                                </span>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-gray-700">Bible</span>
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${attendance.hasBible ? 'bg-purple-100 text-purple-800' : 'bg-gray-100 text-gray-600'}">
                                    ${attendance.hasBible ? 'Yes' : 'No'}
                                </span>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-gray-700">Handbook</span>
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${attendance.hasHandbook ? 'bg-orange-100 text-orange-800' : 'bg-gray-100 text-gray-600'}">
                                    ${attendance.hasHandbook ? 'Yes' : 'No'}
                                </span>
                            </div>
                        </div>
                    </g:if>
                </div>
            </g:if>
            <g:else>
                <div class="text-center py-6 text-gray-500">
                    <svg class="w-12 h-12 mx-auto mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <p class="font-medium">No attendance record</p>
                    <p class="text-sm">This student was not recorded for this meeting</p>
                </div>
            </g:else>
        </div>

        <!-- Bucks Earned -->
        <div class="bg-green-50 rounded-lg p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Awana Bucks Earned</h3>
            
            <div class="text-center">
                <div class="text-4xl font-bold text-green-600 mb-2">
                    ${attendance?.bucksEarned ?: 0}
                </div>
                <p class="text-gray-600">Bucks from this meeting</p>
                
                <g:if test="${attendance?.present}">
                    <div class="mt-4 space-y-1 text-sm text-gray-600">
                        <div class="flex justify-between">
                            <span>Present:</span>
                            <span>+1 buck</span>
                        </div>
                        <g:if test="${attendance.hasUniform}">
                            <div class="flex justify-between">
                                <span>Uniform:</span>
                                <span>+1 buck</span>
                            </div>
                        </g:if>
                        <g:if test="${attendance.hasBible && attendance.hasHandbook}">
                            <div class="flex justify-between">
                                <span>Bible + Handbook:</span>
                                <span>+1 buck</span>
                            </div>
                        </g:if>
                    </div>
                </g:if>
            </div>
        </div>
    </div>

    <!-- Student Summary Stats -->
    <div class="border-t pt-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Overall Statistics</h3>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="text-center p-4 bg-blue-50 rounded-lg">
                <div class="text-2xl font-bold text-blue-600">${student.calculateTotalBucks()}</div>
                <div class="text-sm text-blue-800">Total Bucks</div>
            </div>
            <div class="text-center p-4 bg-green-50 rounded-lg">
                <div class="text-2xl font-bold text-green-600">${student.attendances?.size() ?: 0}</div>
                <div class="text-sm text-green-800">Meetings Attended</div>
            </div>
            <div class="text-center p-4 bg-purple-50 rounded-lg">
                <div class="text-2xl font-bold text-purple-600">${student.sectionVerseCompletions?.size() ?: 0}</div>
                <div class="text-sm text-purple-800">Verses Completed</div>
            </div>
            <div class="text-center p-4 bg-orange-50 rounded-lg">
                <div class="text-2xl font-bold text-orange-600">
                    ${student.attendances ? Math.round((student.attendances.count { it.present } / student.attendances.size()) * 100) : 0}%
                </div>
                <div class="text-sm text-orange-800">Attendance Rate</div>
            </div>
        </div>
    </div>
</div>