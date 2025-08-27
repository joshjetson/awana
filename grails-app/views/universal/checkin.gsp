<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Family Check-In</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body>

<content tag="nav">
    <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2">
            <g:link uri="/" class="flex items-center space-x-2 text-blue-600 hover:text-blue-800">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
                <span class="font-semibold">Dashboard</span>
            </g:link>
        </div>
        <span class="font-bold text-lg text-gray-900">Family Check-In</span>
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
        </g:link>
    </div>
</content>

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-green-50 pb-20">
    
    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-green-600 to-blue-600 text-white px-4 py-8">
        <div class="max-w-4xl mx-auto text-center">
            <div class="w-20 h-20 bg-white bg-opacity-20 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold mb-2">Welcome to Club Night!</h1>
            <p class="text-green-100 text-lg">Scan your family QR code to check in</p>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Primary QR Scan Action -->
        <div class="bg-white rounded-2xl shadow-xl p-8 border-l-4 border-green-500 text-center">
            <div class="mb-6">
                <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4"/>
                    </svg>
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-2">Scan Family QR Code</h2>
                <p class="text-gray-600 text-lg">Point your camera at the family QR code</p>
            </div>
            
            <!-- QR Code Input (for demo - in real app this would be camera) -->
            <div class="space-y-4">
                <input type="text" 
                       id="qr-input" 
                       placeholder="Enter QR Code (e.g., HH-ABC123)" 
                       class="w-full px-6 py-4 text-xl text-center border-2 border-gray-300 rounded-xl 
                              focus:border-green-500 focus:ring-4 focus:ring-green-200 focus:outline-none
                              placeholder-gray-400 font-mono tracking-wider">
                              
                <button onclick="scanQRCode()" 
                        class="w-full bg-green-600 hover:bg-green-700 active:bg-green-800 
                               text-white font-bold py-4 px-8 rounded-xl text-xl
                               transition-all duration-200 transform hover:scale-105 active:scale-95
                               shadow-lg hover:shadow-xl">
                    <svg class="w-6 h-6 inline mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    Find Family
                </button>
            </div>
        </div>

        <!-- Family Check-In Results Area (loaded via HTMX) -->
        <div id="family-checkin-area" class="space-y-4">
            <!-- HTMX will load family check-in content here -->
        </div>

        <!-- Manual Search Fallback -->
        <div class="bg-white rounded-xl shadow-md p-6">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-bold text-gray-900">Manual Family Search</h3>
                <span class="text-sm text-gray-500">If QR code doesn't work</span>
            </div>
            
            <div class="space-y-3">
                <g:each in="${households}" var="household">
                    <button onclick="loadFamily('${household.qrCode}')" 
                            class="w-full text-left bg-gray-50 hover:bg-blue-50 active:bg-blue-100
                                   border border-gray-200 rounded-lg p-4 transition-colors
                                   min-h-[60px] touch-manipulation">
                        <div class="flex items-center justify-between">
                            <div class="flex-1">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 
                                                rounded-full flex items-center justify-center text-white font-bold text-sm">
                                        ${household.name.substring(0, 2).toUpperCase()}
                                    </div>
                                    <div>
                                        <div class="font-semibold text-gray-900">${household.name}</div>
                                        <div class="text-sm text-gray-600">${household.students?.size() ?: 0} children • ${household.qrCode}</div>
                                    </div>
                                </div>
                            </div>
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                            </svg>
                        </div>
                    </button>
                </g:each>
            </div>
        </div>

    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'checkin']"/>

<script>
// Simple QR code scanning function (demo version)
function scanQRCode() {
    const qrInput = document.getElementById('qr-input');
    const qrCode = qrInput.value.trim();
    
    if (!qrCode) {
        alert('Please enter a QR code');
        return;
    }
    
    loadFamily(qrCode);
}

// Load family via HTMX
function loadFamily(qrCode) {
    // Clear previous results
    document.getElementById('family-checkin-area').innerHTML = '';
    
    // Use HTMX to load family check-in using the checkInFamily action
    htmx.ajax('GET', '/checkInFamily', {
        values: { qrCode: qrCode },
        target: '#family-checkin-area',
        swap: 'innerHTML'
    });
}

// Allow Enter key to trigger scan
document.getElementById('qr-input').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        scanQRCode();
    }
});
</script>

</body>
</html>