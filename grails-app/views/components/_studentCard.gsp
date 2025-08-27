<%-- 
Student Card Component (for lists, search results, etc.)
Usage: <g:render template="/components/studentCard" model="[student: studentObject, showBucks: true, showAttendance: true, clickable: true]"

Parameters:
- student: Student domain object (required)
- showBucks: Boolean - show Awana bucks (default: true)
- showAttendance: Boolean - show attendance status (default: false)  
- clickable: Boolean - make card clickable (default: false)
- href: Link URL if clickable (optional)
- onclick: JavaScript function if clickable (optional)
- compact: Boolean - smaller version (default: false)
--%>

<g:set var="cardSize" value="${compact ? 'p-3' : 'p-4'}"/>
<g:set var="avatarSize" value="${compact ? 'w-10 h-10' : 'w-12 h-12'}"/>
<g:set var="textSize" value="${compact ? 'text-base' : 'text-lg'}"/>
<g:set var="clickableClass" value="${clickable ? 'hover:bg-blue-50 cursor-pointer transition-colors' : ''}"/>

<g:set var="clubColors" value="${[
    'Cubbies': 'bg-yellow-100 text-yellow-800',
    'Sparks': 'bg-orange-100 text-orange-800', 
    'Truth & Training': 'bg-blue-100 text-blue-800',
    'T&T': 'bg-blue-100 text-blue-800',
    'Trek': 'bg-purple-100 text-purple-800',
    'Journey': 'bg-green-100 text-green-800'
]}"/>

<g:set var="cardContent">
    <div class="border border-gray-200 rounded-xl ${cardSize} ${clickableClass} min-h-[80px]">
        <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3 flex-1">
                <!-- Student Avatar -->
                <div class="${avatarSize} bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center text-white font-bold">
                    ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                </div>
                
                <div class="flex-1 min-w-0">
                    <!-- Student Name -->
                    <div class="font-bold text-gray-900 ${textSize} truncate">
                        ${student.getFullName()}
                    </div>
                    
                    <!-- Student Info -->
                    <div class="flex flex-wrap items-center gap-2 mt-1">
                        <!-- Club Badge -->
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${clubColors[student.club.name] ?: 'bg-gray-100 text-gray-800'}">
                            ${student.club.name}
                        </span>
                        
                        <!-- Age -->
                        <span class="text-sm text-gray-600">
                            Age ${student.getAge()}
                        </span>
                        
                        <g:if test="${showBucks}">
                            <!-- Awana Bucks -->
                            <span class="text-sm font-medium text-green-600">
                                ${student.calculateTotalBucks()} bucks
                            </span>
                        </g:if>
                    </div>
                </div>
            </div>
            
            <!-- Right Side Info -->
            <div class="text-right flex-shrink-0 ml-4">
                <g:if test="${showAttendance}">
                    <!-- Attendance Status (if today's attendance exists) -->
                    <g:set var="todaysAttendance" value="${awana.Attendance.findByStudentAndAttendanceDate(student, new Date())}"/>
                    <g:if test="${todaysAttendance?.present}">
                        <div class="flex items-center text-green-600 justify-end">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                            <span class="text-xs font-medium">Present</span>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="flex items-center text-gray-500 justify-end">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <span class="text-xs">Not checked in</span>
                        </div>
                    </g:else>
                </g:if>
                
                <g:if test="${showBucks && !showAttendance}">
                    <!-- Large Bucks Display -->
                    <div class="text-2xl font-bold text-green-600">
                        ${student.calculateTotalBucks()}
                    </div>
                    <div class="text-xs text-gray-500">bucks</div>
                </g:if>
                
                <g:if test="${clickable}">
                    <!-- Arrow indicator -->
                    <svg class="w-5 h-5 text-gray-400 mt-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </g:if>
            </div>
        </div>
    </div>
</g:set>

<g:if test="${clickable && href}">
    <a href="${href}" class="block" ${onclick ? "onclick=\"${onclick}\"" : ""}>
        ${raw(cardContent)}
    </a>
</g:if>
<g:elseif test="${clickable && onclick}">
    <div class="block" onclick="${onclick}">
        ${raw(cardContent)}
    </div>
</g:elseif>
<g:else>
    ${raw(cardContent)}
</g:else>