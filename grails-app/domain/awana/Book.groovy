package awana

class Book {

    String name
    String coverImage
    Boolean isPrimary = false

    static belongsTo = [club: Club]
    static hasMany = [chapters: Chapter]

    static constraints = {
        name blank: false, nullable: false
        coverImage nullable: true
        isPrimary nullable: false
    }

    static mapping = {
        version false
        coverImage type: 'text'
    }

    String toString() {
        return "${name}${isPrimary ? ' (Primary)' : ''}"
    }

    List<Chapter> getOrderedChapters() {
        return chapters?.sort { it.chapterNumber } ?: []
    }

    Integer getTotalChapters() {
        return chapters?.size() ?: 0
    }
}