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

    <!-- Search Input -->
    <div class="mb-4">
        <input type="text"
               name="familySearch"
               id="family-search-input"
               placeholder="Search by family name or child's name..."
               class="w-full px-4 py-3 text-lg border-2 border-gray-300 rounded-xl
                      focus:border-blue-500 focus:ring-4 focus:ring-blue-200 focus:outline-none
                      placeholder-gray-400"
               hx-get="/renderView?viewType=searchHouseholds"
               hx-trigger="keyup changed delay:300ms, load"
               hx-target="#household-search-results"
               hx-swap="innerHTML">
    </div>

    <!-- Search Results Container -->
    <div id="household-search-results" class="space-y-3">
        <!-- Search results will load here dynamically -->
    </div>
</div>