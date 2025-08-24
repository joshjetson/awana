/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './grails-app/views/**/*.gsp',
    './grails-app/views/**/*.html',
    './src/**/*.{html,js}',
  ],
  theme: {
    extend: {
      // Touch-friendly sizing for PWA
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
      },
      minHeight: {
        '12': '3rem',
        '16': '4rem',
      },
      // PWA-optimized colors
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        }
      },
      // Touch target sizing
      fontSize: {
        'base': '16px', // Minimum for mobile
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}