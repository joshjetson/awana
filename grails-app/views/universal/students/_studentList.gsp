<%-- 
Simple Student List Template for dynamic loading
Used when showing filtered student results
--%>

<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900">${title ?: 'Students'}</h2>
        <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
            ${students?.size() ?: 0} students
        </span>
    </div>
    
    <g:if test="${students}">
        <div class="space-y-3">
            <g:each in="${students}" var="student">
                <div type="button"
                        hx-get="/renderView?viewType=verseCompletion&studentId=${student.id}"
                        hx-target="#main-content-area"
                        hx-swap="innerHTML"
                        class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 cursor-pointer student-card"
                >

                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold">
                                ${student.firstName?.substring(0, 1)}${student.lastName?.substring(0, 1)}
                            </div>
                            <div>
                                <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                <p class="text-sm text-gray-600">${student.club?.name} • ${student.household?.name}</p>
                            </div>
                        </div>
                        
                        <div class="text-right">
                            <div class="text-lg font-bold text-green-600">
                                ${student.calculateTotalBucks()} bucks
                            </div>
                            <div class="text-xs text-gray-500">
                                ${student.sectionVerseCompletions?.size() ?: 0} verses completed
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
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <p class="text-lg font-medium">No students found</p>
            <p class="text-sm mt-1">Try a different search or filter.</p>
        </div>
    </g:else>
</div>