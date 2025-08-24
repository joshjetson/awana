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
