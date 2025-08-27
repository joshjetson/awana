<%-- 
Touch-Optimized Toggle Button Component (like attendance toggles)
Usage: <g:render template="/components/touchToggle" model="[id: 'toggle-1', text: 'Present', subtext: '+1 buck', icon: iconSvg, active: false, color: 'green', onclick: 'toggle(1)']"

Parameters:
- id: Unique ID for the toggle (required)
- text: Main text (required)
- subtext: Small text below (optional)
- icon: SVG icon HTML (required)
- active: Boolean state (default: false)
- color: green, blue, purple, orange, yellow, red (default: green)
- onclick: JavaScript function (optional)
--%>

<g:set var="colorClasses" value="${[
    'green': [active: 'bg-green-500 text-white', inactive: 'bg-gray-100 text-gray-700'],
    'blue': [active: 'bg-blue-500 text-white', inactive: 'bg-gray-100 text-gray-700'],
    'purple': [active: 'bg-purple-500 text-white', inactive: 'bg-gray-100 text-gray-700'],
    'orange': [active: 'bg-orange-500 text-white', inactive: 'bg-gray-100 text-gray-700'],
    'yellow': [active: 'bg-yellow-500 text-white', inactive: 'bg-gray-100 text-gray-700'],
    'red': [active: 'bg-red-500 text-white', inactive: 'bg-gray-100 text-gray-700']
]}"/>

<g:set var="currentColor" value="${color ?: 'green'}"/>
<g:set var="isActive" value="${active ?: false}"/>
<g:set var="stateClass" value="${isActive ? colorClasses[currentColor].active : colorClasses[currentColor].inactive}"/>

<button ${id ? "id=\"${id}\"" : ""} 
        ${onclick ? "onclick=\"${onclick}\"" : ""}
        class="touch-toggle ${stateClass} min-h-[60px] rounded-lg font-medium transition-all duration-200 hover:scale-105 active:scale-95 shadow-sm hover:shadow-md flex flex-col items-center justify-center space-y-1 p-3">
    
    <g:if test="${icon}">
        ${raw(icon)}
    </g:if>
    
    <span class="text-sm font-medium">${text}</span>
    
    <g:if test="${subtext}">
        <span class="text-xs ${isActive ? 'font-bold' : 'font-normal'}">${subtext}</span>
    </g:if>
</button>