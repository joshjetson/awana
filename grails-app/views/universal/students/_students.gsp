<%-- 
Students Dynamic Content Template
Loaded via: /renderView?viewType=students
--%>

<!-- Back Button (hidden by default, shown when viewing club/filter content) -->
<div id="back-button" class="bg-white rounded-xl shadow-lg p-4 mb-6" style="display: none;">
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

<!-- Club Overview Section -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900">Browse by Club</h2>
        <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
            ${clubs?.size() ?: 0} clubs
        </span>
    </div>

    <!-- Club Cards Grid -->
    <div class="grid md:grid-cols-2 gap-4">
        <g:each in="${clubs}" var="club">
            <div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow cursor-pointer"
                 hx-get="/renderView?viewType=clubOverview&clubId=${club.id}"
                 hx-target="#main-content-area"
                 hx-swap="innerHTML">
                
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="text-lg font-bold text-gray-900">${club.name}</h3>
                        <p class="text-sm text-gray-600">${club.ageRange}</p>
                    </div>
                    <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-500 rounded-lg flex items-center justify-center text-white font-bold text-lg">
                        ${club.name.substring(0, 1)}
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-4 text-sm mb-4">
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${club.students?.size() ?: 0}</div>
                        <div class="text-gray-600">Students</div>
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-green-600">${club.students?.sum { it.calculateTotalBucks() } ?: 0}</div>
                        <div class="text-gray-600">Total Bucks</div>
                    </div>
                </div>

                <div class="flex space-x-2">
                    <div class="flex-1 bg-gray-100 rounded-lg px-3 py-2 text-center">
                        <div class="font-medium text-gray-900">View Students</div>
                        <div class="text-xs text-gray-600">Browse & manage</div>
                    </div>
                    <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</div>

<!-- Quick Actions -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <h2 class="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
    
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <!-- All Students -->
        <button hx-get="/renderView?viewType=studentSearch&showAll=true"
                hx-target="#main-content-area"
                hx-swap="innerHTML"
                class="bg-blue-50 hover:bg-blue-100 p-4 rounded-lg text-center transition-colors">
            <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center mx-auto mb-2">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
            </div>
            <div class="font-medium text-sm text-blue-900">All Students</div>
            <div class="text-xs text-blue-700">${studentCount ?: 0} total</div>
        </button>

        <!-- Top Performers -->
        <button hx-get="/renderView?viewType=studentSearch&filter=topPerformers"
                hx-target="#main-content-area"
                hx-swap="innerHTML"
                class="bg-green-50 hover:bg-green-100 p-4 rounded-lg text-center transition-colors">
            <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-2">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                </svg>
            </div>
            <div class="font-medium text-sm text-green-900">Top Earners</div>
            <div class="text-xs text-green-700">Most bucks</div>
        </button>

        <!-- Recent Completions -->
        <button hx-get="/renderView?viewType=studentSearch&filter=recentCompletions"
                hx-target="#main-content-area"
                hx-swap="innerHTML"
                class="bg-purple-50 hover:bg-purple-100 p-4 rounded-lg text-center transition-colors">
            <div class="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center mx-auto mb-2">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                </svg>
            </div>
            <div class="font-medium text-sm text-purple-900">Recent Verses</div>
            <div class="text-xs text-purple-700">This week</div>
        </button>

        <!-- Needs Attention -->
        <button hx-get="/renderView?viewType=studentSearch&filter=needsAttention"
                hx-target="#main-content-area"
                hx-swap="innerHTML"
                class="bg-orange-50 hover:bg-orange-100 p-4 rounded-lg text-center transition-colors">
            <div class="w-10 h-10 bg-orange-500 rounded-full flex items-center justify-center mx-auto mb-2">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <div class="font-medium text-sm text-orange-900">Low Activity</div>
            <div class="text-xs text-orange-700">Needs follow-up</div>
        </button>
    </div>
</div>