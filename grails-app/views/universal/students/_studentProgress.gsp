<!-- Student Progress View -->
<div class="space-y-6">
    <g:if test="${student}">
        <!-- Student Info -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <h2 class="text-lg font-semibold text-gray-900 mb-2">${student.firstName} ${student.lastName}</h2>
            <p class="text-sm text-gray-600">Club: ${student.club?.name}</p>
            <p class="text-sm text-gray-600">Awana Bucks: ${student.awanaBucks}</p>
        </div>
        
        <!-- Progress Content -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <p class="text-gray-500">Student progress tracking coming soon...</p>
        </div>
    </g:if>
    <g:else>
        <div class="text-center py-8">
            <p class="text-gray-500">No student selected</p>
        </div>
    </g:else>
</div>