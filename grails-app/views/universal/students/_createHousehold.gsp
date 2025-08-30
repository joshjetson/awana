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

<!-- Household Creation Form -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-2xl font-bold text-gray-900">Create New Household</h2>
            <p class="text-gray-600">Add a new family with children to the Awana club</p>
        </div>
        <div class="w-16 h-16 bg-gradient-to-br from-green-500 to-blue-500 rounded-lg flex items-center justify-center text-white">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 515.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 919.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
        </div>
    </div>

    <form hx-post="/api/universal/Household"
          hx-target="#main-content-area"
          hx-swap="innerHTML"
          hx-indicator="#save-indicator"
          class="space-y-6">

        <!-- Household Information -->
        <div class="bg-gray-50 rounded-lg p-4">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Household Information</h3>
            
            <div class="grid md:grid-cols-2 gap-4">
                <!-- Family Name -->
                <div>
                    <label for="householdName" class="block text-sm font-medium text-gray-700 mb-2">Family Name *</label>
                    <input type="text" 
                           id="householdName" 
                           name="name" 
                           required
                           placeholder="Enter family last name..."
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                </div>

                <!-- Phone Number -->
                <div>
                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                    <input type="tel" 
                           id="phoneNumber" 
                           name="phoneNumber" 
                           placeholder="(555) 123-4567"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                </div>

                <!-- Email -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           placeholder="family@example.com"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                </div>

                <!-- Address -->
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Home Address</label>
                    <input type="text" 
                           id="address" 
                           name="address" 
                           placeholder="123 Main St, City, State 12345"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                </div>
            </div>
        </div>

        <!-- Children Information -->
        <div class="bg-blue-50 rounded-lg p-4">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-semibold text-gray-900">Children</h3>
                <button type="button" 
                        onclick="addChildForm()"
                        class="inline-flex items-center px-3 py-2 text-sm font-medium text-blue-600 bg-blue-100 hover:bg-blue-200 rounded-lg transition-colors">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Add Child
                </button>
            </div>

            <div id="children-container">
                <!-- Initial child form -->
                <div class="child-form bg-white rounded-lg p-4 mb-4 border border-blue-200" data-child-index="0">
                    <div class="flex items-center justify-between mb-3">
                        <h4 class="font-medium text-gray-900">Child #1</h4>
                        <button type="button" 
                                onclick="removeChildForm(this)"
                                class="text-red-600 hover:text-red-800 p-1" 
                                style="display: none;">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                        </button>
                    </div>
                    
                    <div class="grid md:grid-cols-3 gap-3">
                        <!-- First Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>
                            <input type="text" 
                                   name="children[0].firstName" 
                                   required
                                   placeholder="Enter first name"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                        </div>

                        <!-- Last Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
                            <input type="text" 
                                   name="children[0].lastName" 
                                   required
                                   placeholder="Enter last name"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                        </div>

                        <!-- Date of Birth -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Date of Birth *</label>
                            <input type="date" 
                                   name="children[0].dateOfBirth" 
                                   required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Actions -->
        <div class="flex items-center justify-between pt-4 border-t border-gray-200">
            <div class="text-sm text-gray-600">
                * Required fields
            </div>
            
            <div class="flex items-center space-x-3">
                <button type="button"
                        hx-get="/renderView?viewType=students"
                        hx-target="#main-content-area"
                        hx-swap="innerHTML"
                        class="px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors">
                    Cancel
                </button>
                
                <button type="submit"
                        class="inline-flex items-center px-6 py-3 text-sm font-medium text-white bg-green-600 hover:bg-green-700 rounded-lg transition-colors min-h-[44px]">
                    <span id="save-indicator" class="htmx-indicator">
                        <svg class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                    Create Household
                </button>
            </div>
        </div>
    </form>
</div>

<script>
let childIndex = 1;

function addChildForm() {
    const container = document.getElementById('children-container');
    const newChildForm = document.createElement('div');
    newChildForm.className = 'child-form bg-white rounded-lg p-4 mb-4 border border-blue-200';
    newChildForm.setAttribute('data-child-index', childIndex);
    
    newChildForm.innerHTML = 
        '<div class="flex items-center justify-between mb-3">' +
            '<h4 class="font-medium text-gray-900">Child #' + (childIndex + 1) + '</h4>' +
            '<button type="button" onclick="removeChildForm(this)" class="text-red-600 hover:text-red-800 p-1">' +
                '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">' +
                    '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>' +
                '</svg>' +
            '</button>' +
        '</div>' +
        '<div class="grid md:grid-cols-3 gap-3">' +
            '<div>' +
                '<label class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>' +
                '<input type="text" name="children[' + childIndex + '].firstName" required placeholder="Enter first name" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">' +
            '</div>' +
            '<div>' +
                '<label class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>' +
                '<input type="text" name="children[' + childIndex + '].lastName" required placeholder="Enter last name" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">' +
            '</div>' +
            '<div>' +
                '<label class="block text-sm font-medium text-gray-700 mb-1">Date of Birth *</label>' +
                '<input type="date" name="children[' + childIndex + '].dateOfBirth" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">' +
            '</div>' +
        '</div>';
    
    container.appendChild(newChildForm);
    childIndex++;
    updateRemoveButtons();
}

function removeChildForm(button) {
    const childForm = button.closest('.child-form');
    childForm.remove();
    updateChildNumbers();
    updateRemoveButtons();
}

function updateChildNumbers() {
    const childForms = document.querySelectorAll('.child-form');
    childForms.forEach((form, index) => {
        const header = form.querySelector('h4');
        header.textContent = 'Child #' + (index + 1);
    });
}

function updateRemoveButtons() {
    const childForms = document.querySelectorAll('.child-form');
    const removeButtons = document.querySelectorAll('.child-form button[onclick="removeChildForm(this)"]');
    
    removeButtons.forEach(button => {
        button.style.display = childForms.length > 1 ? 'block' : 'none';
    });
}
</script>