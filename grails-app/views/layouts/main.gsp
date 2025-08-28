<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Awana"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <meta name="theme-color" content="#2563eb"/>
    
    <!-- PWA Meta Tags -->
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
    <meta name="apple-mobile-web-app-title" content="Awana">
    
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>
    <asset:link rel="apple-touch-icon" href="apple-touch-icon.png"/>
    <asset:link rel="apple-touch-icon" href="apple-touch-icon-retina.png" sizes="152x152"/>
    <asset:link rel="manifest" href="manifest.json"/>
    
    <asset:stylesheet src="application.css"/>
    
    <!-- HTMX loaded locally from assets -->
    <asset:javascript src="htmx.min.js"/>
    
    <!-- FullCalendar library for attendance calendar (offline) -->
    <asset:javascript src="fullcalendar.min.js"/>
    
    <!-- Custom animations for notifications -->
    <style>
        .animate-fade-in {
            animation: fadeIn 0.3s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .htmx-indicator {
            display: none;
        }
        
        .htmx-request .htmx-indicator {
            display: inline-block;
        }
        
        .htmx-request button {
            opacity: 0.6;
            cursor: not-allowed;
        }
    </style>

    <g:layoutHead/>
</head>

<body class="min-h-screen bg-gray-50">
    <!-- Simple header for PWA -->
    <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center">
                    <h1 class="text-xl font-semibold text-gray-900">
                        <g:layoutTitle default="Awana"/>
                    </h1>
                </div>
                <nav>
                    <g:pageProperty name="page.nav"/>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main content area -->
    <main class="flex-1 overflow-auto">
        <g:layoutBody/>
    </main>

    <!-- HTMX loading indicator -->
    <div id="htmx-indicator" class="fixed top-4 right-4 bg-blue-500 text-white px-4 py-2 rounded-lg shadow-lg opacity-0 transition-opacity duration-300">
        Loading...
    </div>

    <asset:javascript src="application.js"/>

</body>
</html>
