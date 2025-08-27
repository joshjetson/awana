// Minimal application.js for HTMX-based Grails application
//
// HTMX loaded locally from assets
//
//= require htmx.min
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
