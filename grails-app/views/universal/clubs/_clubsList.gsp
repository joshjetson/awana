<%-- 
Individual Club Card Template for HTMX rendering
Usage: Used when adding new clubs via HTMX or rendering individual club cards
--%>

<div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow">
    <div class="flex items-center justify-between mb-4">
        <div class="flex items-center space-x-4">
            <div class="w-12 h-12 bg-gradient-to-br from-purple-500 to-blue-500 rounded-lg flex items-center justify-center text-white font-bold text-lg">
                ${club.name?.substring(0, 1)}
            </div>
            <div>
                <h3 class="text-lg font-bold text-gray-900">${club.name}</h3>
                <p class="text-sm text-gray-600">${club.ageRange}</p>
                <g:if test="${club.description}">
                    <p class="text-xs text-gray-500 mt-1">${club.description}</p>
                </g:if>
            </div>
        </div>
        
        <div class="flex space-x-2">
            <button hx-get="/renderView?viewType=clubEdit&clubId=${club.id}" 
                    hx-target="#dynamic-content" 
                    hx-swap="innerHTML"
                    class="bg-blue-100 hover:bg-blue-200 text-blue-700 px-3 py-2 rounded-lg text-sm transition-colors">
                Edit
            </button>
            <button hx-delete="/delete?domainName=Club&id=${club.id}" 
                    hx-target="closest div"
                    hx-swap="delete"
                    hx-confirm="Are you sure you want to delete ${club.name?.encodeAsJavaScript()}?"
                    class="bg-red-100 hover:bg-red-200 text-red-700 px-3 py-2 rounded-lg text-sm transition-colors">
                Delete
            </button>
        </div>
    </div>
    
    <div class="grid grid-cols-3 gap-4 text-sm mb-4">
        <div>
            <div class="text-2xl font-bold text-gray-900">${club.students?.size() ?: 0}</div>
            <div class="text-gray-600">Students</div>
        </div>
        <div>
            <div class="text-2xl font-bold text-green-600">${club.books?.size() ?: 0}</div>
            <div class="text-gray-600">Books</div>
        </div>
        <div>
            <div class="text-2xl font-bold text-purple-600">
                ${club.students?.sum { student -> student.awanaBucks } ?: 0}
            </div>
            <div class="text-gray-600">Total Bucks</div>
        </div>
    </div>

    <div class="flex space-x-3">
        <button hx-get="/renderView?viewType=clubStudents&clubId=${club.id}" 
                hx-target="#dynamic-content" 
                hx-swap="innerHTML"
                class="flex-1 bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded-lg text-center transition-colors">
            <div class="font-medium text-gray-900">Manage Students</div>
            <div class="text-xs text-gray-600">Add/Remove students</div>
        </button>
        <button hx-get="/renderView?viewType=clubBooks&clubId=${club.id}" 
                hx-target="#dynamic-content" 
                hx-swap="innerHTML"
                class="flex-1 bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded-lg text-center transition-colors">
            <div class="font-medium text-gray-900">Manage Books</div>
            <div class="text-xs text-gray-600">Assign handbooks</div>
        </button>
    </div>
</div>