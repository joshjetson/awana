<%-- 
Alert Message Component (success, error, warning, info)
Usage: <g:render template="/components/alertMessage" model="[type: 'success', title: 'Success!', message: 'Family checked in successfully', dismissible: true]"

Parameters:
- type: success, error, warning, info (default: info)
- title: Alert title (optional)
- message: Alert message (required)
- dismissible: Boolean - show close button (default: false)
- icon: Custom SVG icon (optional)
--%>

<g:set var="alertStyles" value="${[
    'success': [
        bg: 'bg-green-50 border-green-200', 
        text: 'text-green-800', 
        icon: '''<svg class=\"w-5 h-5\" fill=\"currentColor\" viewBox=\"0 0 20 20\"><path fill-rule=\"evenodd\" d=\"M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z\" clip-rule=\"evenodd\"/></svg>'''
    ],
    'error': [
        bg: 'bg-red-50 border-red-200', 
        text: 'text-red-800', 
        icon: '''<svg class=\"w-5 h-5\" fill=\"currentColor\" viewBox=\"0 0 20 20\"><path fill-rule=\"evenodd\" d=\"M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z\" clip-rule=\"evenodd\"/></svg>'''
    ],
    'warning': [
        bg: 'bg-yellow-50 border-yellow-200', 
        text: 'text-yellow-800', 
        icon: '''<svg class=\"w-5 h-5\" fill=\"currentColor\" viewBox=\"0 0 20 20\"><path fill-rule=\"evenodd\" d=\"M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z\" clip-rule=\"evenodd\"/></svg>'''
    ],
    'info': [
        bg: 'bg-blue-50 border-blue-200', 
        text: 'text-blue-800', 
        icon: '''<svg class=\"w-5 h-5\" fill=\"currentColor\" viewBox=\"0 0 20 20\"><path fill-rule=\"evenodd\" d=\"M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z\" clip-rule=\"evenodd\"/></svg>'''
    ]
]}"/>

<g:set var="currentType" value="${type ?: 'info'}"/>
<g:set var="currentStyle" value="${alertStyles[currentType]}"/>

<div class="alert-message border rounded-xl p-4 ${currentStyle.bg} ${currentStyle.text} animate-fade-in" role="alert">
    <div class="flex items-start">
        <div class="flex-shrink-0">
            <g:if test="${icon}">
                ${raw(icon)}
            </g:if>
            <g:else>
                ${raw(currentStyle.icon)}
            </g:else>
        </div>
        
        <div class="ml-3 flex-1">
            <g:if test="${title}">
                <h3 class="font-bold text-sm mb-1">${title}</h3>
            </g:if>
            
            <div class="text-sm">
                ${message}
            </div>
        </div>
        
        <g:if test="${dismissible}">
            <div class="ml-4 flex-shrink-0">
                <button type="button" 
                        class="${currentStyle.text} hover:opacity-75 focus:outline-none focus:opacity-75 transition-opacity"
                        onclick="this.parentElement.parentElement.parentElement.style.display='none'">
                    <span class="sr-only">Close</span>
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                    </svg>
                </button>
            </div>
        </g:if>
    </div>
</div>