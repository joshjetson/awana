<%-- 
Status Card Component (for dashboard stats, family info, etc.)
Usage: <g:render template="/components/statusCard" model="[title: 'Students', value: '47', subtitle: 'Active', icon: iconSvg, color: 'blue', clickable: true, href: '/students']"

Parameters:
- title: Card title (required)
- value: Main value/number (optional)
- subtitle: Small text below value (optional)
- icon: SVG icon HTML (optional)
- color: blue, green, purple, orange, yellow, red (default: blue)
- clickable: Boolean (optional)
- href: Link URL if clickable (optional)
- onclick: JavaScript function if clickable (optional)
--%>

<g:set var="colorClasses" value="${[
    'blue': 'from-blue-500 to-blue-600 text-white',
    'green': 'from-green-500 to-green-600 text-white',
    'purple': 'from-purple-500 to-purple-600 text-white',
    'orange': 'from-orange-500 to-orange-600 text-white',
    'yellow': 'from-yellow-400 to-yellow-500 text-gray-900',
    'red': 'from-red-500 to-red-600 text-white',
    'gray': 'from-gray-100 to-gray-200 text-gray-900'
]}"/>

<g:set var="currentColor" value="${color ?: 'blue'}"/>
<g:set var="gradientClass" value="bg-gradient-to-r ${colorClasses[currentColor]}"/>
<g:set var="clickableClass" value="${clickable ? 'hover:scale-105 cursor-pointer transition-transform duration-200' : ''}"/>

<g:set var="cardContent">
    <div class="${gradientClass} rounded-xl shadow-lg p-6 ${clickableClass} min-h-[120px]">
        <div class="flex items-center justify-between">
            <div class="flex-1">
                <g:if test="${title}">
                    <h3 class="text-sm font-medium opacity-90">${title}</h3>
                </g:if>
                
                <g:if test="${value}">
                    <div class="text-3xl font-bold mt-1">${value}</div>
                </g:if>
                
                <g:if test="${subtitle}">
                    <p class="text-sm opacity-75 mt-1">${subtitle}</p>
                </g:if>
            </div>
            
            <g:if test="${icon}">
                <div class="flex-shrink-0 ml-4">
                    <div class="w-12 h-12 rounded-full bg-white bg-opacity-20 flex items-center justify-center">
                        ${raw(icon)}
                    </div>
                </div>
            </g:if>
        </div>
    </div>
</g:set>

<g:if test="${clickable && href}">
    <a href="${href}" class="block" ${onclick ? "onclick=\"${onclick}\"" : ""}>
        ${raw(cardContent)}
    </a>
</g:if>
<g:elseif test="${clickable && onclick}">
    <div class="block cursor-pointer" onclick="${onclick}">
        ${raw(cardContent)}
    </div>
</g:elseif>
<g:else>
    ${raw(cardContent)}
</g:else>