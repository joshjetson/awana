<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=attendanceClubOverview&meetingDate=${meetingDate}"
            hx-target="#attendance-content-area"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to Club Overview</span>
    </button>
</div>

<!-- Student Search Results -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900">
            <g:if test="${searchTerm}">
                Search Results: "${searchTerm}"
            </g:if>
            <g:else>
                Student Attendance
            </g:else>
        </h2>
        <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
            ${students?.size() ?: 0} students
        </span>
    </div>

    <g:if test="${students}">
        <div class="space-y-4">
            <g:each in="${students}" var="student">
                <% 
                    def attendance = student.attendances?.find { att -> 
                        att.attendanceDate?.format('yyyy-MM-dd') == meetingDate?.format('yyyy-MM-dd') 
                    } 
                %>
                <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold">
                                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                            </div>
                            <div>
                                <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                <p class="text-sm text-gray-600">${student.getAge()} years old • ${student.club?.name ?: 'No Club'} • ${student.household.name}</p>
                                <g:if test="${attendance?.present}">
                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 mt-1">
                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                        </svg>
                                        Present
                                    </span>
                                </g:if>
                                <g:else>
                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800 mt-1">
                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                                        </svg>
                                        Absent
                                    </span>
                                </g:else>
                            </div>
                        </div>
                        
                        <div class="text-right">
                            <div class="text-lg font-bold text-green-600">
                                ${attendance?.bucksEarned ?: 0} bucks earned
                            </div>
                            <div class="flex space-x-2 mt-2">
                                <button type="button"
                                        hx-get="/renderView?viewType=studentAttendanceDetail&studentId=${student.id}&meetingDate=${meetingDate}"
                                        hx-target="#attendance-content-area"
                                        hx-swap="innerHTML" 
                                        class="inline-flex items-center justify-center px-3 py-2 text-sm font-bold bg-blue-600 hover:bg-blue-700 text-white rounded-xl min-h-[44px] transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="ml-2">Attendance</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </g:if>
    <g:else>
        <div class="text-center py-8 text-gray-500">
            <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 0 1 5.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 0 1 9.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <p>No students found</p>
            <g:if test="${searchTerm}">
                <p class="text-sm mt-1">Try a different search term</p>
            </g:if>
        </div>
    </g:else>
</div>