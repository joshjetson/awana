<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=attendanceClubOverview&meetingDate=${meetingDate}"
            hx-target="${targetElement ?: '#attendance-content-area'}"
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
    <!-- Student Summary Stats -->
    <div class="border-t pt-6 mb-3">

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


    <!-- Touch-Optimized Attendance Edit -->
    <div class="border border-gray-200 rounded-xl p-4 hover:bg-gray-50 transition-colors">
        <!-- Student Header -->
        <div class="flex items-center justify-between mb-4">

            <!-- Current Status -->
            <div class="text-right">
                <g:if test="${attendance?.present}">
                    <div class="flex items-center text-green-600">
                        <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="font-medium">Checked In</span>
                    </div>
                </g:if>
                <g:else>
                    <div class="flex items-center text-gray-500">
                        <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="font-medium">Not Checked In</span>
                    </div>
                </g:else>
            </div>
        </div>

        <form <g:if test="${attendance?.id}">hx-put="/api/universal/Attendance/${attendance.id}?domainName=Attendance&viewType=checkinStudent&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"</g:if><g:else>hx-post="/api/universal/Attendance?domainName=Attendance&viewType=checkinStudent&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"</g:else>
              hx-target="${targetElement ?: '#attendance-content-area'}"
              hx-swap="innerHTML"
              hx-indicator="#save-indicator">
              
            <input type="hidden" name="student.id" value="${student.id}">
            <input type="hidden" name="calendar.id" value="${calendar?.id}">
            <input type="hidden" name="attendanceDate" value="<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>">

            <!-- Present/Absent Selection -->
            <div class="grid grid-cols-2 gap-3 mb-4">
                <div class="attendance-toggle ${attendance?.present ? 'bg-green-100 text-green-700 ring-2 ring-green-300' : 'bg-gray-100 text-gray-700'}
                           min-h-[60px] rounded-lg font-medium transition-all duration-200
                           hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                           flex flex-col items-center justify-center space-y-1 cursor-pointer"
                     data-input-id="present-yes">
                    <input type="radio" name="present" value="true" id="present-yes" ${attendance?.present ? 'checked' : ''}
                           class="sr-only">
                    <svg class="w-6 h-6 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    <span class="text-sm font-bold pointer-events-none">Present</span>
                    <span class="text-xs pointer-events-none">+1 buck</span>
                </div>

                <div class="attendance-toggle ${attendance?.present == false ? 'bg-red-100 text-red-700 ring-2 ring-red-300' : 'bg-gray-100 text-gray-700'}
                           min-h-[60px] rounded-lg font-medium transition-all duration-200
                           hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                           flex flex-col items-center justify-center space-y-1 cursor-pointer"
                     data-input-id="present-no">
                    <input type="radio" name="present" value="false" id="present-no" ${attendance?.present == false ? 'checked' : ''}
                           class="sr-only">
                    <svg class="w-6 h-6 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728L5.636 5.636m12.728 12.728L18.364 5.636M5.636 18.364l12.728-12.728"></path>
                    </svg>
                    <span class="text-sm font-bold pointer-events-none">Absent</span>
                    <span class="text-xs pointer-events-none">0 bucks</span>
                </div>
            </div>

            <!-- Additional Items (shown only when present) -->
            <div id="extras" class="grid grid-cols-3 gap-3 mb-4" style="${attendance?.present ? '' : 'display: none;'}">
                
                <!-- Uniform Toggle -->
                <div class="attendance-toggle ${attendance?.hasUniform ? 'bg-blue-100 text-blue-700 ring-2 ring-blue-300' : 'bg-gray-100 text-gray-700'}
                           min-h-[60px] rounded-lg font-medium transition-all duration-200
                           hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                           flex flex-col items-center justify-center space-y-1 cursor-pointer"
                     data-input-id="uniform">
                    <input type="checkbox" name="hasUniform" value="true" id="uniform" ${attendance?.hasUniform ? 'checked' : ''}
                           class="sr-only">
                    <svg class="w-5 h-5 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zM7 3H5a2 2 0 00-2 2v12a4 4 0 004 4h2V3z"></path>
                    </svg>
                    <span class="text-xs pointer-events-none">Uniform</span>
                    <span class="text-xs font-bold pointer-events-none">+1</span>
                </div>

                <!-- Bible Toggle -->
                <div class="attendance-toggle ${attendance?.hasBible ? 'bg-purple-100 text-purple-700 ring-2 ring-purple-300' : 'bg-gray-100 text-gray-700'}
                           min-h-[60px] rounded-lg font-medium transition-all duration-200
                           hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                           flex flex-col items-center justify-center space-y-1 cursor-pointer"
                     data-input-id="bible">
                    <input type="checkbox" name="hasBible" value="true" id="bible" ${attendance?.hasBible ? 'checked' : ''}
                           class="sr-only">
                    <svg class="w-5 h-5 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                    </svg>
                    <span class="text-xs pointer-events-none">Bible</span>
                    <span class="text-xs font-bold pointer-events-none">+1*</span>
                </div>

                <!-- Handbook Toggle -->
                <div class="attendance-toggle ${attendance?.hasHandbook ? 'bg-orange-100 text-orange-700 ring-2 ring-orange-300' : 'bg-gray-100 text-gray-700'}
                           min-h-[60px] rounded-lg font-medium transition-all duration-200
                           hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                           flex flex-col items-center justify-center space-y-1 cursor-pointer"
                     data-input-id="handbook">
                    <input type="checkbox" name="hasHandbook" value="true" id="handbook" ${attendance?.hasHandbook ? 'checked' : ''}
                           class="sr-only">
                    <svg class="w-5 h-5 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                    <span class="text-xs pointer-events-none">Handbook</span>
                    <span class="text-xs font-bold pointer-events-none">+1*</span>
                </div>
            </div>

            <!-- Save Button -->
            <div class="flex items-center justify-between">
                <div class="text-xs text-gray-500">
                    *Bible + Handbook = +1 buck total
                </div>
                
                <button type="submit" class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg 
                                         transition-colors duration-200 flex items-center space-x-2">
                    <span id="save-indicator" class="htmx-indicator">
                        <svg class="animate-spin w-4 h-4 mr-1 inline" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    <span>Save Changes</span>
                </button>
            </div>
        </form>

        <!-- Delete Button (if attendance exists) -->
        <g:if test="${attendance?.id}">
            <div class="mt-4 pt-4 border-t border-gray-200">
                <button hx-delete="/api/universal/Attendance/${attendance.id}?viewType=checkinStudent&refreshStudentId=${student.id}&meetingDate=<g:formatDate format='yyyy-MM-dd' date='${meetingDate}'/>&clubId=${student.club?.id}"
                        hx-target="${targetElement ?: '#attendance-content-area'}"
                        hx-swap="innerHTML"
                        hx-confirm="Delete this attendance record?"
                        class="text-red-600 hover:text-red-800 text-sm font-medium">
                    Delete Attendance Record
                </button>
            </div>
        </g:if>
    </div>

</div>

<script>
// Function to update button appearance based on its checked state
function updateButtonAppearance(input) {
    const button = input.closest('.attendance-toggle');
    const isChecked = input.checked;
    
    // Remove all color classes first
    button.classList.remove(
        'bg-gray-100', 'text-gray-700',
        'bg-green-100', 'text-green-700', 'ring-2', 'ring-green-300',
        'bg-red-100', 'text-red-700', 'ring-red-300',
        'bg-blue-100', 'text-blue-700', 'ring-blue-300',
        'bg-purple-100', 'text-purple-700', 'ring-purple-300',
        'bg-orange-100', 'text-orange-700', 'ring-orange-300'
    );
    
    if (isChecked) {
        // Apply active colors based on input name
        if (input.name === 'present' && input.value === 'true') {
            button.classList.add('bg-green-100', 'text-green-700', 'ring-2', 'ring-green-300');
        } else if (input.name === 'present' && input.value === 'false') {
            button.classList.add('bg-red-100', 'text-red-700', 'ring-2', 'ring-red-300');
        } else if (input.name === 'hasUniform') {
            button.classList.add('bg-blue-100', 'text-blue-700', 'ring-2', 'ring-blue-300');
        } else if (input.name === 'hasBible') {
            button.classList.add('bg-purple-100', 'text-purple-700', 'ring-2', 'ring-purple-300');
        } else if (input.name === 'hasHandbook') {
            button.classList.add('bg-orange-100', 'text-orange-700', 'ring-2', 'ring-orange-300');
        }
    } else {
        // Apply inactive colors
        button.classList.add('bg-gray-100', 'text-gray-700');
    }
}

// Handle clicks on the entire button container
document.addEventListener('click', function(e) {
    // Check if we clicked on a button container with data-input-id
    const button = e.target.closest('.attendance-toggle[data-input-id]');
    if (button) {
        const inputId = button.getAttribute('data-input-id');
        const input = document.getElementById(inputId);
        
        if (input) {
            if (input.type === 'radio') {
                // For radio buttons, just check this one
                input.checked = true;
                
                // Update all present/absent buttons
                document.querySelectorAll('input[name="present"]').forEach(function(radio) {
                    updateButtonAppearance(radio);
                });
                
                // Show/hide extras based on selection
                const extras = document.getElementById('extras');
                if (input.value === 'true') {
                    extras.style.display = 'grid';
                } else {
                    extras.style.display = 'none';
                    // Clear and update appearance of checkboxes when hiding
                    extras.querySelectorAll('input[type="checkbox"]').forEach(function(cb) {
                        cb.checked = false;
                        updateButtonAppearance(cb);
                    });
                }
                
            } else if (input.type === 'checkbox') {
                // For checkboxes, toggle the state
                input.checked = !input.checked;
                updateButtonAppearance(input);
            }
        }
    }
});

// Initialize button appearances on page load
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.attendance-toggle input').forEach(function(input) {
        updateButtonAppearance(input);
    });
});
</script>
