<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=students"
            hx-target="#main-content-area"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to Student Overview</span>
    </button>
</div>

<!-- Student List Results -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900">
            <g:if test="${filter == 'topPerformers'}">Top Performers</g:if>
            <g:elseif test="${filter == 'recentCompletions'}">Recent Verse Completions</g:elseif>
            <g:elseif test="${filter == 'needsAttention'}">Students Needing Attention</g:elseif>
            <g:elseif test="${searchTerm}">
                Search Results: "${searchTerm}"
            </g:elseif>
            <g:else>All Students</g:else>
        </h2>
        <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
            ${students?.size() ?: 0} students
        </span>
    </div>

    <g:if test="${students}">
        <div class="space-y-4">
            <g:each in="${students}" var="student">
                <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold">
                                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                            </div>
                            <div>
                                <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                <p class="text-sm text-gray-600">${student.getAge()} years old • ${student.club?.name ?: 'No Club'} • ${student.household.name}</p>
                            </div>
                        </div>
                        
                        <div class="text-right">
                            <div class="text-lg font-bold text-green-600">
                                ${student.calculateTotalBucks()} bucks
                            </div>
                            <div class="flex space-x-2 mt-2">
                                <button type="button"
                                        hx-get="/renderView?viewType=verseCompletion&studentId=${student.id}"
                                        hx-target="#main-content-area"
                                        hx-swap="innerHTML" 
                                        class="inline-flex items-center justify-center px-3 py-2 text-sm font-bold bg-blue-600 hover:bg-blue-700 text-white rounded-xl min-h-[44px] transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                                    </svg>
                                    <span class="ml-2">Verses</span>
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
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 515.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 919.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <p>No students found</p>
            <g:if test="${searchTerm}">
                <p class="text-sm mt-1">Try a different search term</p>
            </g:if>
        </div>
    </g:else>
</div>