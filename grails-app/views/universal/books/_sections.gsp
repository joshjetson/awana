<%-- 
Sections Template - Chapter Sections Grid
Loaded via: /renderView?viewType=sections&chapterId=123&studentId=456
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <!-- Back Button -->
            <button hx-get="/renderView?viewType=verseCompletion&studentId=${selectedStudent?.id}"
                    hx-target="#main-content-area"
                    hx-swap="innerHTML"
                    class="inline-flex items-center space-x-2 text-white hover:text-yellow-200 font-medium mb-4 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to ${selectedStudent?.firstName}'s Progress</span>
            </button>
            
            <h1 class="text-3xl font-bold mb-2">${chapter?.name ?: 'Chapter'} Sections</h1>
            <div class="text-purple-100">
                ${selectedStudent?.firstName} ${selectedStudent?.lastName} • ${selectedStudent?.club?.name} • Chapter ${chapter?.chapterNumber}
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Sections Grid -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900">Chapter Sections</h2>
                <span class="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm font-medium">
                    ${sections?.size() ?: 0} sections
                </span>
            </div>

            <g:if test="${sections}">
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                    <g:each in="${sections}" var="section">
                        <div class="bg-gradient-to-br from-blue-50 to-purple-50 rounded-xl p-4 border border-blue-200 hover:shadow-lg transition-all duration-300">
                            
                            <!-- Section Header -->
                            <div class="flex items-center justify-between mb-3">
                                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                    ${section?.sectionNumber}
                                </div>
                                
                                <!-- Progress indicator placeholder -->
                                <div class="w-6 h-6 bg-gray-300 rounded-full flex items-center justify-center">
                                    <span class="text-gray-600 text-xs">•</span>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <h3 class="font-bold text-gray-900 mb-2 text-lg">Section ${section?.sectionNumber}</h3>
                                <p class="text-sm text-gray-600">${section?.content}</p>
                            </div>
                            
                            <!-- Completion Toggles Grid -->
                            <div class="grid grid-cols-2 gap-2">
                                
                                <!-- Student Memory Verse -->
                                <button type="button" class="bg-green-100 hover:bg-green-200 text-green-800 border border-green-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                    <div class="text-center">
                                        <div class="font-bold">Memory Verse</div>
                                        <div class="text-xs opacity-75">+1 buck</div>
                                    </div>
                                </button>
                                
                                <!-- parent verse -->
                                <button type="button" class="bg-purple-100 hover:bg-purple-200 text-purple-800 border border-purple-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                    <div class="text-center">
                                        <div class="font-bold">Parent</div>
                                        <div class="text-xs opacity-75">+2 bucks</div>
                                    </div>
                                </button>

                            <!-- parent verse -->
                            <button type="button" class="bg-purple-100 hover:bg-purple-200 text-purple-800 border border-purple-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                <div class="text-center">
                                    <div class="font-bold">Review</div>
                                    <div class="text-xs opacity-75">+2 bucks</div>
                                </div>
                            </button>

                                <!-- Silver Section -->
                                <button type="button" class="bg-gray-100 hover:bg-gray-200 text-gray-800 border border-gray-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                    <div class="text-center">
                                        <div class="font-bold">Silver</div>
                                        <div class="text-xs opacity-75">+1 buck</div>
                                    </div>
                                </button>
                                
                                <!-- Gold Section -->
                                <button type="button" class="bg-yellow-100 hover:bg-yellow-200 text-yellow-800 border border-yellow-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                    <div class="text-center">
                                        <div class="font-bold">Gold</div>
                                        <div class="text-xs opacity-75">+3 bucks</div>
                                    </div>
                                </button>
                                
                            </div>
                            
                            <!-- Chapter Review (spans full width) - Only show for final section -->
                            <g:if test="${section?.isFinalSection}">
                                <button type="button" class="w-full mt-2 bg-red-100 hover:bg-red-200 text-red-800 border border-red-300 rounded-lg p-3 text-xs font-bold transition-colors transform hover:scale-105">
                                    <div class="text-center">
                                        <div class="font-bold">Chapter Review</div>
                                        <div class="text-xs opacity-75">+5 bucks</div>
                                    </div>
                                </button>
                            </g:if>
                        </div>
                    </g:each>
                </div>
            </g:if>
            <g:else>
                <div class="text-center py-12">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No sections found</h3>
                    <p class="text-gray-600">This chapter doesn't have any sections yet.</p>
                </div>
            </g:else>
        </div>
        
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>