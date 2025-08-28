<%-- 
Main Clubs Management Content Template 
Loaded via: /renderView?viewType=clubs
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Club Management</h1>
            <div class="text-purple-100">
                Manage Awana clubs, assign students, and configure club settings
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Create Club Section -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-xl font-bold text-gray-900">Create New Club</h2>
                <button hx-get="/renderView?viewType=clubCreateForm" 
                        hx-target="#create-club-form" 
                        hx-swap="innerHTML"
                        class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center space-x-2 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span>Add Club</span>
                </button>
            </div>
            
            <!-- Create Club Form Area -->
            <div id="create-club-form">
                <!-- Form will be loaded here via HTMX -->
            </div>
        </div>

        <!-- Existing Clubs Section -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900">Existing Clubs</h2>
                <span class="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm font-medium">
                    ${clubCount ?: 0} clubs
                </span>
            </div>

            <!-- Clubs List -->
            <div id="clubs-list" class="space-y-4">
                <g:if test="${clubs}">
                    <g:each in="${clubs}" var="club">
                        <g:render template="clubsList" model="[club: club]"/>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="text-center py-12">
                        <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                            </svg>
                        </div>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">No clubs yet</h3>
                        <p class="text-gray-600 mb-4">Create your first Awana club to get started</p>
                        <button hx-get="/renderView?viewType=clubCreateForm" 
                                hx-target="#create-club-form" 
                                hx-swap="innerHTML"
                                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
                            Create First Club
                        </button>
                    </div>
                </g:else>
            </div>
        </div>

        <!-- Dynamic Content Area -->
        <div id="dynamic-content" style="display: none;">
            <!-- Club management details will be loaded here -->
        </div>
    </div>
</div>