package awana

class TimeFormatTagLib {
    static namespace = "fmt"

    /**
     * Format LocalTime objects with flexible patterns
     * Usage: <fmt:time time="${calendar.startTime}"/>
     *        <fmt:time time="${calendar.startTime}" pattern="HH:mm"/>
     */
    def time = { attrs ->
        def time = attrs.time
        if (!time) return
        
        def pattern = attrs.pattern ?: "h:mm a"
        try {
            def formatter = java.time.format.DateTimeFormatter.ofPattern(pattern)
            out << time.format(formatter)
        } catch (Exception e) {
            // Fallback to toString if formatting fails
            out << time.toString()
        }
    }
    
    /**
     * Format LocalTime for HTML time inputs (HH:mm format)
     * Usage: <fmt:timeInput time="${calendar.startTime}"/>
     */
    def timeInput = { attrs ->
        def time = attrs.time
        if (!time) return
        
        try {
            def formatter = java.time.format.DateTimeFormatter.ofPattern('HH:mm')
            out << time.format(formatter)
        } catch (Exception e) {
            // Fallback to toString if formatting fails
            out << time.toString()
        }
    }
}