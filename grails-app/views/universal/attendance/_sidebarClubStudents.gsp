<!-- Sidebar Student List for Club -->
<g:if test="${students}">
    <g:each in="${students}" var="student">
        <div class="bg-white rounded-lg p-3 shadow-sm hover:shadow-md transition-all cursor-pointer border hover:border-blue-300"
             onclick="showStudentCalendar('${student.id}', '${student.firstName} ${student.lastName}')">
            <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-gradient-to-br from-blue-400 to-green-400 rounded-full flex items-center justify-center text-white text-xs font-bold">
                    ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                </div>
                <div class="flex-1 min-w-0">
                    <h5 class="font-medium text-gray-900 text-sm truncate">${student.firstName} ${student.lastName}</h5>
                    <div class="flex items-center justify-between">
                        <p class="text-xs text-gray-600">${student.getAge()} years old</p>
                        <div class="text-right">
                            <div class="text-sm font-bold text-green-600">${student.calculateTotalBucks()}</div>
                            <div class="text-xs text-gray-500">bucks</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick attendance status -->
            <div class="mt-2 flex items-center space-x-1">
                <% 
                    // Calculate recent attendance rate
                    def recentAttendances = student.attendances?.findAll { it.attendanceDate > new Date() - 30 } ?: []
                    def attendanceRate = recentAttendances.size() > 0 ? 
                        (recentAttendances.count { it.present } / recentAttendances.size()) * 100 : 0
                %>
                <div class="flex items-center space-x-1">
                    <div class="w-2 h-2 rounded-full ${attendanceRate >= 80 ? 'bg-green-400' : attendanceRate >= 60 ? 'bg-yellow-400' : 'bg-red-400'}"></div>
                    <span class="text-xs text-gray-600">${Math.round(attendanceRate)}% recent</span>
                </div>
            </div>
        </div>
    </g:each>
</g:if>
<g:else>
    <div class="text-center py-8 text-gray-500">
        <svg class="w-8 h-8 mx-auto mb-2 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 515.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
        </svg>
        <p class="text-sm">No students in this club</p>
    </div>
</g:else>