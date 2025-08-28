<!-- Club Edit Form -->
<div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
    <h2 class="text-lg font-semibold text-gray-900 mb-4">Edit Club</h2>
    
    <form hx-post="/save?domainName=Club&id=${club?.id}" 
          hx-target="#clubs-page-content" 
          hx-swap="innerHTML">
        
        <div class="space-y-4">
            <!-- Club Name -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Club Name</label>
                <input type="text" 
                       name="name" 
                       value="${club?.name}" 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                       required>
            </div>
            
            <!-- Age Range -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Age Range</label>
                <input type="text" 
                       name="ageRange" 
                       value="${club?.ageRange}"
                       placeholder="e.g. Ages 4-5, K-2nd Grade"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                       required>
            </div>
            
            <!-- Description -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea name="description" 
                          rows="3"
                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 resize-none">${club?.description}</textarea>
            </div>
        </div>
        
        <!-- Form Actions -->
        <div class="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-200">
            <button type="button" 
                    hx-get="/renderView?viewType=clubs" 
                    hx-target="#clubs-page-content" 
                    hx-swap="innerHTML"
                    class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                Cancel
            </button>
            <button type="submit" 
                    class="px-4 py-2 text-sm font-medium text-white bg-purple-600 border border-transparent rounded-md hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                Update Club
            </button>
        </div>
    </form>
</div>