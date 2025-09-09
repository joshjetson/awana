package awana

class SectionVerseCompletion {

    Student student
    ChapterSection chapterSection

    Date completionDate
    Boolean reviewCompleted = false
    Boolean studentCompleted = false
    Boolean parentCompleted = false
    Boolean silverSectionCompleted = false
    Boolean goldSectionCompleted = false
    Boolean chapterReview = false
    Integer bucksEarned = 0

    static belongsTo = [student: Student]  // only belongs to student

    static constraints = {
        completionDate nullable: true  // Allow null initially, set in beforeInsert
        chapterSection nullable: false
        studentCompleted nullable: false
        parentCompleted nullable: false
        silverSectionCompleted nullable: false
        goldSectionCompleted nullable: false
        reviewCompleted nullable: false
        chapterReview nullable: false
        bucksEarned nullable: false, min: 0
    }

    static mapping = {
        version false
        completionDate index: true
    }

    def beforeInsert() {
        if (!completionDate) {
            completionDate = new Date()
        }
        bucksEarned = calculateBucksEarned()
    }

    def beforeUpdate() {
        bucksEarned = calculateBucksEarned()
    }

    private Integer calculateBucksEarned() {
        Integer bucks = 0
        if (studentCompleted) bucks += 1
        if (parentCompleted) bucks += 2
        if (reviewCompleted) bucks += 1
        if (silverSectionCompleted) bucks += 1
        if (goldSectionCompleted) bucks += 3
        if (chapterReview) bucks += 5
        return bucks
    }

    String toString() {
        return "${student?.fullName} - ${chapterSection?.toString()} (${completionDate?.format('MM/dd/yyyy')})"
    }

    Boolean hasAnyCompletion() {
        return studentCompleted || parentCompleted || silverSectionCompleted || goldSectionCompleted || reviewCompleted || chapterReview
    }

    String getCompletionSummary() {
        List<String> completed = []
        
        if (studentCompleted) completed << "Student Verse"
        if (parentCompleted) completed << "Parent Verse"
        if (reviewCompleted) completed << "Review Verse"
        if (silverSectionCompleted) completed << "Silver Section"
        if (goldSectionCompleted) completed << "Gold Section"
        if (chapterReview) completed << "Chapter Review"
        
        return completed.join(", ") ?: "No completions"
    }

    Integer getTotalCompletions() {
        Integer total = 0
        if (studentCompleted) total++
        if (parentCompleted) total++
        if (reviewCompleted) total++
        if (silverSectionCompleted) total++
        if (goldSectionCompleted) total++
        if (chapterReview) total++
        return total
    }
}