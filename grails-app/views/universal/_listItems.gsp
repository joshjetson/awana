<%--
Universal List Items Template
Used by the Universal Controller for simple listings
--%>

<div class="space-y-3">
    <g:each in="${instances}" var="instance">
        <div class="bg-white border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors">
            <div class="flex items-center justify-between">
                <div class="flex-1">
                    <div class="font-medium text-gray-900">${instance.toString()}</div>
                    <div class="text-sm text-gray-500">ID: ${instance.id}</div>
                </div>
                <div class="flex space-x-2">
                    <button class="text-blue-600 hover:text-blue-900 text-sm">View</button>
                    <button class="text-gray-600 hover:text-gray-900 text-sm">Edit</button>
                </div>
            </div>
        </div>
    </g:each>
</div>

<g:if test="${!instances || instances.size() == 0}">
    <div class="text-center py-8 text-gray-500">
        <p class="text-lg font-medium">No items found</p>
        <p class="text-sm mt-1">There are no ${domainName} records to display.</p>
    </div>
</g:if>