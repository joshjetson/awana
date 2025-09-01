package awana

class Chapter {

    String name
    Integer chapterNumber
    String chapterImage


    static belongsTo = [book: Book]
    static hasMany = [chapterSections: ChapterSection]

    static constraints = {
        name blank: false, nullable: false
        chapterNumber nullable: false, min: 1
        chapterImage nullable: true
    }

    static mapping = {
        version false
        chapterImage type: 'text'
    }

    String toString() {
        return "Chapter ${chapterNumber}: ${name}"
    }

    List<ChapterSection> getOrderedSections() {
        return chapterSections?.sort { it.sectionNumber } ?: []
    }

    List<ChapterSection> getSilverSections() {
        return chapterSections?.findAll { it.isSilverSection } ?: []
    }

    List<ChapterSection> getGoldSections() {
        return chapterSections?.findAll { it.isGoldSection } ?: []
    }

    Integer getTotalSections() {
        return chapterSections?.size() ?: 0
    }
}