<div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
    <div class="flex items-center">
        <svg class="w-5 h-5 text-red-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <div>
            <h4 class="font-medium text-red-800">Error!</h4>
            <p class="text-sm text-red-700">${message ?: 'Failed to create record'}</p>
        </div>
    </div>
</div>