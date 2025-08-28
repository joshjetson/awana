<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-2xl font-bold text-gray-900">${club.name}</h2>
            <p class="text-gray-600">${club.ageRange}</p>
        </div>
        <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
            ${club.name.substring(0, 1)}
        </div>
    </div>

    <!-- Club Stats -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        <div class="bg-blue-50 rounded-lg p-4 text-center">
            <div class="text-2xl font-bold text-blue-600">${students.size()}</div>
            <div class="text-sm text-blue-800">Total Students</div>
        </div>
        <div class="bg-green-50 rounded-lg p-4 text-center">
            <div class="text-2xl font-bold text-green-600">${students.sum { it.calculateTotalBucks() } ?: 0}</div>
            <div class="text-sm text-green-800">Total Bucks</div>
        </div>
        <div class="bg-purple-50 rounded-lg p-4 text-center">
            <div class="text-2xl font-bold text-purple-600">${students.sum { it.sectionVerseCompletions?.size() ?: 0 } ?: 0}</div>
            <div class="text-sm text-purple-800">Verse Completions</div>
        </div>
        <div class="bg-orange-50 rounded-lg p-4 text-center">
            <div class="text-2xl font-bold text-orange-600">${students.findAll { it.calculateTotalBucks() >= 10 }.size()}</div>
            <div class="text-sm text-orange-800">10+ Buck Earners</div>
        </div>
    </div>

    <!-- Student List -->
    <div>
        <h3 class="text-lg font-bold text-gray-900 mb-4">Students in ${club.name}</h3>
        
        <g:if test="${students}">
            <div class="space-y-3">
                <g:each in="${students}" var="student">
                    <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 cursor-pointer student-card" 
                         data-student-id="${student.id}"
                         onclick="viewStudent(${student.id})">
                        
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold">
                                    ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                                </div>
                                <div>
                                    <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                    <p class="text-sm text-gray-600">${student.getAge()} years old • ${student.household.name}</p>
                                </div>
                            </div>
                            
                            <div class="text-right">
                                <div class="text-lg font-bold text-green-600">
                                    ${student.calculateTotalBucks()} bucks
                                </div>
                                <div class="flex space-x-2 mt-2">
                                    <g:set var="verseIcon">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                        </svg>
                                    </g:set>
                                    
                                    <button type="button" onclick="viewVerseProgress(${student.id})" 
                                            class="inline-flex items-center justify-center px-4 py-2 text-sm font-bold bg-blue-600 hover:bg-blue-700 text-white rounded-xl min-h-[44px] transition-colors">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                                        </svg>
                                        <span class="ml-2">Verse Progress</span>
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
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                <p>No students found in ${club.name}.</p>
                <p class="text-sm mt-1">Students may need to be assigned to this club.</p>
            </div>
        </g:else>
    </div>
</div>

<script>
function viewStudent(studentId) {
    // Load student detail view dynamically via HTMX
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'studentProgress',
            studentId: studentId
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    });
}

function viewVerseProgress(studentId) {
    // Use the global function
    showVerseCompletion(studentId);
}
</script>