<g:each in="${sections}" var="section">
    <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 cursor-pointer section-card" 
         data-section-id="${section.id}"
         onclick="selectSection(${section.id})">
        <div class="flex items-center justify-between">
            <div class="flex-1">
                <h4 class="font-semibold text-gray-900">Section ${section.sectionNumber}</h4>
                <p class="text-sm text-gray-600 mt-1">${section.content}</p>
                
                <!-- Section badges -->
                <div class="mt-2 flex space-x-2">
                    <g:if test="${section.isSilverSection}">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                            <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4"/>
                            </svg>
                            Silver Section
                        </span>
                    </g:if>
                    <g:if test="${section.isGoldSection}">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                            <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                            </svg>
                            Gold Section
                        </span>
                    </g:if>
                </div>
            </div>
            <div class="text-sm text-gray-500">
                Click to select
            </div>
        </div>
    </div>
</g:each>

<g:if test="${!sections || sections.isEmpty()}">
    <div class="text-center py-8 text-gray-500">
        <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
        </svg>
        <p>No sections found for this chapter.</p>
        <p class="text-sm mt-1">Please select a different chapter.</p>
    </div>
</g:if>