<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Verse Completion - Awana Club</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body>

<content tag="nav">
    <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2">
            <g:link controller="universal" action="index" class="w-8 h-8 bg-purple-600 rounded-lg flex items-center justify-center hover:bg-purple-700 transition-colors">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m0 7h18"/>
                </svg>
            </g:link>
            <span class="font-semibold text-gray-900">Verse Completion</span>
        </div>
        <g:link controller="logout" class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
        </g:link>
    </div>
</content>

<g:render template="verseCompletion" model="[students: students, chapters: chapters, clubs: clubs]"/>

</body>
</html>