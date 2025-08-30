<%-- 
Bottom Navigation Bar Component (mobile-first navigation)
Usage: <g:render template="/components/bottomNavBar" model="[currentPage: 'dashboard']"

Parameters:
- currentPage: Current active page identifier (dashboard, checkin, students, attendance, clubs, store)
--%>

<g:set var="navItems" value="${[
    [id: 'dashboard', label: 'Dashboard', href: '/', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6\"/></svg>'''],
    [id: 'checkin', label: 'Check-In', href: '/checkin', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h4\"/></svg>'''],
    [id: 'students', label: 'Students', href: '/students', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z\"/></svg>'''],
    [id: 'attendance', label: 'Attendance', href: '/attendance', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01\"/></svg>'''],
    [id: 'clubs', label: 'Clubs', href: '/clubs', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4\"/></svg>'''],
    [id: 'store', label: 'Store', href: '/store', icon: '''<svg class=\"w-6 h-6\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1\"/></svg>''']
]}"/>

<!-- Fixed Bottom Navigation -->
<nav class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50 safe-area-pb">
    <div class="max-w-screen-xl mx-auto px-4">
        <div class="flex justify-around items-center h-20">
            <g:each in="${navItems}" var="item">
                <g:set var="isActive" value="${currentPage == item.id}"/>
                <g:set var="activeClass" value="${isActive ? 'text-blue-600' : 'text-gray-500 hover:text-gray-700'}"/>
                
                <a href="${item.href}" 
                   class="flex flex-col items-center justify-center px-4 py-3 rounded-lg transition-colors min-w-[80px] ${activeClass}">
                    
                    <!-- Icon -->
                    <div class="mb-2">
                        <div class="w-10 h-10">
                            ${raw(item.icon.replace('w-6 h-6', 'w-10 h-10'))}
                        </div>
                    </div>
                    
                    <!-- Label -->
                    <span class="text-sm font-semibold">${item.label}</span>
                    
                    <!-- Active indicator -->
                    <g:if test="${isActive}">
                        <div class="w-2 h-2 bg-blue-600 rounded-full mt-1"></div>
                    </g:if>
                </a>
            </g:each>
        </div>
    </div>
</nav>

<!-- Add bottom padding to main content to account for fixed nav -->
<style>
    .safe-area-pb {
        padding-bottom: env(safe-area-inset-bottom, 0px);
    }
    
    /* Ensure main content has bottom padding when nav is present */
    body.has-bottom-nav {
        padding-bottom: 96px; /* 80px nav height + 16px extra padding */
    }
    
    @media (max-width: 640px) {
        body.has-bottom-nav {
            padding-bottom: 100px; /* Slightly more on mobile */
        }
    }
</style>

<script>
    // Add class to body for bottom padding
    document.body.classList.add('has-bottom-nav');
</script>