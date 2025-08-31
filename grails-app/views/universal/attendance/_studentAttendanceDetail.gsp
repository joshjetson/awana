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

    <!-- Quick Attendance Edit -->
    <div class="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
        <div class="flex items-center justify-between">
            <h4 class="font-medium text-gray-900">Quick Edit</h4>
            <div class="flex items-center space-x-4">
                <form <g:if test="${attendance?.id}">hx-put="/api/universal/Attendance/${attendance.id}?domainName=Attendance&viewType=studentAttendanceDetail&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"</g:if><g:else>hx-post="/api/universal/Attendance?domainName=Attendance&viewType=studentAttendanceDetail&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"</g:else>
                      hx-target="#attendance-content-area"
                      hx-swap="innerHTML"
                      hx-indicator="#save-indicator" 
                      class="flex items-center space-x-3">
                    
                    <input type="hidden" name="student.id" value="${student.id}">
                    <input type="hidden" name="calendar.id" value="${calendar?.id}">
                    <input type="hidden" name="attendanceDate" value="<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>">
                    
                    <div class="flex items-center space-x-2">
                        <input type="radio" name="present" value="true" id="present-yes" ${attendance?.present ? 'checked' : ''} class="w-4 h-4 text-green-600">
                        <label for="present-yes" class="text-sm text-green-700 font-medium">Present</label>
                    </div>
                    <div class="flex items-center space-x-2">
                        <input type="radio" name="present" value="false" id="present-no" ${attendance?.present == false ? 'checked' : ''} class="w-4 h-4 text-red-600">
                        <label for="present-no" class="text-sm text-red-700 font-medium">Absent</label>
                    </div>
                    
                    <div id="extras" class="flex items-center space-x-2" style="${attendance?.present ? '' : 'display: none;'}">
                        <input type="checkbox" name="hasUniform" value="true" id="uniform" ${attendance?.hasUniform ? 'checked' : ''} class="w-4 h-4 text-blue-600">
                        <label for="uniform" class="text-xs text-gray-600">Uniform</label>
                        <input type="checkbox" name="hasBible" value="true" id="bible" ${attendance?.hasBible ? 'checked' : ''} class="w-4 h-4 text-purple-600">
                        <label for="bible" class="text-xs text-gray-600">Bible</label>
                        <input type="checkbox" name="hasHandbook" value="true" id="handbook" ${attendance?.hasHandbook ? 'checked' : ''} class="w-4 h-4 text-orange-600">
                        <label for="handbook" class="text-xs text-gray-600">Handbook</label>
                    </div>
                    
                    <button type="submit" class="px-3 py-1 bg-blue-600 hover:bg-blue-700 text-white text-sm rounded">
                        <span id="save-indicator" class="htmx-indicator">
                            <svg class="animate-spin w-4 h-4 mr-1 inline" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                        </span>
                        Save
                    </button>
                </form>
                
                <g:if test="${attendance?.id}">
                    <button hx-delete="/api/universal/Attendance/${attendance.id}?viewType=studentAttendanceDetail&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"
                            hx-target="#attendance-content-area"
                            hx-swap="innerHTML"
                            hx-confirm="Delete this attendance record?"
                            class="px-2 py-1 bg-red-600 hover:bg-red-700 text-white text-xs rounded">×</button>
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

<script>
// Show/hide extras based on attendance status
document.addEventListener('change', function(e) {
    if (e.target.name === 'present') {
        const extras = document.getElementById('extras');
        if (e.target.value === 'true') {
            extras.style.display = 'flex';
        } else {
            extras.style.display = 'none';
            // Clear checkboxes when hiding
            extras.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
        }
    }
});
</script>