<g:if test="${student}">
    <!-- DEBUG INFO -->
    <div class="bg-red-100 p-4 mb-4">
        <p><strong>DEBUG:</strong></p>
        <p>Chapter ID: ${chapter?.id}</p>
        <p>Chapter Name: ${chapter?.name}</p>
        <p>Sections count: ${sections?.size()}</p>
        <p>Chapter.chapterSections: ${chapter?.chapterSections?.size()}</p>
        <p>Student: ${student?.firstName}</p>
    </div>
    <!-- Student Progress Mode -->
    <div class="mb-6 p-4 bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl border border-blue-200">
        <!-- DEBUG: Remove this after testing -->
        <div class="text-xs text-gray-500 mb-2">DEBUG: Chapter: ${chapter?.name}, Sections: ${sections?.size()}, Student: ${student?.firstName}</div>
        <div class="flex items-center space-x-3">
            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold">
                ${student?.firstName?.substring(0, 1) ?: '?'}${student?.lastName?.substring(0, 1) ?: '?'}
            </div>
            <div>
                <h4 class="font-bold text-gray-900">${student?.firstName} ${student?.lastName}</h4>
                <p class="text-sm text-gray-600">Track progress for ${chapter?.name ?: 'Unknown Chapter'}</p>
            </div>
        </div>
    </div>

    <div class="space-y-4">
        <g:each in="${sections}" var="section">
            <g:set var="completion" value="${completions[section.id]}" />
            <div class="bg-white border border-gray-200 rounded-xl p-6 hover:shadow-lg transition-all duration-300">
                <!-- Section Header -->
                <div class="flex items-center justify-between mb-4">
                    <div class="flex-1">
                        <h4 class="text-lg font-bold text-gray-900 mb-2">Section ${section?.sectionNumber ?: 'N/A'}</h4>
                        <g:if test="${section?.content}">
                            <p class="text-gray-600">${section.content}</p>
                        </g:if>
                    </div>
                    
                    <!-- Progress indicator -->
                    <g:if test="${completion?.hasAnyCompletion()}">
                        <div class="flex items-center space-x-2 text-green-600">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>
                            </svg>
                            <span class="font-medium">${completion.bucksEarned} bucks</span>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="text-gray-400">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                        </div>
                    </g:else>
                </div>
                
                <!-- Completion Toggles -->
                <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                    
                    <!-- Student Verse -->
                    <button type="button"
                            class="completion-toggle ${completion?.studentCompleted ? 'bg-green-500 text-white border-green-500 shadow-lg' : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'} 
                                   border-2 rounded-xl p-4 transition-all duration-300 transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-green-200"
                            <g:if test="${completion}">hx-put="/api/universal/SectionVerseCompletion/${completion.id}?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"</g:if>
                            <g:else>hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"</g:else>
                            hx-target="#modal-sections-content"
                            hx-swap="innerHTML"
                            hx-vals='{"student.id": "${student?.id}", "chapterSection.id": "${section?.id}", "studentCompleted": "${!completion?.studentCompleted}", "parentCompleted": "false", "reviewCompleted": "false", "silverSectionCompleted": "false", "goldSectionCompleted": "false", "chapterReview": "false"}'>
                        <div class="text-center">
                            <svg class="w-6 h-6 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            <div class="font-bold text-sm">Student Verse</div>
                            <div class="text-xs opacity-75">+1 buck</div>
                        </div>
                    </button>
                    
                    <!-- Parent Verse -->
                    <button type="button"
                            class="completion-toggle ${completion?.parentCompleted ? 'bg-purple-500 text-white border-purple-500 shadow-lg' : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'} 
                                   border-2 rounded-xl p-4 transition-all duration-300 transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-purple-200"
                            hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"
                            hx-target="#modal-sections-content"
                            hx-swap="innerHTML"
                            hx-vals='{"student.id": "${student?.id}", "chapterSection.id": "${section?.id}", "studentCompleted": "false", "parentCompleted": "${!completion?.parentCompleted}", "reviewCompleted": "false", "silverSectionCompleted": "false", "goldSectionCompleted": "false", "chapterReview": "false"}'>
                        <div class="text-center">
                            <svg class="w-6 h-6 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                            </svg>
                            <div class="font-bold text-sm">Parent Verse</div>
                            <div class="text-xs opacity-75">+2 bucks</div>
                        </div>
                    </button>
                    
                    <!-- Silver Section -->
                    <button type="button"
                            class="completion-toggle ${completion?.silverSectionCompleted ? 'bg-gray-500 text-white border-gray-500 shadow-lg' : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'} 
                                   border-2 rounded-xl p-4 transition-all duration-300 transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-gray-200"
                            hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"
                            hx-target="#modal-sections-content"
                            hx-swap="innerHTML"
                            hx-vals='{"student.id": "${student?.id}", "chapterSection.id": "${section?.id}", "studentCompleted": "false", "parentCompleted": "false", "reviewCompleted": "false", "silverSectionCompleted": "${!completion?.silverSectionCompleted}", "goldSectionCompleted": "false", "chapterReview": "false"}'>
                        <div class="text-center">
                            <svg class="w-6 h-6 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <div class="font-bold text-sm">Silver Section</div>
                            <div class="text-xs opacity-75">+1 buck</div>
                        </div>
                    </button>
                    
                    <!-- Gold Section -->
                    <button type="button"
                            class="completion-toggle ${completion?.goldSectionCompleted ? 'bg-yellow-500 text-white border-yellow-500 shadow-lg' : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'} 
                                   border-2 rounded-xl p-4 transition-all duration-300 transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-yellow-200"
                            hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"
                            hx-target="#modal-sections-content"
                            hx-swap="innerHTML"
                            hx-vals='{"student.id": "${student?.id}", "chapterSection.id": "${section?.id}", "studentCompleted": "false", "parentCompleted": "false", "reviewCompleted": "false", "silverSectionCompleted": "false", "goldSectionCompleted": "${!completion?.goldSectionCompleted}", "chapterReview": "false"}'>
                        <div class="text-center">
                            <svg class="w-6 h-6 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                            </svg>
                            <div class="font-bold text-sm">Gold Section</div>
                            <div class="text-xs opacity-75">+3 bucks</div>
                        </div>
                    </button>
                    
                    <!-- Chapter Review -->
                    <button type="button"
                            class="completion-toggle ${completion?.chapterReview ? 'bg-red-500 text-white border-red-500 shadow-lg' : 'bg-gray-100 text-gray-700 border-gray-300 hover:bg-gray-200'} 
                                   border-2 rounded-xl p-4 transition-all duration-300 transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-red-200"
                            hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=chapterSections&refreshStudentId=${student?.id}&chapterId=${chapter?.id}&sectionId=${section?.id}"
                            hx-target="#modal-sections-content"
                            hx-swap="innerHTML"
                            hx-vals='{"student.id": "${student?.id}", "chapterSection.id": "${section?.id}", "studentCompleted": "false", "parentCompleted": "false", "reviewCompleted": "false", "silverSectionCompleted": "false", "goldSectionCompleted": "false", "chapterReview": "${!completion?.chapterReview}"}'>
                        <div class="text-center">
                            <svg class="w-6 h-6 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.09-5.09A1.5 1.5 0 0118 4.5v15A1.5 1.5 0 0116.5 21h-15A1.5 1.5 0 010 19.5v-15A1.5 1.5 0 011.5 3h15a1.5 1.5 0 011.5 1.5z"/>
                            </svg>
                            <div class="font-bold text-sm">Chapter Review</div>
                            <div class="text-xs opacity-75">+5 bucks</div>
                        </div>
                    </button>
                </div>
                
                <!-- Completion Summary -->
                <g:if test="${completion?.hasAnyCompletion()}">
                    <div class="mt-4 p-3 bg-green-50 rounded-lg border border-green-200">
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-medium text-green-800">Completed: ${completion?.getCompletionSummary() ?: 'None'}</span>
                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-bold bg-green-500 text-white">
                                ${completion?.bucksEarned ?: 0} bucks earned
                            </span>
                        </div>
                    </div>
                </g:if>
            </div>
        </g:each>
    </div>
</g:if>
<g:else>
    <!-- Original Simple Mode (for book creation/editing) -->
    <g:each in="${sections}" var="section">
        <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 cursor-pointer section-card" 
             data-section-id="${section?.id}"
             onclick="selectSection(${section?.id})">
            <div class="flex items-center justify-between">
                <div class="flex-1">
                    <h4 class="font-semibold text-gray-900">Section ${section?.sectionNumber ?: 'N/A'}</h4>
                    <p class="text-sm text-gray-600 mt-1">${section?.content ?: ''}</p>
                    
                    <!-- Section info -->
                    <div class="mt-2 flex space-x-2">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                            Regular Section
                        </span>
                    </div>
                </div>
                <div class="text-sm text-gray-500">
                    Click to select
                </div>
            </div>
        </div>
    </g:each>
</g:else>

<g:if test="${!sections || sections.isEmpty()}">
    <div class="text-center py-8 text-gray-500">
        <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
        </svg>
        <p>No sections found for this chapter.</p>
        <p class="text-sm mt-1">Please select a different chapter.</p>
    </div>
</g:if>