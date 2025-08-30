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

<!-- Household Management Interface -->
<div class="bg-white rounded-xl shadow-lg overflow-hidden">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white p-4">
        <div class="flex items-center justify-between">
            <div>
                <h2 class="text-xl font-bold">Household Directory</h2>
                <p class="text-purple-100 text-sm">${households?.size() ?: 0} families registered</p>
            </div>
            <div class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Rolodex Interface -->
    <div class="flex max-h-[calc(95vh-120px)]">
        <!-- Alphabet Navigation -->
        <div class="w-12 bg-gray-50 border-r border-gray-200 flex flex-col items-center py-2 overflow-y-auto">
            <div class="flex flex-col space-y-1 sticky top-0">
                <g:each in="${['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']}" var="letter">
                    <button onclick="scrollToLetter('${letter}')"
                            class="w-8 h-8 text-xs font-bold text-gray-500 hover:text-purple-600 hover:bg-purple-50 rounded-full flex items-center justify-center transition-colors"
                            id="nav-${letter}">
                        ${letter}
                    </button>
                </g:each>
            </div>
        </div>

        <!-- Family List -->
        <div class="flex-1 overflow-y-auto" id="family-list">
            <div class="p-4 space-y-3">
                <g:set var="currentLetter" value=""/>
                <g:each in="${households}" var="household">
                    <g:set var="firstLetter" value="${household.name.substring(0,1).toUpperCase()}"/>
                    
                    <!-- Letter Divider -->
                    <g:if test="${firstLetter != currentLetter}">
                        <g:set var="currentLetter" value="${firstLetter}"/>
                        <div class="flex items-center py-2" id="letter-${firstLetter}">
                            <div class="w-8 h-8 bg-purple-100 text-purple-800 rounded-full flex items-center justify-center font-bold text-sm">
                                ${firstLetter}
                            </div>
                            <div class="flex-1 h-px bg-gray-200 ml-3"></div>
                        </div>
                    </g:if>

                    <!-- Family Card -->
                    <div class="bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg p-3 transition-colors cursor-pointer family-card"
                         data-household-id="${household.id}">
                        <div class="flex items-center justify-between">
                            <!-- Family Info -->
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-blue-500 rounded-lg flex items-center justify-center text-white font-bold">
                                    ${household.name.substring(0,1)}
                                </div>
                                <div>
                                    <h3 class="font-semibold text-gray-900">${household.name}</h3>
                                    <p class="text-sm text-gray-600">
                                        ${household.students?.size() ?: 0} 
                                        ${household.students?.size() == 1 ? 'child' : 'children'}
                                        <g:if test="${household.students}">
                                            • ${household.getTotalFamilyBucks()} bucks
                                        </g:if>
                                    </p>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex items-center space-x-2">
                                <!-- View/Edit Button -->
                                <button hx-get="/renderView?viewType=editHousehold&householdId=${household.id}"
                                        hx-target="#main-content-area"
                                        hx-swap="innerHTML"
                                        class="inline-flex items-center px-3 py-2 text-xs font-medium text-blue-700 bg-blue-100 hover:bg-blue-200 rounded-lg transition-colors"
                                        title="Edit Family">
                                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                    </svg>
                                    Edit
                                </button>

                                <!-- QR Code Button -->
                                <button onclick="showQRCode('${household.qrCode}', '${household.name.encodeAsJavaScript()}')"
                                        class="inline-flex items-center px-3 py-2 text-xs font-medium text-green-700 bg-green-100 hover:bg-green-200 rounded-lg transition-colors"
                                        title="Show QR Code">
                                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/>
                                    </svg>
                                    QR
                                </button>

                                <!-- Delete Button -->
                                <button hx-delete="/api/universal/Household/${household.id}"
                                        hx-confirm="Are you sure you want to delete the ${household.name} family?"
                                        hx-target="#main-content-area"
                                        hx-swap="innerHTML"
                                        class="inline-flex items-center px-3 py-2 text-xs font-medium text-red-700 bg-red-100 hover:bg-red-200 rounded-lg transition-colors"
                                        title="Delete Family">
                                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                    </svg>
                                    Delete
                                </button>
                            </div>
                        </div>

                        <!-- QR Code Display -->
                        <div class="mt-2 text-xs text-gray-500 font-mono">
                            ${household.qrCode}
                        </div>
                    </div>
                </g:each>

                <g:if test="${!households}">
                    <div class="text-center py-12 text-gray-500">
                        <svg class="w-16 h-16 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 515.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 919.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <p class="text-lg font-medium text-gray-400">No families registered yet</p>
                        <p class="text-sm mt-1">Create your first household to get started</p>
                    </div>
                </g:if>
            </div>
        </div>
    </div>
</div>

<!-- QR Code Modal -->
<div id="qr-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center" style="display: none;">
    <div class="bg-white rounded-xl p-6 max-w-sm mx-4">
        <div class="text-center">
            <h3 class="text-lg font-bold text-gray-900 mb-2" id="qr-family-name"></h3>
            <div class="w-48 h-48 mx-auto mb-4 bg-gray-100 rounded-lg flex items-center justify-center" id="qr-display">
                <span class="text-4xl font-mono font-bold text-gray-600" id="qr-code-text"></span>
            </div>
            <p class="text-sm text-gray-600 mb-4">Use this code for quick check-in</p>
            <button onclick="hideQRCode()" class="w-full px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg transition-colors">
                Close
            </button>
        </div>
    </div>
</div>

<script>
function scrollToLetter(letter) {
    const element = document.getElementById('letter-' + letter);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        
        // Update active letter in navigation
        document.querySelectorAll('[id^="nav-"]').forEach(btn => {
            btn.classList.remove('bg-purple-100', 'text-purple-800');
            btn.classList.add('text-gray-500');
        });
        
        const navBtn = document.getElementById('nav-' + letter);
        if (navBtn) {
            navBtn.classList.remove('text-gray-500');
            navBtn.classList.add('bg-purple-100', 'text-purple-800');
        }
    }
}

function showQRCode(qrCode, familyName) {
    document.getElementById('qr-family-name').textContent = familyName + ' Family';
    document.getElementById('qr-code-text').textContent = qrCode;
    document.getElementById('qr-modal').style.display = 'flex';
}

function hideQRCode() {
    document.getElementById('qr-modal').style.display = 'none';
}

// Handle escape key for modal
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        hideQRCode();
    }
});
</script>