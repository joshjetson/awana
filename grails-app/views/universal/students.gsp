<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Student Management - Awana Club</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body>

<content tag="nav">
    <div class="flex items-center justify-between">
        <!-- Left side: Back button -->
        <div class="flex items-center space-x-3">
            <g:link action="index" class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center hover:bg-blue-700 transition-colors">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
            </g:link>
        </div>

        <!-- Center: Search input -->
        <div class="flex-1 max-w-md mx-4">
            <div class="relative">
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <input type="text" 
                       id="nav-student-search"
                       name="nav-student-search"
                       placeholder="Search students..."
                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                       hx-get="/renderView?viewType=studentSearch"
                       hx-trigger="input changed delay:300ms"
                       hx-target="#main-content-area"
                       hx-swap="innerHTML"
                       hx-include="this"/>
            </div>
        </div>

        <!-- Right side: Logout -->
        <div class="flex items-center space-x-2">
            <g:link controller="logout" class="w-10 h-10 text-gray-600 hover:text-gray-900 rounded-lg hover:bg-gray-100 flex items-center justify-center transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                </svg>
            </g:link>
        </div>
    </div>
</content>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-blue-600 to-green-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold mb-2">Student Management</h1>
                    <div class="text-blue-100">
                        Search students, view club overviews, and manage progress
                    </div>
                </div>
                
                <!-- Action Icons -->
                <div class="flex items-center space-x-4">
                    <!-- Create Household Icon -->
                    <button hx-get="/renderView?viewType=createHousehold"
                            hx-target="#main-content-area"
                            hx-swap="innerHTML"
                            class="w-16 h-16 bg-white bg-opacity-30 hover:bg-opacity-40 rounded-lg flex items-center justify-center transition-colors shadow-lg border border-white border-opacity-20"
                            title="Create New Household">
                        <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                    </button>
                    
                    <!-- Manage Households Icon -->
                    <button hx-get="/renderView?viewType=manageHouseholds"
                            hx-target="#main-content-area"
                            hx-swap="innerHTML"
                            class="w-16 h-16 bg-white bg-opacity-30 hover:bg-opacity-40 rounded-lg flex items-center justify-center transition-colors shadow-lg border border-white border-opacity-20"
                            title="Manage Households">
                        <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 0 1 5.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 0 1 9.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6">
        
        <!-- Main Content Area - Fixed Viewport -->
        <div id="main-content-area" class="space-y-6">

            <!-- Default Students Content (loaded via HTMX) -->
            <div hx-get="/renderView?viewType=students" 
                 hx-trigger="load"
                 hx-swap="outerHTML">
                <!-- Club overview and quick actions load here via HTMX -->
            </div>
            
        </div>
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>


</body>
</html>