// Minimal application.js for HTMX-based Grails application
//
// HTMX loaded locally from assets
//
//= require htmx.min
//= require sse
//= require fullcalendar.min
//= require_self

// HTMX Configuration for PWA
document.addEventListener('DOMContentLoaded', function() {
    // Configure HTMX loading indicator
    document.body.addEventListener('htmx:beforeRequest', function() {
        const indicator = document.getElementById('htmx-indicator');
        if (indicator) {
            indicator.style.opacity = '1';
        }
    });
    
    document.body.addEventListener('htmx:afterRequest', function() {
        const indicator = document.getElementById('htmx-indicator');
        if (indicator) {
            indicator.style.opacity = '0';
        }
    });
    
    // PWA-optimized touch handling
    document.body.style.touchAction = 'manipulation';
    
    // Success toast notification handler
    document.body.addEventListener('showSuccessToast', function(evt) {
        const data = evt.detail;
        showSuccessToast(data.message || 'Operation completed successfully');
    });
});

// ====================================================================
// GLOBAL AWANA APPLICATION FUNCTIONS
// ====================================================================

// Common function for showing verse completion view
function showVerseCompletion(studentId) {
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'verseCompletion',
            studentId: studentId
        },
        target: '#dynamic-content, #spa-content #dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        // Show dynamic content area (works for both index.gsp and students.gsp)
        const dynamicContent = document.getElementById('dynamic-content') || 
                              document.querySelector('#spa-content #dynamic-content');
        const spaContent = document.getElementById('spa-content');
        
        if (spaContent && dynamicContent === document.querySelector('#spa-content #dynamic-content')) {
            // We're on index.gsp - show SPA content
            document.querySelector('.min-h-screen').style.display = 'none';
            spaContent.style.display = 'block';
        } else if (dynamicContent) {
            // We're on students.gsp - show dynamic content and scroll
            dynamicContent.style.display = 'block';
            dynamicContent.scrollIntoView({ behavior: 'smooth' });
        }
    });
}

// Common function for showing club overview
function showClubOverview(clubId, clubName) {
    htmx.ajax('GET', '/renderView', {
        values: { 
            viewType: 'clubOverview',
            clubId: clubId
        },
        target: '#dynamic-content, #spa-content #dynamic-content',
        swap: 'innerHTML'
    }).then(() => {
        // Show dynamic content area (works for both index.gsp and students.gsp)  
        const dynamicContent = document.getElementById('dynamic-content') ||
                              document.querySelector('#spa-content #dynamic-content');
        const spaContent = document.getElementById('spa-content');
        
        if (spaContent && dynamicContent === document.querySelector('#spa-content #dynamic-content')) {
            // We're on index.gsp - show SPA content
            document.querySelector('.min-h-screen').style.display = 'none';
            spaContent.style.display = 'block';
        } else if (dynamicContent) {
            // We're on students.gsp - show dynamic content and scroll
            dynamicContent.style.display = 'block';
            dynamicContent.scrollIntoView({ behavior: 'smooth' });
        }
    });
}

// Success toast notification function
function showSuccessToast(message) {
    // Create toast container if it doesn't exist
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.className = 'fixed top-4 right-4 z-50 space-y-2';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = 'bg-green-500 text-white px-4 py-3 rounded-lg shadow-lg flex items-center space-x-2 transform transition-all duration-300 translate-x-full opacity-0';
    toast.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
        <span>${message}</span>
    `;
    
    toastContainer.appendChild(toast);
    
    // Animate in
    setTimeout(() => {
        toast.classList.remove('translate-x-full', 'opacity-0');
    }, 10);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        toast.classList.add('translate-x-full', 'opacity-0');
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }, 3000);
}