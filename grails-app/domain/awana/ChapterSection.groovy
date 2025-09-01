package awana

class ChapterSection {

    String sectionNumber
    String content
    Boolean isSilverSection = false
    Boolean isGoldSection = false

    static belongsTo = [chapter: Chapter]
    static hasMany = [completions: SectionVerseCompletion, verses: Verse]

    static constraints = {
        sectionNumber blank: false, nullable: false
        content nullable: true
        isSilverSection nullable: false
        isGoldSection nullable: false
    }

    static mapping = {
        version false
        content type: 'text'
    }

    String toString() {
        return "${chapter?.chapterNumber}.${sectionNumber}"
    }

    String getSectionType() {
        if (isGoldSection) return "Gold"
        if (isSilverSection) return "Silver" 
        return "Regular"
    }

    Integer getBucksValue() {
        if (isGoldSection) return 3
        if (isSilverSection) return 1
        return 1 // regular section verse completion
    }
}