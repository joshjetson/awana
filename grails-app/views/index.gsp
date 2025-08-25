<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Awana - Welcome</title>
</head>
<body>

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
    <!-- Hero Section -->
    <div class="container mx-auto px-4 py-16">
        <div class="text-center mb-16">
            <h1 class="text-4xl md:text-6xl font-bold text-gray-900 mb-4">
                Welcome to <span class="text-blue-600">Awana</span>
            </h1>
            <p class="text-xl text-gray-600 max-w-2xl mx-auto">
                A modern Grails PWA application with HTMX, Tailwind CSS, and Spring Security
            </p>
        </div>

        <!-- Feature Cards -->
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
            <!-- System Info Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="flex items-center mb-4">
                    <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 ml-3">System Status</h3>
                </div>
                <div class="space-y-2 text-sm text-gray-600">
                    <div class="flex justify-between">
                        <span>Environment:</span>
                        <span class="font-medium">${grails.util.Environment.current.name}</span>
                    </div>
                    <div class="flex justify-between">
                        <span>App Version:</span>
                        <span class="font-medium"><g:meta name="info.app.version"/></span>
                    </div>
                    <div class="flex justify-between">
                        <span>Grails:</span>
                        <span class="font-medium"><g:meta name="info.app.grailsVersion"/></span>
                    </div>
                    <div class="flex justify-between">
                        <span>Groovy:</span>
                        <span class="font-medium">${GroovySystem.getVersion()}</span>
                    </div>
                    <div class="flex justify-between">
                        <span>JVM:</span>
                        <span class="font-medium">${System.getProperty('java.version')}</span>
                    </div>
                </div>
            </div>

            <!-- Application Stats Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="flex items-center mb-4">
                    <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                        <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 ml-3">Application</h3>
                </div>
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div class="text-center p-3 bg-gray-50 rounded">
                        <div class="text-2xl font-bold text-gray-900">${grailsApplication.controllerClasses.size()}</div>
                        <div class="text-gray-600">Controllers</div>
                    </div>
                    <div class="text-center p-3 bg-gray-50 rounded">
                        <div class="text-2xl font-bold text-gray-900">${grailsApplication.domainClasses.size()}</div>
                        <div class="text-gray-600">Domains</div>
                    </div>
                    <div class="text-center p-3 bg-gray-50 rounded">
                        <div class="text-2xl font-bold text-gray-900">${grailsApplication.serviceClasses.size()}</div>
                        <div class="text-gray-600">Services</div>
                    </div>
                    <div class="text-center p-3 bg-gray-50 rounded">
                        <div class="text-2xl font-bold text-gray-900">${grailsApplication.tagLibClasses.size()}</div>
                        <div class="text-gray-600">Tag Libs</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow md:col-span-2 lg:col-span-1">
                <div class="flex items-center mb-4">
                    <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                        <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 ml-3">Quick Actions</h3>
                </div>
                <div class="space-y-3">
                    <button class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded transition-colors">
                        View Controllers
                    </button>
                    <button class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium py-2 px-4 rounded transition-colors">
                        System Info
                    </button>
                    <button class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium py-2 px-4 rounded transition-colors">
                        Plugins
                    </button>
                </div>
            </div>
        </div>

        <!-- Controllers List -->
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Available Controllers</h2>
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                <g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">
                    <g:link controller="${c.logicalPropertyName}" class="block p-4 bg-gray-50 hover:bg-blue-50 rounded-lg border border-gray-200 hover:border-blue-300 transition-all group">
                        <div class="flex items-center justify-between">
                            <span class="font-medium text-gray-900 group-hover:text-blue-600">${c.fullName}</span>
                            <svg class="w-4 h-4 text-gray-400 group-hover:text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                            </svg>
                        </div>
                    </g:link>
                </g:each>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center mt-16 text-gray-500">
            <p>&copy; ${new Date().year + 1900} Awana Project. Built with Grails ${grails.util.GrailsUtil.grailsVersion}</p>
        </div>
    </div>
</div>

</body>
</html>