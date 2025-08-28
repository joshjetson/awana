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
        <div class="flex items-center space-x-2">
            <g:link action="index" class="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center hover:bg-blue-700 transition-colors">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
            </g:link>
            <span class="font-semibold text-gray-900">Student Management</span>
        </div>
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
        </g:link>
    </div>
</content>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-blue-600 to-green-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Student Management</h1>
            <div class="text-blue-100">
                Search students, view club overviews, and manage progress
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Search Section -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4">Find Student</h2>
            
            <g:set var="searchIcon">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
            </g:set>

            <g:render template="/components/touchInput" model="[
                name: 'global-student-search',
                label: 'Search by student name',
                placeholder: 'Enter student first or last name...',
                type: 'text',
                icon: searchIcon
            ]"/>

            <!-- Search Results -->
            <div id="student-search-results" class="mt-4 space-y-3" style="display: none;">
                <h3 class="font-semibold text-gray-900">Search Results</h3>
                <div id="search-results-container">
                    <!-- Search results will be populated here -->
                </div>
            </div>
        </div>

        <!-- Dynamic Students Content (loaded via HTMX) -->
        <div id="students-page-content" 
             hx-get="/renderView?viewType=students" 
             hx-trigger="load"
             hx-swap="innerHTML"
             class="space-y-6">
            <!-- Club overview and quick actions load here via HTMX -->
        </div>

        <!-- Dynamic Content Area -->
        <div id="dynamic-content" style="display: none;">
            <!-- Club or student details will be loaded here -->
        </div>
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>

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
    // This will be called after HTMX loads the results
    // We can add click handlers to the loaded student cards here
    document.querySelectorAll('.search-student-card').forEach(card => {
        card.addEventListener('click', function() {
            const studentId = this.dataset.studentId;
            viewStudent(studentId);
        });
    });
}

function viewClub(clubId, clubName) {
    // Load club overview with all students
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'clubOverview',
            clubId: clubId
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.getElementById('dynamic-content').style.display = 'block';
        document.getElementById('dynamic-content').scrollIntoView({ behavior: 'smooth' });
    });
}

function viewStudent(studentId) {
    // Navigate to individual student management
    window.location.href = '/student/' + studentId;
}

function viewAllStudents() {
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'studentSearch',
            showAll: 'true'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.getElementById('dynamic-content').style.display = 'block';
        document.getElementById('dynamic-content').scrollIntoView({ behavior: 'smooth' });
    });
}

function viewTopPerformers() {
    // Load top performing students
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'studentSearch',
            filter: 'topPerformers'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.getElementById('dynamic-content').style.display = 'block';
        document.getElementById('dynamic-content').scrollIntoView({ behavior: 'smooth' });
    });
}

function viewRecentCompletions() {
    // Load recent verse completions
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'studentSearch',
            filter: 'recentCompletions'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.getElementById('dynamic-content').style.display = 'block';
        document.getElementById('dynamic-content').scrollIntoView({ behavior: 'smooth' });
    });
}

function viewNeedsAttention() {
    // Load students with low activity
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'studentSearch',
            filter: 'needsAttention'
        },
        target: '#dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        document.getElementById('dynamic-content').style.display = 'block';
        document.getElementById('dynamic-content').scrollIntoView({ behavior: 'smooth' });
    });
}

</script>

</body>
</html>