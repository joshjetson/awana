<%-- 
Club Creation Form Template
Usage: Loaded via HTMX when user clicks "Add Club" button
--%>

<div class="bg-blue-50 border border-blue-200 rounded-lg p-6 mt-4">
    <h3 class="text-lg font-semibold text-blue-900 mb-4">Create New Club</h3>
    
    <form hx-post="/api/universal/Club?domainName=Club&viewType=clubs" 
          hx-target="#clubs-page-content"
          hx-swap="innerHTML"
          class="space-y-4">
        
        <div class="grid md:grid-cols-2 gap-4">
            <!-- Club Name -->
            <div class="space-y-2">
                <label for="name" class="block text-sm font-medium text-gray-700">
                    Club Name <span class="text-red-500">*</span>
                </label>
                <input type="text" 
                       name="name" 
                       id="name"
                       placeholder="e.g., Cubbies, Sparks, T&T"
                       required
                       class="block w-full pl-4 pr-4 py-4 text-lg
                              border-2 border-gray-300 focus:border-blue-500 focus:ring-blue-200
                              rounded-xl focus:outline-none focus:ring-4 transition-colors
                              placeholder-gray-400 min-h-[56px] bg-white">
            </div>
            
            <!-- Age Range Select -->
            <div class="space-y-2">
                <label for="ageRange" class="block text-sm font-medium text-gray-700">
                    Age Range <span class="text-red-500">*</span>
                </label>
                <select name="ageRange" id="ageRange" required 
                        class="block w-full pl-4 pr-4 py-4 text-lg
                               border-2 border-gray-300 focus:border-blue-500 focus:ring-blue-200
                               rounded-xl focus:outline-none focus:ring-4 transition-colors
                               bg-white min-h-[56px]">
                    <option value="">Select age range...</option>
                    <option value="Ages 2-3">Puggles (Ages 2-3)</option>
                    <option value="Ages 4-5">Cubbies (Ages 4-5)</option>
                    <option value="K-2nd Grade">Sparks (K-2nd Grade)</option>
                    <option value="Grades 3-6">Truth & Training (Grades 3-6)</option>
                    <option value="Grades 6-8">Trek (Grades 6-8)</option>
                    <option value="Grades 9-12">Journey (Grades 9-12)</option>
                </select>
            </div>
        </div>
        
        <!-- Description -->
        <div class="space-y-2">
            <label for="description" class="block text-sm font-medium text-gray-700">
                Description (Optional)
            </label>
            <textarea name="description" id="description" rows="3"
                      placeholder="Brief description of the club..."
                      class="block w-full pl-4 pr-4 py-4 text-lg
                             border-2 border-gray-300 focus:border-blue-500 focus:ring-blue-200
                             rounded-xl focus:outline-none focus:ring-4 transition-colors
                             placeholder-gray-400 bg-white resize-none"></textarea>
        </div>
        
        <!-- Action Buttons -->
        <div class="flex space-x-3 pt-2">
            <button type="submit" 
                    class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors
                           flex items-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                <span>Create Club</span>
            </button>
            <button type="button" 
                    onclick="this.closest('.bg-blue-50').remove()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors">
                Cancel
            </button>
        </div>
    </form>
</div>