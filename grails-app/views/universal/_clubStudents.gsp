<%-- 
Club Students Management Template
Loaded via: /renderView?viewType=clubStudents&clubId=123
--%>

<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-xl font-bold text-gray-900">Manage Students</h2>
            <p class="text-sm text-gray-600">${club?.name} - ${club?.ageRange}</p>
        </div>
        <button onclick="this.closest('#dynamic-content').style.display = 'none'" 
                class="text-gray-400 hover:text-gray-600 p-2">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>
    </div>

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
                            <button hx-post="/update?domainName=Student&id=${student.id}"
                                    hx-vals='{"club": null}'
                                    hx-target="closest div"
                                    hx-swap="delete"
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
                        <button hx-post="/update?domainName=Student&id=${student.id}"
                                hx-vals='{"club": "${club.id}"}'
                                hx-target="closest div"
                                hx-swap="delete"
                                class="text-blue-600 hover:text-blue-700 text-sm">
                            Add
                        </button>
                    </div>
                </g:each>
            </div>
        </div>
    </div>
</div>