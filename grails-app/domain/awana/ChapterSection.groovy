package awana

class ChapterSection {

    String sectionNumber
    String content
    Boolean isFinalSection = false

    static belongsTo = [chapter: Chapter]
    static hasMany = [completions: SectionVerseCompletion, verses: Verse]

    static constraints = {
        sectionNumber blank: false, nullable: false
        content nullable: true
    }

    static mapping = {
        version false
        content type: 'text'
    }

    String toString() {
        return "${chapter?.chapterNumber}.${sectionNumber}"
    }

    String getSectionType() {
        return "Regular"
    }

    Integer getBucksValue() {
        return 1 // regular section verse completion
    }
}