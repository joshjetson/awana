<!-- Club Overview for Attendance -->
<div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900">Club Attendance Overview</h2>
        <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
            ${clubs?.size() ?: 0} clubs
        </span>
    </div>

    <!-- Club Cards Grid -->
    <div class="grid md:grid-cols-2 gap-4">
        <g:each in="${clubs}" var="club">
            <div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow cursor-pointer"
                 hx-get="/renderView?viewType=attendanceClubStudents&clubId=${club.id}&meetingDate=${meetingDate}"
                 hx-target="#attendance-content-area"
                 hx-swap="innerHTML">
                
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="text-lg font-bold text-gray-900">${club.name}</h3>
                        <p class="text-sm text-gray-600">${club.ageRange}</p>
                    </div>
                    <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-500 rounded-lg flex items-center justify-center text-white font-bold text-lg">
                        ${club.name.substring(0, 1)}
                    </div>
                </div>
                
                <div class="grid grid-cols-3 gap-4 text-sm mb-4">
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${club.students?.size() ?: 0}</div>
                        <div class="text-gray-600">Students</div>
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-green-600">${attendanceStats[club.id]?.presentCount ?: 0}</div>
                        <div class="text-gray-600">Present Today</div>
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-orange-600">${Math.round((attendanceStats[club.id]?.attendanceRate ?: 0) * 100)}%</div>
                        <div class="text-gray-600">Attendance Rate</div>
                    </div>
                </div>

                <div class="flex space-x-2">
                    <div class="flex-1 bg-gray-100 rounded-lg px-3 py-2 text-center">
                        <div class="font-medium text-gray-900">View Students</div>
                        <div class="text-xs text-gray-600">See attendance records</div>
                    </div>
                    <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</div>