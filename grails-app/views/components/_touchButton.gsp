<%-- 
Touch-Optimized Button Component
Usage: <g:render template="/components/touchButton" model="[text: 'Click Me', style: 'primary', size: 'lg', onclick: 'doSomething()']"

Parameters:
- text: Button text (required)
- style: primary, secondary, success, warning, danger (default: primary)
- size: sm, md, lg, xl (default: md)
- onclick: JavaScript function (optional)
- href: Link URL (optional - makes it a link button)
- icon: SVG icon HTML (optional)
- disabled: Boolean (optional)
- fullWidth: Boolean (optional, default true for mobile)
--%>

<g:set var="baseClasses" value="inline-flex items-center justify-center font-bold rounded-xl transition-all duration-200 transform hover:scale-105 active:scale-95 shadow-sm hover:shadow-md focus:outline-none focus:ring-4"/>

<g:set var="sizeClasses" value="${[
    'sm': 'px-4 py-2 text-sm min-h-[44px]',
    'md': 'px-6 py-3 text-base min-h-[48px]', 
    'lg': 'px-8 py-4 text-lg min-h-[60px]',
    'xl': 'px-10 py-5 text-xl min-h-[72px]'
]}"/>

<g:set var="styleClasses" value="${[
    'primary': 'bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white focus:ring-blue-200',
    'secondary': 'bg-gray-200 hover:bg-gray-300 active:bg-gray-400 text-gray-900 focus:ring-gray-200',
    'success': 'bg-green-600 hover:bg-green-700 active:bg-green-800 text-white focus:ring-green-200',
    'warning': 'bg-yellow-500 hover:bg-yellow-600 active:bg-yellow-700 text-white focus:ring-yellow-200',
    'danger': 'bg-red-600 hover:bg-red-700 active:bg-red-800 text-white focus:ring-red-200'
]}"/>

<g:set var="currentSize" value="${size ?: 'md'}"/>
<g:set var="currentStyle" value="${style ?: 'primary'}"/>
<g:set var="widthClass" value="${fullWidth != false ? 'w-full' : ''}"/>
<g:set var="disabledClass" value="${disabled ? 'opacity-50 cursor-not-allowed pointer-events-none' : ''}"/>

<g:set var="allClasses" value="${baseClasses} ${sizeClasses[currentSize]} ${styleClasses[currentStyle]} ${widthClass} ${disabledClass}"/>

<g:if test="${href}">
    <a href="${href}" class="${allClasses}" ${onclick ? "onclick=\"${onclick}\"" : ""}>
        <g:if test="${icon}">
            ${raw(icon)}
        </g:if>
        <span class="${icon ? 'ml-2' : ''}">${text}</span>
    </a>
</g:if>
<g:else>
    <button type="button" class="${allClasses}" ${onclick ? "onclick=\"${onclick}\"" : ""} ${disabled ? 'disabled' : ''}>
        <g:if test="${icon}">
            ${raw(icon)}
        </g:if>
        <span class="${icon ? 'ml-2' : ''}">${text}</span>
    </button>
</g:else>