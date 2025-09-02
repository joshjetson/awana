<%-- 
Club Students Management Template
Loaded via: /renderView?viewType=clubStudents&clubId=123
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Manage Students - ${club?.name}</h1>
            <div class="text-purple-100">
                ${club?.ageRange} • Add or remove students from this club
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Back Button -->
        <div class="bg-white rounded-xl shadow-lg p-4">
            <button hx-get="/renderView?viewType=clubs"
                    hx-target="#clubs-page-content"
                    hx-swap="innerHTML"
                    class="flex items-center space-x-2 text-purple-600 hover:text-purple-800 font-medium">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to Club Management</span>
            </button>
        </div>

        <!-- Student Management Content -->
        <div class="bg-white rounded-xl shadow-lg p-6">

    <div class="grid md:grid-cols-2 gap-6">
        <!-- Current Students -->
        <div>
            <h3 class="font-semibold text-gray-900 mb-4">Current Students (${club?.students?.size() ?: 0})</h3>
            <div class="space-y-2 max-h-64 overflow-y-auto">
                <g:if test="${club?.students}">
                    <g:each in="${club.students}" var="student">
                        <div class="flex items-center justify-between p-3 bg-green-50 border border-green-200 rounded-lg">
                            <div>
                                <div class="font-medium text-gray-900">${student.firstName} ${student.lastName}</div>
                                <div class="text-sm text-gray-600">${student.awanaBucks} bucks</div>
                            </div>
                            <button type="button"
                                    hx-put="/api/universal/Student/${student.id}?domainName=Student&viewType=clubStudents&refreshClubId=${club.id}&club.id="
                                    hx-target="#clubs-page-content"
                                    hx-swap="innerHTML"
                                    class="text-red-600 hover:text-red-700 text-sm">
                                Remove
                            </button>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="text-center py-8 text-gray-500">
                        No students assigned to this club yet
                    </div>
                </g:else>
            </div>
        </div>

        <!-- Available Students -->
        <div>
            <h3 class="font-semibold text-gray-900 mb-4">Available Students</h3>
            <div class="space-y-2 max-h-64 overflow-y-auto">
                <g:each in="${allStudents?.findAll { !club?.students?.contains(it) }}" var="student">
                    <div class="flex items-center justify-between p-3 bg-gray-50 border border-gray-200 rounded-lg">
                        <div>
                            <div class="font-medium text-gray-900">${student.firstName} ${student.lastName}</div>
                            <div class="text-sm text-gray-600">
                                Current club: ${student.club?.name ?: 'None'}
                            </div>
                        </div>
                        <button hx-put="/api/universal/Student/${student.id}?domainName=Student&viewType=clubStudents&refreshClubId=${club.id}&club.id=${club.id}"
                                hx-target="#clubs-page-content"
                                hx-swap="innerHTML"
                                class="text-blue-600 hover:text-blue-700 text-sm">
                            Add
                        </button>
                    </div>
                </g:each>
            </div>
        </div>
    </div>
        
        </div>
    </div>
</div>