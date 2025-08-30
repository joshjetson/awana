<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=editHousehold&householdId=${household.id}"
            hx-target="#main-content-area"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-purple-600 hover:text-purple-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to ${household.name} Family</span>
    </button>
</div>

<!-- Student Form -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-2xl font-bold text-gray-900">
                <g:if test="${student}">Edit ${student.firstName} ${student.lastName}</g:if>
                <g:else>Add Child to ${household.name} Family</g:else>
            </h2>
            <p class="text-gray-600">
                <g:if test="${student}">Update student information and club assignment</g:if>
                <g:else>Register a new child for this household</g:else>
            </p>
        </div>
        <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-green-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
            <g:if test="${student}">
                ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
            </g:if>
            <g:else>
                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
            </g:else>
        </div>
    </div>

    <form <g:if test="${student}">hx-put="/api/universal/Student/${student.id}?domainName=Student&viewType=editStudent&studentId=${student.id}&refreshHouseholdId=${household.id}"</g:if><g:else>hx-post="/api/universal/Student?domainName=Student&viewType=editHousehold&refreshHouseholdId=${household.id}"</g:else>
          hx-target="#main-content-area"
          hx-swap="innerHTML"
          hx-indicator="#save-indicator"
          class="space-y-6">


        <!-- Hidden household ID -->
        <input type="hidden" name="household.id" value="${household.id}">

        <!-- Student Information -->
        <div class="bg-blue-50 rounded-lg p-4">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Child Information</h3>
            
            <div class="grid md:grid-cols-2 gap-4">
                <!-- First Name -->
                <div>
                    <label for="firstName" class="block text-sm font-medium text-gray-700 mb-2">First Name *</label>
                    <input type="text" 
                           id="firstName" 
                           name="firstName" 
                           value="${student?.firstName ?: ''}"
                           required
                           placeholder="Enter child's first name"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                </div>

                <!-- Last Name -->
                <div>
                    <label for="lastName" class="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
                    <input type="text" 
                           id="lastName" 
                           name="lastName" 
                           value="${household.name}"
                           readonly
                           class="w-full px-4 py-3 border border-gray-200 bg-gray-50 rounded-lg text-sm text-gray-600 cursor-not-allowed">
                    <p class="text-xs text-gray-500 mt-1">Last name matches family name (managed at household level)</p>
                </div>

                <!-- Date of Birth -->
                <div>
                    <label for="dateOfBirth" class="block text-sm font-medium text-gray-700 mb-2">Date of Birth *</label>
                    <input type="date" 
                           id="dateOfBirth" 
                           name="dateOfBirth" 
                           value="<g:formatDate format='yyyy-MM-dd' date='${student?.dateOfBirth}' />"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                </div>

                <!-- Club Assignment -->
                <div>
                    <label for="clubId" class="block text-sm font-medium text-gray-700 mb-2">Assign to Club</label>
                    <select id="clubId" 
                            name="club.id"
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                        <option value="">Select a club (optional)</option>
                        <g:each in="${clubs}" var="club">
                            <option value="${club.id}" ${student?.club?.id == club.id ? 'selected' : ''}>${club.name} (${club.ageRange})</option>
                        </g:each>
                    </select>
                    <p class="text-xs text-gray-500 mt-1">Club can be assigned later based on age</p>
                </div>
            </div>
        </div>

        <!-- Age-Based Club Suggestions -->
        <div class="bg-yellow-50 rounded-lg p-4">
            <h4 class="text-sm font-semibold text-gray-900 mb-2">📋 Club Guidelines by Age</h4>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-2 text-xs text-gray-600">
                <div><strong>Puggles:</strong> Ages 2-3</div>
                <div><strong>Cubbies:</strong> Ages 4-5</div>
                <div><strong>Sparks:</strong> K-2nd Grade</div>
                <div><strong>T&T:</strong> Grades 3-6</div>
                <div><strong>Trek:</strong> Grades 6-8</div>
                <div><strong>Journey:</strong> Grades 9-12</div>
            </div>
        </div>

        <!-- Form Actions -->
        <div class="flex items-center justify-between pt-4 border-t border-gray-200">
            <div class="text-sm text-gray-600">
                * Required fields
            </div>
            
            <div class="flex items-center space-x-3">
                <button type="button"
                        hx-get="/renderView?viewType=editHousehold&householdId=${household.id}"
                        hx-target="#main-content-area"
                        hx-swap="innerHTML"
                        class="px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors">
                    Cancel
                </button>
                
                <button type="submit"
                        class="inline-flex items-center px-6 py-3 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors min-h-[44px]">
                    <span id="save-indicator" class="htmx-indicator">
                        <svg class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
                    <g:if test="${student}">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                        </svg>
                        Update Student
                    </g:if>
                    <g:else>
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Add Child
                    </g:else>
                </button>
            </div>
        </div>
    </form>
</div>