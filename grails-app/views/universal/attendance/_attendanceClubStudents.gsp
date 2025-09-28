<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=attendanceClubOverview&meetingDate=${meetingDate}"
            hx-target="#attendance-page-content"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to Club Overview</span>
    </button>
</div>

<!-- Club Students Attendance -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-xl font-bold text-gray-900">${club.name} Attendance</h2>
            <p class="text-sm text-gray-600">${club.ageRange} • <g:formatDate format="MMMM dd, yyyy" date="${meetingDate}"/></p>
        </div>
        <div class="text-right">
            <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
                ${club.students?.size() ?: 0} students
            </span>
            <div class="text-sm text-gray-600 mt-1">
                ${presentCount} present • ${Math.round(attendanceRate * 100)}% rate
            </div>
        </div>
    </div>

    <g:if test="${club.students}">
        <div class="space-y-3">
            <g:each in="${club.students}" var="student">
                <% 
                    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')
                    def attendance = student.attendances?.find { att -> 
                        att.attendanceDate && meetingDate && 
                        sdf.format(att.attendanceDate) == sdf.format(meetingDate) 
                    } 
                %>
                <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold text-sm">
                                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                            </div>
                            <div class="flex-1">
                                <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                <p class="text-sm text-gray-600">${student.getAge()} years old • ${student.household.name}</p>
                                
                                <!-- Attendance Status Pills -->
                                <div class="flex items-center space-x-2 mt-2">
                                    <g:if test="${attendance?.present}">
                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            Present
                                        </span>
                                        <g:if test="${attendance?.hasUniform}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                Uniform
                                            </span>
                                        </g:if>
                                        <g:if test="${attendance?.hasBible}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                                Bible
                                            </span>
                                        </g:if>
                                        <g:if test="${attendance?.hasHandbook}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                                                Handbook
                                            </span>
                                        </g:if>
                                    </g:if>
                                    <g:else>
                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                            Absent
                                        </span>
                                    </g:else>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-right flex items-center space-x-3">
                            <div>
                                <div class="text-lg font-bold text-green-600">
                                    ${attendance?.bucksEarned ?: 0} bucks
                                </div>
                                <div class="text-xs text-gray-500">This meeting</div>
                            </div>
                            
                            <button type="button"
                                    hx-get="/renderView?viewType=checkinStudent&studentId=${student.id}&meetingDate=${meetingDate}&clubId=${club.id}"
                                    hx-target="#attendance-page-content"
                                    hx-swap="innerHTML" 
                                    class="inline-flex items-center justify-center px-3 py-2 text-sm font-medium ${attendance?.present ? 'bg-green-600 hover:bg-green-700' : 'bg-blue-600 hover:bg-blue-700'} text-white rounded-lg min-h-[40px] transition-colors">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                                <span class="ml-2">Edit</span>
                            </button>
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
            <p>No students in this club</p>
            <p class="text-sm mt-1">Add students to start taking attendance</p>
        </div>
    </g:else>
</div>