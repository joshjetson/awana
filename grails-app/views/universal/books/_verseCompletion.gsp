<div class="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 pb-20">
    <!-- Fun Header with Student Info -->
    <div class="bg-gradient-to-r from-purple-600 via-blue-600 to-green-500 text-white px-4 py-6 relative overflow-hidden">
        <!-- Background Pattern -->
        <div class="absolute inset-0 opacity-10">
            <div class="absolute top-4 left-4 w-8 h-8 border-2 border-white rounded-full"></div>
            <div class="absolute top-12 right-8 w-6 h-6 border-2 border-white rounded"></div>
            <div class="absolute bottom-6 left-12 w-4 h-4 bg-white rounded-full"></div>
            <div class="absolute bottom-4 right-16 w-5 h-5 border-2 border-white rounded"></div>
        </div>
        
        <div class="max-w-4xl mx-auto relative z-10">
            <!-- Back Button -->
            <button hx-get="/renderView?viewType=clubOverview&clubId=${selectedStudent?.club?.id}"
                    hx-target="#main-content-area"
                    hx-swap="innerHTML"
                    class="inline-flex items-center space-x-2 text-white hover:text-yellow-200 font-medium mb-4 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to ${selectedStudent?.club?.name}</span>
            </button>
            
            <g:if test="${selectedStudent}">
                <div class="flex items-center space-x-4">
                    <div class="w-16 h-16 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full flex items-center justify-center text-white font-bold text-2xl border-4 border-white shadow-lg">
                        ${selectedStudent.firstName.substring(0, 1)}${selectedStudent.lastName.substring(0, 1)}
                    </div>
                    <div>
                        <h1 class="text-3xl font-bold mb-1">${selectedStudent.firstName}'s Handbook Progress</h1>
                        <div class="flex items-center space-x-4 text-white/90">
                            <span class="flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                                </svg>
                                <span class="font-bold">${selectedStudent.calculateTotalBucks()} Bucks</span>
                            </span>
                            <span class="flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <span>${selectedStudent.sectionVerseCompletions?.size() ?: 0} Completed</span>
                            </span>
                        </div>
                    </div>
                </div>
            </g:if>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <g:if test="${selectedStudent}">
            <!-- Student's Primary Book -->
            <g:if test="${books}">
                <g:each in="${books}" var="book">
                    <div class="bg-white rounded-2xl shadow-xl overflow-hidden mb-6 transform transition-all duration-300 hover:scale-[1.02]">
                        <!-- Book Header -->
                        <div class="bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 text-white p-6 relative overflow-hidden">
                            <!-- Fun background elements -->
                            <div class="absolute top-2 right-2 w-12 h-12 border-2 border-white/20 rounded-full animate-pulse"></div>
                            <div class="absolute bottom-2 left-2 w-8 h-8 bg-white/10 rounded-full"></div>
                            
                            <div class="relative z-10">
                                <div class="flex items-center justify-between mb-3">
                                    <h2 class="text-2xl font-bold">${book.name}</h2>
                                </div>
                                <p class="text-white/90">${selectedStudent.club.name} Handbook</p>
                            </div>
                        </div>
                        
                        <!-- Chapters Grid -->
                        <div class="p-6">
                            <g:if test="${book.chapters}">
                                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                                    <g:each in="${book.chapters.sort { it.chapterNumber }}" var="chapter">
                                        <div class="bg-gradient-to-br from-blue-50 to-purple-50 rounded-xl p-4 border border-blue-200 hover:shadow-lg transition-all duration-300 cursor-pointer chapter-card transform hover:scale-105" 
                                             data-chapter-id="${chapter.id}" 
                                             onclick="toggleChapterSections(${chapter.id})">
                                            
                                            <!-- Chapter Number Badge -->
                                            <div class="flex items-center justify-between mb-3">
                                                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                                    ${chapter.chapterNumber}
                                                </div>
                                                
                                                <!-- Progress indicator -->
                                                <g:set var="chapterCompletions" value="${selectedStudent.sectionVerseCompletions?.findAll { it.chapterSection.chapter.id == chapter.id }}" />
                                                <g:set var="totalSections" value="${chapter.chapterSections?.size() ?: 0}" />
                                                <g:set var="completedSections" value="${chapterCompletions?.count { it.hasAnyCompletion() } ?: 0}" />
                                                
                                                <div class="flex items-center space-x-1">
                                                    <g:if test="${totalSections > 0 && completedSections == totalSections}">
                                                        <div class="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                                                            <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 24 24">
                                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>
                                                            </svg>
                                                        </div>
                                                    </g:if>
                                                    <g:elseif test="${completedSections > 0}">
                                                        <div class="w-6 h-6 bg-yellow-500 rounded-full flex items-center justify-center">
                                                            <span class="text-white text-xs font-bold">${Math.round((completedSections / totalSections) * 100)}%</span>
                                                        </div>
                                                    </g:elseif>
                                                    <g:else>
                                                        <div class="w-6 h-6 bg-gray-300 rounded-full flex items-center justify-center">
                                                            <span class="text-gray-600 text-xs">•</span>
                                                        </div>
                                                    </g:else>
                                                </div>
                                            </div>
                                            
                                            <div>
                                                <h3 class="font-bold text-gray-900 mb-2 text-lg">${chapter.name}</h3>
                                                <div class="flex items-center justify-between text-sm">
                                                    <span class="text-blue-600 font-medium">${totalSections} sections</span>
                                                    <span class="text-green-600 font-medium">${completedSections} done</span>
                                                </div>
                                                
                                                <!-- Progress bar -->
                                                <g:if test="${totalSections > 0}">
                                                    <div class="mt-3 bg-gray-200 rounded-full h-2 overflow-hidden">
                                                        <div class="bg-gradient-to-r from-green-400 to-blue-500 h-full rounded-full transition-all duration-500" 
                                                             style="width: ${(completedSections / totalSections) * 100}%"></div>
                                                    </div>
                                                </g:if>
                                            </div>
                                        </div>
                                        
                                        <!-- Chapter Sections (initially hidden) -->
                                        <div id="sections-${chapter.id}" class="hidden mt-4 space-y-3">
                                            <g:each in="${chapter.chapterSections?.sort { it.sectionNumber }}" var="section">
                                                <div class="bg-white border border-gray-200 rounded-xl p-4 ml-4">
                                                    <div class="flex items-center justify-between mb-3">
                                                        <div>
                                                            <h5 class="font-bold text-gray-900">Section ${section?.sectionNumber ?: 'N/A'}</h5>
                                                            <p class="text-sm text-gray-600">${section?.content}</p>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Completion Toggles -->
                                                    <div class="grid grid-cols-2 md:grid-cols-3 gap-2">
                                                        <!-- Student Verse -->
                                                        <button type="button" class="bg-green-100 hover:bg-green-200 text-green-800 border border-green-300 rounded-lg p-2 text-xs font-bold transition-colors">
                                                            Student Verse (+1)
                                                        </button>
                                                        <!-- Parent Verse -->
                                                        <button type="button" class="bg-purple-100 hover:bg-purple-200 text-purple-800 border border-purple-300 rounded-lg p-2 text-xs font-bold transition-colors">
                                                            Parent Verse (+2)
                                                        </button>
                                                        <!-- Silver Section -->
                                                        <button type="button" class="bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-300 rounded-lg p-2 text-xs font-bold transition-colors">
                                                            Silver (+1)
                                                        </button>
                                                        <!-- Gold Section -->
                                                        <button type="button" class="bg-yellow-100 hover:bg-yellow-200 text-yellow-800 border border-yellow-300 rounded-lg p-2 text-xs font-bold transition-colors">
                                                            Gold (+3)
                                                        </button>
                                                        <!-- Chapter Review -->
                                                        <button type="button" class="bg-red-100 hover:bg-red-200 text-red-800 border border-red-300 rounded-lg p-2 text-xs font-bold transition-colors">
                                                            Review (+5)
                                                        </button>
                                                    </div>
                                                </div>
                                            </g:each>
                                        </div>
                                    </g:each>
                                </div>
                            </g:if>
                            <g:else>
                                <div class="text-center py-8 text-gray-500">
                                    <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                    </svg>
                                    <p>No chapters available in this book yet.</p>
                                </div>
                            </g:else>
                        </div>
                    </div>
                </g:each>
            </g:if>
            <g:else>
                <div class="bg-white rounded-xl shadow-lg p-8 text-center">
                    <svg class="w-16 h-16 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">No Books Available</h3>
                    <p class="text-gray-600 mb-6">This club doesn't have any books configured yet.</p>
                    <button hx-get="/renderView?viewType=clubBooks&clubId=${selectedStudent.club.id}"
                            hx-target="#main-content-area"
                            hx-swap="innerHTML"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
                        Manage Books
                    </button>
                </div>
            </g:else>
        </g:if>

        <!-- Chapter Sections Modal (Hidden) - COMMENTED OUT FOR NOW -->
        <!--
        <div id="sections-modal" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 hidden flex items-end md:items-center justify-center p-4">
            <div class="bg-white rounded-t-2xl md:rounded-2xl w-full max-w-4xl max-h-[90vh] overflow-hidden transform transition-all duration-300">
                <!-- Modal Header -->
                <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white p-6 relative">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 id="modal-chapter-title" class="text-2xl font-bold">Chapter Name</h3>
                            <p id="modal-book-info" class="text-purple-100">Book Name</p>
                        </div>
                        <button onclick="closeSectionsModal()" class="p-2 hover:bg-white/10 rounded-lg transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>
                </div>
                
                <!-- Modal Content -->
                <div id="modal-sections-content" class="p-6 overflow-y-auto max-h-[70vh]">
                    <!-- Sections will be loaded here -->
                </div>
            </div>
        </div>
        -->
        
        <!-- Success Toast (Hidden) -->
        <div id="success-toast" class="fixed top-4 right-4 bg-green-500 text-white px-6 py-4 rounded-lg shadow-lg transform translate-x-full transition-transform duration-300 z-50">
            <div class="flex items-center space-x-2">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>
                </svg>
                <span id="toast-message" class="font-medium">Progress saved!</span>
            </div>
        </div>
        
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>

<script>
// Simple show/hide sections functionality
const currentStudentId = ${selectedStudent?.id ?: 'null'};

function toggleChapterSections(chapterId) {
    const sectionsDiv = document.getElementById('sections-' + chapterId);
    if (sectionsDiv) {
        sectionsDiv.classList.toggle('hidden');
    }
}
</script>

