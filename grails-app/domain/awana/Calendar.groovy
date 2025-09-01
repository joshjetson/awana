package awana
import java.time.LocalTime

class Calendar {

    Date startDate
    Date endDate
    String dayOfWeek
    LocalTime startTime
    LocalTime endTime
    String description

    static hasMany = [attendances: Attendance]

    static constraints = {
        startDate nullable: false
        endDate nullable: false
        dayOfWeek blank: false, nullable: false, inList: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        startTime nullable: true
        endTime nullable: true
        description nullable: true
    }

    static mapping = {
        version false
    }

    String toString() {
        def dateFormat = new java.text.SimpleDateFormat('MM/dd/yyyy')
        def startStr = startDate ? dateFormat.format(startDate) : 'null'
        def endStr = endDate ? dateFormat.format(endDate) : 'null'
        return "${description ?: 'Awana Calendar'} (${startStr} - ${endStr})"
    }
    
    // Essential convenience methods for clean GSP usage
    String getStartTimeDisplay() {
        if (!startTime) return ''
        def formatter = java.time.format.DateTimeFormatter.ofPattern('h:mm a')
        return startTime.format(formatter)
    }
    
    String getEndTimeDisplay() {
        if (!endTime) return ''
        def formatter = java.time.format.DateTimeFormatter.ofPattern('h:mm a')
        return endTime.format(formatter)
    }
    
    String getTimeRangeDisplay() {
        if (startTime && endTime) {
            return "${getStartTimeDisplay()} - ${getEndTimeDisplay()}"
        }
        return ''
    }

    List<Date> getAttendanceDates() {
        List<Date> dates = []
        Date current = new Date(startDate.time)
        
        while (current <= endDate) {
            if (current.format('EEEE') == dayOfWeek) {
                dates << new Date(current.time)
            }
            current = current + 1
        }
        return dates
    }

    Date getCurrentSemesterDate() {
        Date today = new Date()
        if (today >= startDate && today <= endDate) {
            return today
        }
        return null
    }

    Integer getWeekNumber(Date date = new Date()) {
        if (!getCurrentSemesterDate()) return null
        
        List<Date> allDates = getAttendanceDates()
        Date targetDate = allDates.find { it.format('yyyy-MM-dd') == date.format('yyyy-MM-dd') }
        
        return targetDate ? (allDates.indexOf(targetDate) + 1) : null
    }

    ChapterSection getCurrentSection(Club club, Book book = null) {
        Integer weekNum = getWeekNumber()
        if (!weekNum) return null

        Book targetBook = book ?: club.getPrimaryBook()
        if (!targetBook) return null

        List<Chapter> chapters = targetBook.getOrderedChapters()
        if (!chapters) return null

        Integer totalSections = 0
        for (Chapter chapter : chapters) {
            List<ChapterSection> sections = chapter.getOrderedSections()
            if (totalSections + sections.size() >= weekNum) {
                Integer sectionIndex = weekNum - totalSections - 1
                return sections[sectionIndex]
            }
            totalSections += sections.size()
        }

        return chapters.last()?.getOrderedSections()?.last()
    }

    ChapterSection getNextSection(Club club, Book book = null) {
        Integer nextWeek = (getWeekNumber() ?: 0) + 1
        Date nextDate = new Date() + 7
        
        return getCurrentSection(club, book)
    }

    static Calendar getCurrentSemester() {
        Date today = new Date()
        return Calendar.find("FROM Calendar WHERE startDate <= :today1 AND endDate >= :today2", [today1: today, today2: today])
    }

    static List<Calendar> findAllActive() {
        Date today = new Date()
        return Calendar.findAll("FROM Calendar WHERE startDate <= :today1 AND endDate >= :today2", [today1: today, today2: today])
    }
    def beforeInsert() {
        normalizeEndDate()
    }

    def beforeUpdate() {
        normalizeEndDate()
    }
    private void normalizeEndDate() {// We need to always add 1 day to the end date otherwise the calendar wont show the last day
        if (endDate) {
            def cal = java.util.Calendar.getInstance()
            cal.setTime(endDate)
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1)
            endDate = cal.time
        }
    }



}