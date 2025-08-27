<%--
Universal List Table Template
Used by the Universal Controller for paginated listings
--%>

<div class="bg-white rounded-xl shadow-md overflow-hidden">
    <!-- Header -->
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-lg font-semibold text-gray-900">${domainName} List</h3>
        <p class="text-sm text-gray-600">${result.total} items total</p>
    </div>
    
    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        ID
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Details
                    </th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                <g:each in="${result.results}" var="instance">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            ${instance.id}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            ${instance.toString()}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button class="text-blue-600 hover:text-blue-900 mr-3">
                                View
                            </button>
                            <button class="text-gray-600 hover:text-gray-900">
                                Edit
                            </button>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </div>
    
    <!-- Pagination -->
    <g:if test="${result.totalPages > 1}">
        <div class="px-6 py-3 border-t border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
                <div class="text-sm text-gray-700">
                    Showing page ${result.currentPage} of ${result.totalPages}
                </div>
                <div class="flex space-x-2">
                    <g:if test="${result.currentPage > 1}">
                        <button class="px-3 py-1 text-sm border rounded hover:bg-gray-100">
                            Previous
                        </button>
                    </g:if>
                    <g:if test="${result.currentPage < result.totalPages}">
                        <button class="px-3 py-1 text-sm border rounded hover:bg-gray-100">
                            Next
                        </button>
                    </g:if>
                </div>
            </div>
        </div>
    </g:if>
</div>