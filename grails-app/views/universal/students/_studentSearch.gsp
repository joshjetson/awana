<!-- Student Search & Club Management -->
<div class="space-y-6">
    <!-- Search Section -->
    <div class="bg-white rounded-xl shadow-lg p-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4">Find Student</h2>
        
        <g:set var="searchIcon">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
        </g:set>

        <g:render template="/components/touchInput" model="[
            name: 'studentSearch',
            label: 'Search by student name',
            placeholder: 'Enter student first or last name...',
            type: 'text',
            icon: searchIcon,
            id: 'global-student-search'
        ]"/>

        <!-- Search Results -->
        <div id="student-search-results" class="mt-4 space-y-3" style="display: none;">
            <h3 class="font-semibold text-gray-900">Search Results</h3>
            <div id="search-results-container">
                <!-- Search results will be populated here -->
            </div>
        </div>
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
                <div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow cursor-pointer club-card" 
                     data-club-id="${club.id}"
                     onclick="showClubOverview(${club.id}, '${club.name.encodeAsJavaScript()}')">
                    
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
            <button onclick="viewAllStudents()" class="bg-blue-50 hover:bg-blue-100 p-4 rounded-lg text-center transition-colors">
                <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center mx-auto mb-2">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                </div>
                <div class="font-medium text-sm text-blue-900">All Students</div>
                <div class="text-xs text-blue-700">${studentCount ?: 0} total</div>
            </button>

            <!-- Top Performers -->
            <button onclick="viewTopPerformers()" class="bg-green-50 hover:bg-green-100 p-4 rounded-lg text-center transition-colors">
                <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-2">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                    </svg>
                </div>
                <div class="font-medium text-sm text-green-900">Top Earners</div>
                <div class="text-xs text-green-700">Most bucks</div>
            </button>

            <!-- Recent Completions -->
            <button onclick="viewRecentCompletions()" class="bg-purple-50 hover:bg-purple-100 p-4 rounded-lg text-center transition-colors">
                <div class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center mx-auto mb-2">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                </div>
                <div class="font-medium text-sm text-purple-900">Recent Verses</div>
                <div class="text-xs text-purple-700">This week</div>
            </button>

            <!-- Needs Attention -->
            <button onclick="viewNeedsAttention()" class="bg-orange-50 hover:bg-orange-100 p-4 rounded-lg text-center transition-colors">
                <div class="w-8 h-8 bg-orange-500 rounded-full flex items-center justify-center mx-auto mb-2">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
                <div class="font-medium text-sm text-orange-900">Low Activity</div>
                <div class="text-xs text-orange-700">Needs follow-up</div>
            </button>
        </div>
    </div>
</div>

<script>
// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Global student search
    const searchInput = document.getElementById('global-student-search');
    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            const searchTerm = e.target.value.trim();
            const resultsDiv = document.getElementById('student-search-results');
            const containerDiv = document.getElementById('search-results-container');
            
            if (searchTerm.length < 2) {
                if (resultsDiv) resultsDiv.style.display = 'none';
                return;
            }
            
            // Search using HTMX
            htmx.ajax('GET', '/api/universal/Student', {
                values: { 
                    search: searchTerm,
                    paginated: 'false'
                },
                target: '#search-results-container',
                swap: 'innerHTML'
            }).then(() => {
                if (resultsDiv) resultsDiv.style.display = 'block';
                renderSearchResults();
            });
        });
    }
});

function renderSearchResults() {
    // Add click handlers to the loaded student cards
    document.querySelectorAll('.search-student-card').forEach(card => {
        card.addEventListener('click', function() {
            const studentId = this.dataset.studentId;
            showVerseCompletion(studentId);
        });
    });
}

function viewAllStudents() {
    htmx.ajax('GET', '/api/universal/Student', {
        values: { paginated: 'false' },
        target: '#dynamic-content',
        swap: 'innerHTML'
    });
}

function viewTopPerformers() {
    htmx.ajax('GET', '/api/universal/Student', {
        values: { 
            paginated: 'true',
            sort: 'awanaBucks',
            order: 'desc',
            max: '10'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    });
}

function viewRecentCompletions() {
    htmx.ajax('GET', '/api/universal/SectionVerseCompletion', {
        values: { 
            paginated: 'true',
            sort: 'completionDate',
            order: 'desc',
            max: '20'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    });
}

function viewNeedsAttention() {
    alert('Needs Attention view - to be implemented with custom query');
}
</script>