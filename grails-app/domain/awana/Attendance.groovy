package awana

class Attendance {

    Date attendanceDate
    Boolean present = false
    Boolean hasUniform = false
    Boolean hasBible = false
    Boolean hasHandbook = false
    Integer bucksEarned = 0

    static belongsTo = [student: Student, calendar: Calendar]

    static constraints = {
        attendanceDate nullable: false
        present nullable: false
        hasUniform nullable: false
        hasBible nullable: false
        hasHandbook nullable: false
        bucksEarned nullable: false, min: 0
        student nullable: false
        calendar nullable: false
    }

    static mapping = {
        version false
        attendanceDate index: true
    }

    String toString() {
        return "${student?.fullName} - ${attendanceDate?.format('MM/dd/yyyy')}"
    }

    Integer calculateBucksEarned() {
        Integer bucks = 0
        
        if (present) bucks += 1
        if (hasUniform) bucks += 1
        if (hasBible && hasHandbook) bucks += 1
        
        return bucks
    }

    def beforeInsert() {
        bucksEarned = calculateBucksEarned()
    }

    def beforeUpdate() {
        bucksEarned = calculateBucksEarned()
    }

    Boolean isEligibleForBucks() {
        return present && calendar?.getCurrentSemesterDate()
    }

    String getAttendanceStatus() {
        if (!present) return "Absent"
        
        List<String> items = []
        if (hasUniform) items << "Uniform"
        if (hasBible) items << "Bible"
        if (hasHandbook) items << "Handbook"
        
        return items ? "Present with ${items.join(', ')}" : "Present"
    }
}