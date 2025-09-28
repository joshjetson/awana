<%-- 
Create Book Form Template
Loaded via: /renderView?viewType=createBook&clubId=123
--%>

<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">${editMode ? 'Edit Book' : 'Create New Book'} - ${club?.name}</h1>
            <div class="text-purple-100">
                ${club?.ageRange} • ${editMode ? 'Update your Awana handbook settings' : 'Design your Awana handbook with chapters and sections'}
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Back Button -->
        <div class="bg-white rounded-xl shadow-lg p-4">
            <button hx-get="/renderView?viewType=clubBooks&clubId=${club?.id}"
                    hx-target="#clubs-page-content"
                    hx-swap="innerHTML"
                    class="flex items-center space-x-2 text-purple-600 hover:text-purple-800 font-medium">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
                <span>Back to Book Management</span>
            </button>
        </div>

        <!-- Book ${editMode ? 'Edit' : 'Creation'} Form -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6">Book Information</h2>
            
            <form id="${editMode ? 'edit' : 'create'}-book-form" 
                  <g:if test="${editMode}">hx-put="/api/universal/Book/${book?.id}?domainName=Book&viewType=clubBooks&refreshClubId=${club?.id?.toString()?.split(':')[0]}"</g:if>
                  <g:else>hx-post="/api/universal/Book?domainName=Book&viewType=clubBooks&refreshClubId=${club?.id?.toString()?.split(':')[0]}"</g:else>
                  hx-target="#clubs-page-content"
                  hx-swap="innerHTML">
                
                <!-- Hidden club ID for Book-Club relationship -->
                <input type="hidden" name="club.id" value="${club?.id}">
                
                <!-- Book Basic Info -->
                <div class="grid md:grid-cols-2 gap-6 mb-8">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Book Name *</label>
                        <input type="text" 
                               name="name" 
                               value="${book?.name ?: ''}"
                               placeholder="e.g., HangGlider, Bear Hug, Ultimate Adventure"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-lg"
                               required>
                        <p class="text-sm text-gray-600 mt-1">Choose a memorable name for your Awana handbook</p>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Book Type</label>
                        <div class="space-y-3">
                            <label class="flex items-center">
                                <input type="radio" name="isPrimary" value="true" ${book?.isPrimary ? 'checked' : ''}
                                        class="text-purple-600 focus:ring-purple-500 border-gray-300 rounded-2xl" style="border-radius : 100px 100px; width : 40px">
                                <span class="ml-3">
                                    <span class="font-medium text-gray-900">Primary Book</span>
                                    <span class="block text-sm text-gray-600">Main handbook for this club</span>
                                </span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="isPrimary" value="false" ${book?.isPrimary == false || !book ? 'checked' : ''}
                                       class="text-purple-600 focus:ring-purple-500 border-gray-300 rounded-2xl" style="border-radius : 100px 100px; width : 40px"">
                                <span class="ml-3">
                                    <span class="font-medium text-gray-900">Secondary Book</span>
                                    <span class="block text-sm text-gray-600">Additional or advanced handbook</span>
                                </span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Chapters Section -->
                <div class="mb-8">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-bold text-gray-900">Chapters</h3>
                        <button type="button" 
                                onclick="addChapter()"
                                class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg flex items-center space-x-2 transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            <span>Add Chapter</span>
                        </button>
                    </div>
                    
                    <div id="chapters-container" class="space-y-6">
                        <!-- Render existing chapters in edit mode -->
                        <g:if test="${editMode && book?.chapters}">
                            <g:each in="${book.chapters.sort { it.chapterNumber }}" var="chapter" status="chapterIndex">
                                <div class="border border-gray-200 rounded-lg p-6">
                                    <div class="flex items-center justify-between mb-4">
                                        <h4 class="text-md font-semibold text-gray-900">Chapter ${chapter.chapterNumber}</h4>
                                        <button type="button" onclick="removeChapter(this)" class="text-red-600 hover:text-red-800 text-sm" style="${book.chapters.size() <= 1 ? 'display: none;' : ''}">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                            </svg>
                                        </button>
                                    </div>
                                    
                                    <input type="hidden" name="chapters[${chapterIndex}].chapterNumber" value="${chapter.chapterNumber}">
                                    <g:if test="${chapter.id}"><input type="hidden" name="chapters[${chapterIndex}].id" value="${chapter.id}"></g:if>
                                    
                                    <div class="grid md:grid-cols-2 gap-4 mb-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Chapter Name *</label>
                                            <input type="text" 
                                                   name="chapters[${chapterIndex}].name" 
                                                   value="${chapter.name?.encodeAsHTML()}"
                                                   placeholder="e.g., God, Jesus, Salvation"
                                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                                                   required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="flex items-center justify-between mb-2">
                                            <label class="block text-sm font-medium text-gray-700">Chapter Sections</label>
                                            <button type="button" onclick="addSection(this, ${chapterIndex})" class="text-blue-600 hover:text-blue-800 text-sm flex items-center space-x-1">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                                <span>Add Section</span>
                                            </button>
                                        </div>
                                        <div class="sections-container space-y-2">
                                            <g:each in="${chapter.chapterSections?.sort { it.sectionNumber }}" var="section" status="sectionIndex">
                                                <div class="flex items-center space-x-2">
                                                    <input type="text" 
                                                           name="chapters[${chapterIndex}].chapterSections[${sectionIndex}].sectionNumber" 
                                                           value="${section.sectionNumber?.encodeAsHTML()}"
                                                           class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">
                                                    <input type="text" 
                                                           name="chapters[${chapterIndex}].chapterSections[${sectionIndex}].content" 
                                                           value="${section.content?.encodeAsHTML()}"
                                                           placeholder="Section content"
                                                           class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">
                                                    <g:if test="${section.id}"><input type="hidden" name="chapters[${chapterIndex}].chapterSections[${sectionIndex}].id" value="${section.id}"></g:if>
                                                    <g:if test="${section.id}">
                                                        <button type="button" onclick="deleteSection(this, ${section.id})" class="text-red-600 hover:text-red-800 p-1">
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                                            </svg>
                                                        </button>
                                                    </g:if>
                                                    <g:else>
                                                        <button type="button" onclick="this.parentElement.remove()" class="text-red-600 hover:text-red-800 p-1">
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                                            </svg>
                                                        </button>
                                                    </g:else>
                                                </div>
                                            </g:each>
                                        </div>
                                    </div>
                                </div>
                            </g:each>
                        </g:if>
                        
                        <!-- In create mode, chapters will be added dynamically here -->
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                    <button type="button" 
                            hx-get="/renderView?viewType=clubBooks&clubId=${club?.id}"
                            hx-target="#clubs-page-content"
                            hx-swap="innerHTML"
                            class="px-6 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                        Cancel
                    </button>
                    <button type="submit" 
                            class="px-6 py-3 text-sm font-medium text-white bg-purple-600 border border-transparent rounded-lg hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                        ${editMode ? 'Update Book' : 'Create Book'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    (function() {
        let chapterCount = ${editMode && book?.chapters ? book.chapters.size() : 0};

        window.addChapter = function() {
            chapterCount++;
            const container = document.getElementById('chapters-container');
            const chapterDiv = document.createElement('div');
            chapterDiv.className = 'border border-gray-200 rounded-lg p-6';
            const chapterIndex = chapterCount - 1;  // This will be correct for both create and edit mode
            chapterDiv.innerHTML =
                '<div class="flex items-center justify-between mb-4">' +
                '<h4 class="text-md font-semibold text-gray-900">Chapter ' + chapterCount + '</h4>' +
                '<button type="button" onclick="removeChapter(this)" class="text-red-600 hover:text-red-800 text-sm">' +
                '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">' +
                '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>' +
                '</svg>' +
                '</button>' +
                '</div>' +

                '<input type="hidden" name="chapters[' + chapterIndex + '].chapterNumber" value="' + chapterCount + '">' +

                '<div class="grid md:grid-cols-2 gap-4 mb-4">' +
                '<div>' +
                '<label class="block text-sm font-medium text-gray-700 mb-1">Chapter Name *</label>' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].name" ' +
                'placeholder="e.g., God, Jesus, Salvation"' +
                'class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"' +
                'required>' +
                '</div>' +
                '</div>' +

                '<div class="mb-4">' +
                '<div class="flex items-center justify-between mb-2">' +
                '<label class="block text-sm font-medium text-gray-700">Chapter Sections</label>' +
                '<button type="button" onclick="addSection(this, ' + chapterIndex + ')" class="text-blue-600 hover:text-blue-800 text-sm flex items-center space-x-1">' +
                '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">' +
                '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>' +
                '</svg>' +
                '<span>Add Section</span>' +
                '</button>' +
                '</div>' +
                '<div class="sections-container space-y-2">' +
                '<!-- Default sections -->' +
                '<div class="flex items-center space-x-2">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[0].sectionNumber" ' +
                'value="1"' +
                'class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[0].content" ' +
                'placeholder="Introduction"' +
                'class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">' +
                '</div>' +
                '<div class="flex items-center space-x-2">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[1].sectionNumber" ' +
                'value="2"' +
                'class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[1].content" ' +
                'placeholder="Bible Story"' +
                'class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">' +
                '</div>' +
                '<div class="flex items-center space-x-2">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[2].sectionNumber" ' +
                'value="3"' +
                'class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[2].content" ' +
                'placeholder="Memory Verse"' +
                'class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">' +
                '</div>' +
                '<div class="flex items-center space-x-2">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[3].sectionNumber" ' +
                'value="4"' +
                'class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[3].content" ' +
                'placeholder="Application"' +
                'class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">' +
                '</div>' +
                '</div>' +
                '</div>';
            container.appendChild(chapterDiv);
            updateRemoveButtons();
        };

        window.removeChapter = function(button) {
            const chapterDiv = button.closest('.border');
            chapterDiv.remove();
            updateRemoveButtons();
        };

        window.addSection = function(button, chapterIndex) {
            const sectionsContainer = button.closest('.mb-4').querySelector('.sections-container');
            const sectionCount = sectionsContainer.children.length;

            const sectionDiv = document.createElement('div');
            sectionDiv.className = 'flex items-center space-x-2';
            sectionDiv.innerHTML =
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[' + sectionCount + '].sectionNumber" ' +
                'value="' + (sectionCount + 1) + '"' +
                'class="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm">' +
                '<input type="text" ' +
                'name="chapters[' + chapterIndex + '].chapterSections[' + sectionCount + '].content" ' +
                'placeholder="Section content"' +
                'class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-sm">' +
                '<button type="button" onclick="this.parentElement.remove()" class="text-red-600 hover:text-red-800 p-1">' +
                '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">' +
                '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>' +
                '</svg>' +
                '</button>';
            sectionsContainer.appendChild(sectionDiv);
        };

        window.deleteSection = function(button, sectionId) {
            console.log('deleteSection called with sectionId:', sectionId);

            if (!sectionId) {
                console.error('No sectionId provided');
                return;
            }

            // Remove from DOM immediately
            button.parentElement.remove();

            // Make DELETE request to backend with proper headers
            fetch('/api/universal/ChapterSection/' + sectionId, {
                method: 'DELETE',
                headers: {
                    'Accept': '*/*',
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'HX-Request': 'true',
                    'HX-Current-URL': window.location.href,
                    'Origin': window.location.origin
                }
            }).catch(error => {
                console.error('Error deleting section:', error);
                // Could show a notification here if needed
            });
        };

        function updateRemoveButtons() {
            const chapterForms = document.querySelectorAll('#chapters-container > .border');
            const removeButtons = document.querySelectorAll('#chapters-container > .border button[onclick*="removeChapter"]');

            removeButtons.forEach(button => {
                button.style.display = chapterForms.length > 1 ? 'block' : 'none';
            });
        }

        // Add initial chapter when page loads (only in create mode)
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.getElementById('chapters-container');
            const isEditMode = ${editMode ? 'true' : 'false'};

            if (container && !isEditMode) {
                // Only add empty chapter in create mode
                container.innerHTML = '';
                chapterCount = 0;
                addChapter();
            } else if (isEditMode) {
                // In edit mode, set chapterCount based on existing chapters
                const existingChapters = container.querySelectorAll('.border');
                chapterCount = existingChapters.length;
                updateRemoveButtons(); // Make sure remove buttons are set correctly
            }
        });
    })();
</script>