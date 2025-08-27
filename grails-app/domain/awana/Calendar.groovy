package awana

class Calendar {

    Date startDate
    Date endDate
    String dayOfWeek
    Date startTime
    Date endTime
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
        startTime type: 'time'
        endTime type: 'time'
    }

    String toString() {
        return "${description ?: 'Awana Calendar'} (${startDate.format('MM/dd/yyyy')} - ${endDate.format('MM/dd/yyyy')})"
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
            List<ChapterSection> sections = chapter.getOrderedSections().findAll { !it.isSilverSection && !it.isGoldSection }
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
}