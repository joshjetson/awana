<!-- Back Button -->
<div class="bg-white rounded-xl shadow-lg p-4 mb-6">
    <button hx-get="/renderView?viewType=manageHouseholds"
            hx-target="#main-content-area"
            hx-swap="innerHTML"
            class="flex items-center space-x-2 text-purple-600 hover:text-purple-800 font-medium">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
        </svg>
        <span>Back to Household Directory</span>
    </button>
</div>

<!-- Household Edit Form -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-2xl font-bold text-gray-900">Edit ${household.name} Family</h2>
            <p class="text-gray-600">Update household information and manage children</p>
        </div>
        <div class="flex items-center space-x-3">
            <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-blue-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
                ${household.name.substring(0, 1)}
            </div>
            <div class="text-right">
                <div class="text-lg font-bold text-purple-600">${household.qrCode}</div>
                <div class="text-sm text-gray-500">QR Code</div>
            </div>
        </div>
    </div>
    <form hx-put="/api/universal/Household/${household.id}?domainName=Household&viewType=editHousehold&refreshHouseholdId=${household.id}"
          hx-target="#main-content-area"
          hx-swap="innerHTML"
          hx-indicator="#update-indicator"
          class="space-y-6">

        <!-- Household Information -->
        <div class="bg-purple-50 rounded-lg p-4">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Family Information</h3>
            
            <div class="grid md:grid-cols-2 gap-4">
                <!-- Family Name -->
                <div>
                    <label for="householdName" class="block text-sm font-medium text-gray-700 mb-2">Family Name *</label>
                    <input type="text" 
                           id="householdName" 
                           name="name" 
                           value="${household.name}"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent text-sm">
                </div>

                <!-- Phone Number -->
                <div>
                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                    <input type="tel" 
                           id="phoneNumber" 
                           name="phoneNumber" 
                           value="${household.phoneNumber ?: ''}"
                           placeholder="(555) 123-4567"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent text-sm">
                </div>

                <!-- Email -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           value="${household.email ?: ''}"
                           placeholder="family@example.com"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent text-sm">
                </div>

                <!-- Address -->
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Home Address</label>
                    <input type="text" 
                           id="address" 
                           name="address" 
                           value="${household.address ?: ''}"
                           placeholder="123 Main St, City, State 12345"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent text-sm">
                </div>
            </div>
        </div>

        <!-- Children List -->
        <div class="bg-blue-50 rounded-lg p-4">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-semibold text-gray-900">Children (${household.students?.size() ?: 0})</h3>
                <button type="button"
                        hx-get="/renderView?viewType=addStudentToHousehold&householdId=${household.id}"
                        hx-target="#main-content-area"
                        hx-swap="innerHTML"
                        class="inline-flex items-center px-3 py-2 text-sm font-medium text-blue-600 bg-blue-100 hover:bg-blue-200 rounded-lg transition-colors">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Add Child
                </button>
            </div>

            <g:if test="${household.students}">
                <div class="space-y-3">
                    <g:each in="${household.students.sort { it.firstName }}" var="student">
                        <div class="bg-white rounded-lg p-4 border border-blue-200">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-green-500 rounded-full flex items-center justify-center text-white font-bold text-sm">
                                        ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h4>
                                        <p class="text-sm text-gray-600">
                                            Age ${student.getAge()} • ${student.club?.name ?: 'No Club'} • ${student.calculateTotalBucks()} bucks
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="flex items-center space-x-2">
                                    <!-- Edit Student Button -->
                                    <button type="button"
                                            hx-get="/renderView?viewType=editStudent&studentId=${student.id}"
                                            hx-target="#main-content-area"
                                            hx-swap="innerHTML"
                                            class="inline-flex items-center px-3 py-2 text-xs font-medium text-blue-700 bg-blue-100 hover:bg-blue-200 rounded-lg transition-colors"
                                            title="Edit Student">
                                        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                        </svg>
                                        Edit
                                    </button>

                                    <!-- Remove Student Button -->
                                    <button type="button"
                                            hx-delete="/api/universal/Student/${student.id}"
                                            hx-confirm="Are you sure you want to remove ${student.firstName} ${student.lastName} from this household?"
                                            hx-target="#main-content-area"
                                            hx-swap="innerHTML"
                                            class="inline-flex items-center px-3 py-2 text-xs font-medium text-red-700 bg-red-100 hover:bg-red-200 rounded-lg transition-colors"
                                            title="Remove Student">
                                        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                        </svg>
                                        Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </g:each>
                </div>
            </g:if>
            <g:else>
                <div class="bg-white rounded-lg p-8 border border-blue-200 text-center">
                    <svg class="w-12 h-12 mx-auto mb-4 text-blue-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 0 1 5.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 0 1 9.288 0M15 7a3 3 0 11-6 0 3 3 0 616 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    <p class="text-gray-500 mb-2">No children registered for this family</p>
                    <p class="text-sm text-gray-400">Click "Add Child" to register the first child</p>
                </div>
            </g:else>
        </div>

        <!-- Form Actions -->
        <div class="flex items-center justify-between pt-4 border-t border-gray-200">
            <div class="flex items-center space-x-4">
                <div class="text-sm text-gray-600">
                    * Required fields
                </div>
                <div class="text-sm text-gray-500">
                    Total Family Bucks: <span class="font-bold text-purple-600">${household.getTotalFamilyBucks()}</span>
                </div>
            </div>
            
            <div class="flex items-center space-x-3">
                <button type="button"
                        hx-get="/renderView?viewType=manageHouseholds"
                        hx-target="#main-content-area"
                        hx-swap="innerHTML"
                        class="px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors">
                    Cancel
                </button>
                
                <button type="submit"
                        class="inline-flex items-center px-6 py-3 text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 rounded-lg transition-colors min-h-[44px]">
                    <span id="update-indicator" class="htmx-indicator">
                        <svg class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                    Update Household
                </button>
            </div>
        </div>
    </form>
</div>