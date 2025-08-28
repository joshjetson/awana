<%-- 
Check-In Dynamic Content Template
Loaded via: /renderView?viewType=checkin
--%>

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