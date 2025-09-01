package awana

class Verse {

    String reference   // e.g. "John 3:16"
    String text        // the actual verse text
    Boolean isReview = false

    static belongsTo = [chapterSection: ChapterSection]

    static constraints = {
        reference blank: false, nullable: false
        text blank: false, maxSize: 2000
        chapterSection nullable: false
    }

    static mapping = {
        version false
        text type: 'text'
    }

    String toString() {
        return reference
    }
}
