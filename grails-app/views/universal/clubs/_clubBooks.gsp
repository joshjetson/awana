<%-- 
Club Books Management Template
Loaded via: /renderView?viewType=clubBooks&clubId=123
--%>

<div class="bg-white rounded-xl shadow-lg p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h2 class="text-xl font-bold text-gray-900">Manage Books</h2>
            <p class="text-sm text-gray-600">${club?.name} - ${club?.ageRange}</p>
        </div>
        <button onclick="this.closest('#dynamic-content').style.display = 'none'" 
                class="text-gray-400 hover:text-gray-600 p-2">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>
    </div>

    <div class="grid md:grid-cols-2 gap-6">
        <!-- Current Books -->
        <div>
            <h3 class="font-semibold text-gray-900 mb-4">Assigned Books (${club?.books?.size() ?: 0})</h3>
            <div class="space-y-2 max-h-64 overflow-y-auto">
                <g:if test="${club?.books}">
                    <g:each in="${club.books}" var="book">
                        <div class="flex items-center justify-between p-3 bg-green-50 border border-green-200 rounded-lg">
                            <div>
                                <div class="font-medium text-gray-900">${book.name}</div>
                                <div class="text-sm text-gray-600">${book.chapters?.size() ?: 0} chapters</div>
                            </div>
                            <button hx-put="/api/universal/Book/${book.id}?domainName=Book&viewType=clubBooks&refreshClubId=${club.id}&club.id="
                                    hx-target="#dynamic-content"
                                    hx-swap="innerHTML"
                                    class="text-red-600 hover:text-red-700 text-sm">
                                Remove
                            </button>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="text-center py-8 text-gray-500">
                        No books assigned to this club yet
                    </div>
                </g:else>
            </div>
        </div>

        <!-- Available Books -->
        <div>
            <h3 class="font-semibold text-gray-900 mb-4">Available Books</h3>
            <div class="space-y-2 max-h-64 overflow-y-auto">
                <g:each in="${allBooks?.findAll { !club?.books?.contains(it) }}" var="book">
                    <div class="flex items-center justify-between p-3 bg-gray-50 border border-gray-200 rounded-lg">
                        <div>
                            <div class="font-medium text-gray-900">${book.name}</div>
                            <div class="text-sm text-gray-600">
                                ${book.chapters?.size() ?: 0} chapters
                            </div>
                        </div>
                        <button type="button"
                                hx-put="/api/universal/Book/${book.id}?domainName=Book&viewType=clubBooks&refreshClubId=${club.id}&club.id=${club.id}"
                                hx-target="#dynamic-content"
                                hx-swap="innerHTML"
                                class="text-blue-600 hover:text-blue-700 text-sm">
                            Add
                        </button>
                    </div>
                </g:each>
            </div>
        </div>
    </div>

    <!-- Create New Book -->
    <div class="mt-6 pt-6 border-t border-gray-200">
        <h3 class="font-semibold text-gray-900 mb-4">Create New Book</h3>
        <form hx-post="/api/universal/Book?domainName=Book&viewType=clubBooks&clubId=${club.id}"
              hx-target="#dynamic-content"
              hx-swap="innerHTML"
              class="flex space-x-3">
            <input type="hidden" name="club.id" value="${club.id}">
            <input type="text" name="name" placeholder="Book name (e.g., HangGlider, WingRunner)" 
                   class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
            <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg">
                Create Book
            </button>
        </form>
    </div>
</div>