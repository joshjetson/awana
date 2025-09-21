<g:if test="${roster && roster.size() > 0}">
    <g:each in="${roster}" var="student" status="i">
        <div class="bg-white/90 backdrop-blur-sm px-4 py-3 rounded-xl text-sm shadow-md border border-white/30 hover:bg-white hover:shadow-lg transition-all duration-300 transform hover:scale-105">
            <div class="font-bold text-gray-800 text-base">${student.studentName}</div>
            <g:if test="${student.club}">
                <div class="text-gray-700 text-xs font-medium mt-1 bg-yellow-300/80 px-2 py-1 rounded-full inline-block">${student.club}</div>
            </g:if>
        </div>
    </g:each>
</g:if>
<g:else>
    <div class="text-center py-8 col-span-full text-white/90">
        <div class="text-5xl mb-3">🌟</div>
        <p class="text-xl font-bold">Ready for our first champion!</p>
        <p class="text-sm text-white/70 mt-1">Students will appear here as they check in</p>
    </div>
</g:else>