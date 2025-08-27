package awana

class Student {

    String firstName
    String lastName
    Date dateOfBirth
    String profileImage
    Integer awanaBucks = 0
    Boolean isActive = true

    static belongsTo = [household: Household, club: Club]
    static hasMany = [attendances: Attendance, sectionVerseCompletions: SectionVerseCompletion]

    static constraints = {
        firstName blank: false, nullable: false
        lastName blank: false, nullable: false
        dateOfBirth nullable: false
        profileImage nullable: true
        awanaBucks nullable: false, min: 0
        isActive nullable: false
        household nullable: false
        club nullable: false
    }

    static mapping = {
        version false
        profileImage type: 'text'
    }

    String toString() {
        return "${firstName} ${lastName}"
    }

    String getFullName() {
        return "${firstName} ${lastName}"
    }

    Integer getAge() {
        if (!dateOfBirth) return 0
        
        Date today = new Date()
        long ageInMillis = today.time - dateOfBirth.time
        long ageInYears = ageInMillis / (365.25 * 24 * 60 * 60 * 1000)
        
        return (int) ageInYears
    }

    Integer calculateTotalBucks() {
        Integer attendanceBucks = attendances?.sum { it.bucksEarned } ?: 0
        Integer completionBucks = sectionVerseCompletions?.sum { it.bucksEarned } ?: 0
        return attendanceBucks + completionBucks
    }

    def beforeUpdate() {
        awanaBucks = calculateTotalBucks()
    }

    def beforeInsert() {
        awanaBucks = calculateTotalBucks()
    }

    BigDecimal getAttendancePercentage(Calendar calendar = null) {
        if (!calendar) {
            calendar = Calendar.getCurrentSemester()
        }
        if (!calendar) return 0.0

        List<Date> allDates = calendar.getAttendanceDates()
        List<Date> presentDates = attendances?.findAll { it.present }?.collect { it.attendanceDate } ?: []
        
        if (allDates.size() == 0) return 0.0
        
        return (presentDates.size() / allDates.size()) * 100
    }

    ChapterSection getCurrentProgress(Calendar calendar = null) {
        if (!calendar) {
            calendar = Calendar.getCurrentSemester()
        }
        if (!calendar) return null

        return calendar.getCurrentSection(club)
    }

    List<SectionVerseCompletion> getCompletedSections() {
        return sectionVerseCompletions?.findAll { 
            it.studentCompleted || it.parentCompleted || it.silverSectionCompleted || it.goldSectionCompleted 
        } ?: []
    }
}