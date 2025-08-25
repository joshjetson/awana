<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Awana - Dashboard</title>
</head>
<body>

<content tag="nav">
    <div class="flex items-center space-x-4">
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900">
            Logout
        </g:link>
    </div>
</content>

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
    <div class="container mx-auto px-4 py-16">
        <div class="text-center mb-16">
            <h1 class="text-4xl md:text-6xl font-bold text-gray-900 mb-4">
                Welcome to <span class="text-blue-600">Awana</span>
            </h1>
            <p class="text-xl text-gray-600 max-w-2xl mx-auto">
                A modern Grails PWA application with HTMX, Tailwind CSS, and Spring Security
            </p>
            <div class="mt-6">
                <span class="inline-block bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
                    ✅ Successfully logged in!
                </span>
            </div>
        </div>
    </div>
</div>

</body>
</html>