<%-- 
Touch-Optimized Input Component
Usage: <g:render template="/components/touchInput" model="[name: 'qrcode', placeholder: 'Enter QR Code', type: 'text', label: 'QR Code', icon: iconSvg]"

Parameters:
- name: Input name attribute (required)
- type: Input type (default: text)
- placeholder: Placeholder text (optional)
- label: Label text (optional)  
- value: Default value (optional)
- icon: SVG icon HTML for left side (optional)
- required: Boolean (optional)
- disabled: Boolean (optional)
- error: Error message (optional)
- helpText: Help text below input (optional)
--%>

<div class="space-y-2">
    <g:if test="${label}">
        <label ${name ? "for=\"${name}\"" : ""} class="block text-sm font-medium text-gray-700">
            ${label}
            <g:if test="${required}">
                <span class="text-red-500">*</span>
            </g:if>
        </label>
    </g:if>
    
    <div class="relative">
        <g:if test="${icon}">
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                ${raw(icon)}
            </div>
        </g:if>
        
        <input type="${type ?: 'text'}"
               ${name ? "name=\"${name}\" id=\"${name}\"" : ""}
               ${placeholder ? "placeholder=\"${placeholder}\"" : ""}
               ${value ? "value=\"${value}\"" : ""}
               ${required ? "required" : ""}
               ${disabled ? "disabled" : ""}
               class="block w-full ${icon ? 'pl-12' : 'pl-4'} pr-4 py-4 text-lg
                      border-2 ${error ? 'border-red-300 focus:border-red-500 focus:ring-red-200' : 'border-gray-300 focus:border-blue-500 focus:ring-blue-200'}
                      rounded-xl focus:outline-none focus:ring-4 transition-colors
                      placeholder-gray-400 min-h-[56px]
                      ${disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white'}">
    </div>
    
    <g:if test="${error}">
        <div class="flex items-center text-red-600 text-sm mt-1">
            <svg class="w-4 h-4 mr-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
            </svg>
            ${error}
        </div>
    </g:if>
    
    <g:if test="${helpText && !error}">
        <p class="text-sm text-gray-500">${helpText}</p>
    </g:if>
</div>