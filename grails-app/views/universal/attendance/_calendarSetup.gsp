<%-- 
Calendar Setup Form Component
Loaded via: /renderView?viewType=calendarSetup
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-blue-600 to-green-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Setup Awana Calendar</h1>
            <div class="text-blue-100">
                Configure the dates and schedule for your Awana season
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6">
        
        <!-- Back Button -->
        <div class="bg-white rounded-xl shadow-lg p-4 mb-6">
            <button hx-get="/renderView?viewType=attendance"
                    hx-target="#attendance-page-content"
                    hx-swap="innerHTML"
                    class="flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to Attendance</span>
            </button>
        </div>

        <!-- Calendar Setup Form -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-900">
                        <g:if test="${calendar}">
                            Update Awana Calendar (ID: ${calendar.id})
                        </g:if>
                        <g:else>
                            Create Awana Calendar
                        </g:else>
                    </h2>
                    <p class="text-gray-600">Set up the schedule for your Awana season</p>
                </div>
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-green-500 rounded-lg flex items-center justify-center text-white">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                </div>
            </div>

            <form <g:if test="${calendar}">hx-put="/api/universal/Calendar/${calendar.id}?domainName=Calendar&viewType=attendance"</g:if><g:else>hx-post="/api/universal/Calendar?domainName=Calendar&viewType=attendance"</g:else>
                  hx-target="#attendance-page-content"
                  hx-swap="innerHTML"
                  hx-indicator="#save-indicator"
                  class="space-y-6">
                
                <!-- Hidden ID field for updates -->
                <g:if test="${calendar}">
                    <input type="hidden" name="id" value="${calendar.id}">
                </g:if>

                <!-- Season Dates -->
                <div class="bg-blue-50 rounded-lg p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Season Duration</h3>
                    
                    <div class="grid md:grid-cols-2 gap-4">
                        <!-- Start Date -->
                        <div>
                            <label for="startDate" class="block text-sm font-medium text-gray-700 mb-2">Season Start Date *</label>
                            <input type="date" 
                                   id="startDate" 
                                   name="startDate" 
                                   value="<g:formatDate format='yyyy-MM-dd' date='${calendar?.startDate}' />"
                                   required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                            <p class="text-xs text-gray-500 mt-1">First week of Awana meetings</p>
                        </div>

                        <!-- End Date -->
                        <div>
                            <label for="endDate" class="block text-sm font-medium text-gray-700 mb-2">Season End Date *</label>
                            <input type="date" 
                                   id="endDate" 
                                   name="endDate" 
                                   value="<g:formatDate format='yyyy-MM-dd' date='${calendar?.endDate}' />"
                                   required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                            <p class="text-xs text-gray-500 mt-1">Last week of Awana meetings</p>
                        </div>
                    </div>
                </div>

                <!-- Meeting Schedule -->
                <div class="bg-green-50 rounded-lg p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Meeting Schedule</h3>
                    
                    <div class="space-y-4">
                        <!-- Day of Week -->
                        <div>
                            <label for="dayOfWeek" class="block text-sm font-medium text-gray-700 mb-2">Meeting Day *</label>
                            <select id="dayOfWeek" 
                                    name="dayOfWeek"
                                    required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                                <option value="">Select meeting day...</option>
                                <option value="Sunday" ${calendar?.dayOfWeek == 'Sunday' ? 'selected' : ''}>Sunday</option>
                                <option value="Monday" ${calendar?.dayOfWeek == 'Monday' ? 'selected' : ''}>Monday</option>
                                <option value="Tuesday" ${calendar?.dayOfWeek == 'Tuesday' ? 'selected' : ''}>Tuesday</option>
                                <option value="Wednesday" ${calendar?.dayOfWeek == 'Wednesday' ? 'selected' : ''}>Wednesday</option>
                                <option value="Thursday" ${calendar?.dayOfWeek == 'Thursday' ? 'selected' : ''}>Thursday</option>
                                <option value="Friday" ${calendar?.dayOfWeek == 'Friday' ? 'selected' : ''}>Friday</option>
                                <option value="Saturday" ${calendar?.dayOfWeek == 'Saturday' ? 'selected' : ''}>Saturday</option>
                            </select>
                        </div>

                        <!-- Meeting Times -->
                        <div class="grid md:grid-cols-2 gap-4">
                            <!-- Start Time -->
                            <div>
                                <label for="startTime" class="block text-sm font-medium text-gray-700 mb-2">Start Time *</label>
                                <input type="time" 
                                       id="startTime" 
                                       name="startTime" 
                                       value="${calendar?.startTime ?: ''}"
                                       required
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                            </div>

                            <!-- End Time -->
                            <div>
                                <label for="endTime" class="block text-sm font-medium text-gray-700 mb-2">End Time *</label>
                                <input type="time" 
                                       id="endTime" 
                                       name="endTime" 
                                       value="${calendar?.endTime ?: ''}"
                                       required
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div class="bg-purple-50 rounded-lg p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Calendar Description</h3>
                    
                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                        <input type="text" 
                               id="description" 
                               name="description" 
                               placeholder="e.g., Fall 2024 Season, Spring 2025 Season"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent text-sm">
                        <p class="text-xs text-gray-500 mt-1">Optional description for this calendar</p>
                    </div>
                </div>

                <!-- Preview Information -->
                <div class="bg-yellow-50 rounded-lg p-4">
                    <h4 class="text-sm font-semibold text-gray-900 mb-2">📅 Preview</h4>
                    <div class="text-sm text-gray-600 space-y-1">
                        <p><strong>Meeting Schedule:</strong> Every <span id="preview-day">--</span> from <span id="preview-start-time">--</span> to <span id="preview-end-time">--</span></p>
                        <p><strong>Season Duration:</strong> <span id="preview-start-date">--</span> to <span id="preview-end-date">--</span></p>
                        <p><strong>Estimated Meetings:</strong> <span id="preview-meeting-count">--</span> meetings</p>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex items-center justify-between pt-4 border-t border-gray-200">
                    <div class="text-sm text-gray-600">
                        * Required fields
                    </div>
                    
                    <div class="flex items-center space-x-3">
                        <button type="button"
                                hx-get="/renderView?viewType=attendance"
                                hx-target="#attendance-page-content"
                                hx-swap="innerHTML"
                                class="px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors">
                            Cancel
                        </button>
                        
                        <button type="submit"
                                class="inline-flex items-center px-6 py-3 text-sm font-medium text-white bg-green-600 hover:bg-green-700 rounded-lg transition-colors min-h-[44px]">
                            <span id="save-indicator" class="htmx-indicator">
                                <svg class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                            </span>
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            <g:if test="${calendar}">
                                Update Calendar
                            </g:if>
                            <g:else>
                                Create Calendar
                            </g:else>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Live preview update functionality
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const inputs = form.querySelectorAll('input, select');
    
    function updatePreview() {
        const dayOfWeek = document.getElementById('dayOfWeek').value;
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        
        // Update preview elements
        document.getElementById('preview-day').textContent = dayOfWeek || '--';
        document.getElementById('preview-start-time').textContent = startTime || '--';
        document.getElementById('preview-end-time').textContent = endTime || '--';
        document.getElementById('preview-start-date').textContent = startDate ? new Date(startDate).toLocaleDateString() : '--';
        document.getElementById('preview-end-date').textContent = endDate ? new Date(endDate).toLocaleDateString() : '--';
        
        // Calculate estimated meeting count
        if (startDate && endDate && dayOfWeek) {
            const start = new Date(startDate);
            const end = new Date(endDate);
            const dayIndex = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'].indexOf(dayOfWeek);
            
            let meetingCount = 0;
            let current = new Date(start);
            
            // Find first occurrence of the meeting day
            while (current.getDay() !== dayIndex && current <= end) {
                current.setDate(current.getDate() + 1);
            }
            
            // Count weekly meetings
            while (current <= end) {
                meetingCount++;
                current.setDate(current.getDate() + 7);
            }
            
            document.getElementById('preview-meeting-count').textContent = meetingCount;
        } else {
            document.getElementById('preview-meeting-count').textContent = '--';
        }
    }
    
    // Add event listeners for live preview
    inputs.forEach(input => {
        input.addEventListener('change', updatePreview);
        input.addEventListener('input', updatePreview);
    });
    
    // Initial preview update
    updatePreview();
});
</script>