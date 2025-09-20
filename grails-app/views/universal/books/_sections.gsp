<%-- 
Sections Template with Drawer Layout - Chapter Sections
Loaded via: /renderView?viewType=sections&chapterId=123&studentId=456
--%>

<div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-4">
        <div class="max-w-7xl mx-auto">
            <!-- Back Button -->
            <button hx-get="/renderView?viewType=verseCompletion&studentId=${selectedStudent?.id}"
                    hx-target="#main-content-area"
                    hx-swap="innerHTML"
                    class="inline-flex items-center space-x-2 text-white hover:text-yellow-200 font-medium mb-3 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to ${selectedStudent?.firstName}'s Progress</span>
            </button>

            <h1 class="text-2xl font-bold mb-1">${chapter?.name ?: 'Chapter'} Sections</h1>
            <div class="text-purple-100 text-sm">
                ${selectedStudent?.firstName} ${selectedStudent?.lastName} • ${selectedStudent?.club?.name} • Chapter ${chapter?.chapterNumber}
            </div>
        </div>
    </div>

    <!-- Outer Container Frame -->
    <div class="max-w-7xl mx-auto px-4 py-6">
        <div class="w-full border border-gray-200 bg-white rounded-xl shadow-lg overflow-hidden">

            <!-- Mobile-First Layout Container -->
            <div class="block md:flex md:h-[75vh]">

                <!-- Sections Navigation - Mobile: Top, Desktop: Left -->
                <div class="w-full md:w-72 bg-gray-50 border-b md:border-b-0 md:border-r border-gray-200 max-h-48 md:max-h-none overflow-y-auto">
                    <div class="p-4 border-b border-gray-200 bg-gray-50">
                        <h3 class="text-lg font-semibold text-gray-900">Chapter Sections</h3>
                        <p class="text-sm text-gray-600">${sections?.size() ?: 0} sections</p>
                    </div>

                    <div class="p-2">
                        <g:if test="${sections}">
                            <!-- Mobile: Horizontal scroll, Desktop: Vertical -->
                            <div class="md:hidden">
                                <div class="flex space-x-2 overflow-x-auto pb-2">
                                    <g:each in="${sections}" var="section" status="i">
                                        <button onclick="showSectionDetails('${section.id}', '${section.sectionNumber}', '${section.content?.encodeAsJavaScript()}', ${section.isFinalSection ?: false})"
                                                class="section-nav-item flex-shrink-0 flex items-center p-2 text-left rounded-lg hover:bg-blue-50 transition-colors ${section.id == currentSection?.id ? 'bg-blue-50 border-2 border-blue-500 section-active' : 'border-2 border-transparent'} min-w-[120px]"
                                                data-section-id="${section.id}">
                                            <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xs mr-2">
                                                ${section?.sectionNumber}
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <div class="font-medium text-gray-900 text-sm whitespace-nowrap">Section ${section?.sectionNumber}</div>
                                            </div>
                                        </button>
                                    </g:each>
                                </div>
                            </div>
                            <!-- Desktop: Vertical list -->
                            <ul class="space-y-1 hidden md:block">
                                <g:each in="${sections}" var="section" status="i">
                                    <li>
                                        <button onclick="showSectionDetails('${section.id}', '${section.sectionNumber}', '${section.content?.encodeAsJavaScript()}', ${section.isFinalSection ?: false})"
                                                class="section-nav-item w-full flex items-center p-2 text-left rounded-lg hover:bg-blue-50 transition-colors ${section.id == currentSection?.id ? 'bg-blue-50 border-l-4 border-blue-500 section-active' : 'border-l-4 border-transparent'}"
                                                data-section-id="${section.id}">
                                            <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xs mr-3">
                                                ${section?.sectionNumber}
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <div class="font-medium text-gray-900 text-sm">Section ${section?.sectionNumber}</div>
                                                <div class="text-xs text-gray-500 truncate">${section?.content}</div>
                                            </div>
                                            <!-- Progress indicator -->
                                            <div class="w-3 h-3 bg-gray-300 rounded-full flex items-center justify-center ml-2">
                                                <span class="text-gray-600 text-xs">•</span>
                                            </div>
                                        </button>
                                    </li>
                                </g:each>
                            </ul>
                        </g:if>
                        <g:else>
                            <div class="text-center py-8 text-gray-500">
                                <p>No sections found</p>
                            </div>
                        </g:else>
                    </div>
                </div>

                <div class="flex-1 min-h-[60vh] md:min-h-0 overflow-y-auto">
                    <!-- Section Completion Form -->
                    <form <g:if test="${sectionCompletion?.id}">hx-put="/api/universal/SectionVerseCompletion/${sectionCompletion.id}?domainName=SectionVerseCompletion&viewType=sections&refreshStudentId=${selectedStudent?.id}&chapterId=${chapter?.id}&sectionId=${sections[0]?.id}"</g:if><g:else>hx-post="/api/universal/SectionVerseCompletion?domainName=SectionVerseCompletion&viewType=sections&refreshStudentId=${selectedStudent?.id}&chapterId=${chapter?.id}&sectionId=${sections[0]?.id}"</g:else>
                          hx-target="#main-content-area"
                          hx-swap="innerHTML"
                          hx-indicator="#save-indicator">
                        <!-- Save Button - Top positioned -->
                        <div class="flex justify-end p-4 border-b border-gray-100">
                            <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-lg transition-colors flex items-center space-x-2 shadow-sm">
                                <span id="save-indicator" class="htmx-indicator">
                                    <svg class="animate-spin w-4 h-4 mr-1 inline" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 818-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 714 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                </span>
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                </svg>
                                <span>Save Progress</span>
                            </button>
                        </div>

                        <!-- Hidden relationship fields -->
                        <input type="hidden" name="student.id" value="${selectedStudent?.id}">
                        <input type="hidden" name="chapterSection.id" value="${currentSection?.id ?: sections[0]?.id}" id="current-section-id">

                        <!-- Completion checkboxes with proper initial values from backend -->
                        <input type="hidden" name="studentCompleted" value="${sectionCompletion?.studentCompleted ?: false}" id="student-completed-field">
                        <input type="hidden" name="parentCompleted" value="${sectionCompletion?.parentCompleted ?: false}" id="parent-completed-field">
                        <input type="hidden" name="reviewCompleted" value="${sectionCompletion?.reviewCompleted ?: false}" id="review-completed-field">
                        <input type="hidden" name="silverSectionCompleted" value="${sectionCompletion?.silverSectionCompleted ?: false}" id="silver-completed-field">
                        <input type="hidden" name="goldSectionCompleted" value="${sectionCompletion?.goldSectionCompleted ?: false}" id="gold-completed-field">
                        <input type="hidden" name="chapterReview" value="${sectionCompletion?.chapterReview ?: false}" id="chapter-review-field">

                        <div id="section-details" class="p-4">
                            <g:if test="${sections}">
                                <!-- Use current section or default to first section -->
                                <g:set var="displaySection" value="${currentSection ?: sections[0]}" />
                                <div class="bg-white rounded-xl shadow-lg p-4">

                                    <!-- Section Header -->
                                    <div class="mb-8">
                                        <div class="flex items-center mb-3">
                                            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-lg mr-3">
                                                <span id="current-section-number">${displaySection?.sectionNumber}</span>
                                            </div>
                                            <div>
                                                <h2 id="current-section-title" class="text-2xl font-bold text-gray-900">Section ${displaySection?.sectionNumber}</h2>
                                                <p id="current-section-content" class="text-gray-600">${displaySection?.content}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Completion Buttons with Cute Labels - Mobile Optimized -->
                                    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3 sm:gap-4 mb-6">

                                        <!-- Student Memory Verse -->
                                        <div class="relative">
                                            <div class="absolute -top-8 left-2 px-2 py-1 bg-green-500 text-white text-xs font-bold rounded-se z-10">
                                                Memory
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('student', this)"
                                                    data-completion-type="student"
                                                    data-completed="${sectionCompletion?.studentCompleted ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.studentCompleted ? 'bg-green-500 text-white border-green-500 shadow-lg' : 'bg-green-100 hover:bg-green-200 text-green-800 border-green-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                                    </svg>
                                                    <div class="text-lg font-bold">+1</div>
                                                    <div class="text-xs">buck</div>
                                                </div>
                                            </button>
                                        </div>

                                        <!-- Parent Verse -->
                                        <div class="relative">
                                            <div class="absolute -top-8 left-2 px-2 py-1 bg-purple-500 text-white text-xs font-bold rounded-se z-10">
                                                Parent
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('parent', this)"
                                                    data-completion-type="parent"
                                                    data-completed="${sectionCompletion?.parentCompleted ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.parentCompleted ? 'bg-purple-500 text-white border-purple-500 shadow-lg' : 'bg-purple-100 hover:bg-purple-200 text-purple-800 border-purple-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                                                    </svg>
                                                    <div class="text-lg font-bold">+2</div>
                                                    <div class="text-xs">bucks</div>
                                                </div>
                                            </button>
                                        </div>

                                        <!-- Review Verse -->
                                        <div class="relative">
                                            <div class="absolute -top-8 left-2 px-2 py-1 bg-blue-500 text-white text-xs font-bold rounded-se z-10">
                                                Review
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('review', this)"
                                                    data-completion-type="review"
                                                    data-completed="${sectionCompletion?.reviewCompleted ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.reviewCompleted ? 'bg-blue-500 text-white border-blue-500 shadow-lg' : 'bg-blue-100 hover:bg-blue-200 text-blue-800 border-blue-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                                                    </svg>
                                                    <div class="text-lg font-bold">+1</div>
                                                    <div class="text-xs">buck</div>
                                                </div>
                                            </button>
                                        </div>

                                        <!-- Silver Section -->
                                        <div class="relative">
                                            <div class="absolute -top-8 left-2 px-2 py-1 bg-gray-500 text-white text-xs font-bold rounded-se z-10">
                                                Silver
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('silver', this)"
                                                    data-completion-type="silver"
                                                    data-completed="${sectionCompletion?.silverSectionCompleted ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.silverSectionCompleted ? 'bg-gray-500 text-white border-gray-500 shadow-lg' : 'bg-gray-100 hover:bg-gray-200 text-gray-800 border-gray-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                    </svg>
                                                    <div class="text-lg font-bold">+1</div>
                                                    <div class="text-xs">buck</div>
                                                </div>
                                            </button>
                                        </div>

                                        <!-- Gold Section -->
                                        <div class="relative">
                                            <div class="absolute -top-8 left-2 px-2 py-1 bg-yellow-600 text-white text-xs font-bold rounded-se z-10">
                                                🏆 Gold
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('gold', this)"
                                                    data-completion-type="gold"
                                                    data-completed="${sectionCompletion?.goldSectionCompleted ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.goldSectionCompleted ? 'bg-yellow-500 text-white border-yellow-500 shadow-lg' : 'bg-yellow-100 hover:bg-yellow-200 text-yellow-800 border-yellow-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                                                    </svg>
                                                    <div class="text-lg font-bold">+3</div>
                                                    <div class="text-xs">bucks</div>
                                                </div>
                                            </button>
                                        </div>

                                    </div>

                                    <!-- Chapter Review (only for final section) -->
                                    <div id="chapter-review-container" class="${displaySection?.isFinalSection ? '' : 'hidden'}">
                                        <div class="relative mb-6">
                                            <div class="absolute -top-4 left-1/2 transform -translate-x-1/2 px-3 py-1 bg-red-500 text-white text-sm font-bold rounded-full z-10">
                                                🎯 Chapter Review
                                            </div>
                                            <button type="button"
                                                    onclick="toggleCompletion('chapter', this)"
                                                    data-completion-type="chapter"
                                                    data-completed="${sectionCompletion?.chapterReview ?: false}"
                                                    class="completion-btn w-full ${sectionCompletion?.chapterReview ? 'bg-red-500 text-white border-red-500 shadow-lg' : 'bg-red-100 hover:bg-red-200 text-red-800 border-red-300'} border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]">
                                                <div class="text-center">
                                                    <svg class="w-10 h-10 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.09-5.09A1.5 1.5 0 0118 4.5v15A1.5 1.5 0 0116.5 21h-15A1.5 1.5 0 010 19.5v-15A1.5 1.5 0 011.5 3h15a1.5 1.5 0 011.5 1.5z"/>
                                                    </svg>
                                                    <div class="text-2xl font-bold">+5</div>
                                                    <div class="text-sm">bucks</div>
                                                </div>
                                            </button>
                                        </div>
                                    </div>


                                    <!-- Bible Verse Section (placeholder for future) -->
                                    <div class="p-4 bg-blue-50 border border-blue-200 rounded-xl mb-4">
                                        <h3 class="font-bold text-blue-900 mb-2 flex items-center">
                                            <span class="mr-2">📖</span> Memory Verse
                                        </h3>
                                        <p class="text-blue-800 italic">Bible verse content will be displayed here in a future update.</p>
                                        <p class="text-blue-700 text-xs mt-1">This section will show the specific verse(s) that need to be memorized.</p>
                                    </div>


                                </div>
                            </g:if>
                            <g:else>
                                <div class="bg-white rounded-xl shadow-lg p-8 text-center max-w-2xl">
                                    <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                        <svg class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                                        </svg>
                                    </div>
                                    <h3 class="text-xl font-medium text-gray-900 mb-3">No sections found</h3>
                                    <p class="text-gray-600">This chapter doesn't have any sections yet.</p>
                                </div>
                            </g:else>
                        </div>
                    </form>
                </div>

            </div>

        </div>
    </div>
</div>


<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>

<script>
    // Initialize button states on page load
    document.addEventListener('DOMContentLoaded', function() {
        initializeButtonStates();
    });

    // Also initialize after HTMX swaps
    document.body.addEventListener('htmx:afterSwap', function(evt) {
        initializeButtonStates();
    });

    function initializeButtonStates() {
        // Initialize all completion buttons based on their data-completed attribute
        document.querySelectorAll('.completion-btn').forEach(button => {
            const isCompleted = button.getAttribute('data-completed') === 'true';
            const type = button.getAttribute('data-completion-type');

            if (isCompleted) {
                applyCompletedStyle(button, type);
            } else {
                applyUncompletedStyle(button, type);
            }
        });
    }

    // Toggle completion state
    function toggleCompletion(type, buttonElement) {
        const currentState = buttonElement.getAttribute('data-completed') === 'true';
        const newState = !currentState;

        // Update the data attribute
        buttonElement.setAttribute('data-completed', newState);

        // Update visual state
        if (newState) {
            applyCompletedStyle(buttonElement, type);
        } else {
            applyUncompletedStyle(buttonElement, type);
        }

        // Update hidden form field
        updateFormField(type, newState);
    }

    function applyCompletedStyle(button, type) {
        // Remove all base classes first
        button.className = button.className.replace(/bg-\w+-\d+|hover:bg-\w+-\d+|text-\w+-\d+|border-\w+-\d+/g, '');

        // Apply completed styling based on type
        const baseClasses = 'completion-btn w-full border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px] shadow-lg';

        switch(type) {
            case 'student':
                button.className = baseClasses + ' bg-green-500 text-white border-green-500';
                break;
            case 'parent':
                button.className = baseClasses + ' bg-purple-500 text-white border-purple-500';
                break;
            case 'review':
                button.className = baseClasses + ' bg-blue-500 text-white border-blue-500';
                break;
            case 'silver':
                button.className = baseClasses + ' bg-gray-500 text-white border-gray-500';
                break;
            case 'gold':
                button.className = baseClasses + ' bg-yellow-500 text-white border-yellow-500';
                break;
            case 'chapter':
                button.className = baseClasses + ' bg-red-500 text-white border-red-500';
                break;
        }
    }

    function applyUncompletedStyle(button, type) {
        // Remove all base classes first
        button.className = button.className.replace(/bg-\w+-\d+|hover:bg-\w+-\d+|text-\w+-\d+|border-\w+-\d+|shadow-lg/g, '');

        // Apply uncompleted styling based on type
        const baseClasses = 'completion-btn w-full border-2 rounded-xl p-4 pt-6 font-bold transition-all duration-200 touch-manipulation min-h-[80px] sm:min-h-[100px]';

        switch(type) {
            case 'student':
                button.className = baseClasses + ' bg-green-100 hover:bg-green-200 text-green-800 border-green-300';
                break;
            case 'parent':
                button.className = baseClasses + ' bg-purple-100 hover:bg-purple-200 text-purple-800 border-purple-300';
                break;
            case 'review':
                button.className = baseClasses + ' bg-blue-100 hover:bg-blue-200 text-blue-800 border-blue-300';
                break;
            case 'silver':
                button.className = baseClasses + ' bg-gray-100 hover:bg-gray-200 text-gray-800 border-gray-300';
                break;
            case 'gold':
                button.className = baseClasses + ' bg-yellow-100 hover:bg-yellow-200 text-yellow-800 border-yellow-300';
                break;
            case 'chapter':
                button.className = baseClasses + ' bg-red-100 hover:bg-red-200 text-red-800 border-red-300';
                break;
        }
    }

    // Update hidden form fields
    function updateFormField(type, completed) {
        const fieldMap = {
            'student': 'student-completed-field',
            'parent': 'parent-completed-field',
            'review': 'review-completed-field',
            'silver': 'silver-completed-field',
            'gold': 'gold-completed-field',
            'chapter': 'chapter-review-field'
        };

        const field = document.getElementById(fieldMap[type]);
        if (field) {
            field.value = completed;
        }
    }

    // Section navigation functionality
    function showSectionDetails(sectionId, sectionNumber, content, isFinalSection) {
        // Make HTMX call to reload the sections template with the specific sectionId
        var url = '/renderView?viewType=sections&chapterId=${chapter?.id}&studentId=${selectedStudent?.id}&sectionId=' + sectionId;
        htmx.ajax('GET', url, {
            target: '#main-content-area',
            swap: 'innerHTML'
        });
    }
</script>