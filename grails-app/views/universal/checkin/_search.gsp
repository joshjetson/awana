<%--
Generic Search Results Template
Displays household search results for family check-in
Loaded via: /renderView?viewType=search
--%>

<g:if test="${households}">
    <g:each in="${households}" var="household">
        <button onclick="loadFamily('${household.qrCode}')"
                class="w-full text-left bg-gray-50 hover:bg-blue-50 active:bg-blue-100
                       border border-gray-200 rounded-lg p-4 transition-colors
                       min-h-[60px] touch-manipulation">
            <div class="flex items-center justify-between">
                <div class="flex-1">
                    <div class="flex items-center space-x-3">
                        <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500
                                    rounded-full flex items-center justify-center text-white font-bold text-sm">
                            ${household.name.substring(0, 2).toUpperCase()}
                        </div>
                        <div>
                            <div class="font-semibold text-gray-900">${household.name}</div>
                            <div class="text-sm text-gray-600">
                                ${household.students?.size() ?: 0} children • ${household.qrCode}
                                <g:if test="${searchTerm}">
                                    <g:set var="matchingStudents" value="${household.students?.findAll { student ->
                                        student.firstName.toLowerCase().contains(searchTerm.toLowerCase()) ||
                                        student.lastName.toLowerCase().contains(searchTerm.toLowerCase())
                                    }}" />
                                    <g:if test="${matchingStudents}">
                                        <br><span class="text-blue-600 font-medium">
                                            Matches: <g:join in="${matchingStudents*.getFullName()}" delimiter=", " />
                                        </span>
                                    </g:if>
                                </g:if>
                            </div>
                        </div>
                    </div>
                </div>
                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
            </div>
        </button>
    </g:each>
</g:if>
<g:else>
    <div class="text-center py-8 text-gray-500">
        <svg class="w-12 h-12 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
        <g:if test="${searchTerm}">
            <p class="text-lg font-medium">No families found</p>
            <p class="text-sm">Try searching for a different name</p>
        </g:if>
        <g:else>
            <p class="text-lg font-medium">No families available</p>
            <p class="text-sm">Start typing to search for families</p>
        </g:else>
    </div>
</g:else>