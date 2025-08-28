<!-- Check-In Error Message -->
<div class="bg-red-100 border border-red-400 text-red-700 px-6 py-4 rounded-xl animate-fade-in">
    <div class="flex items-center">
        <svg class="w-6 h-6 text-red-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <div>
            <div class="font-bold">Check-In Error</div>
            <div class="text-sm mt-1">${message}</div>
        </div>
    </div>
    
    <div class="mt-4">
        <button onclick="document.getElementById('family-checkin-area').innerHTML = ''; document.getElementById('qr-input').value = ''; document.getElementById('qr-input').focus();"
                class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition-colors">
            Try Again
        </button>
    </div>
</div>