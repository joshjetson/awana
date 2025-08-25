package awana

class Club {

    String name
    String ageRange
    String description

    static hasMany = [students: Student, books: Book]

    static constraints = {
        name blank: false, nullable: false, unique: true
        ageRange blank: false, nullable: false
        description nullable: true
    }

    static mapping = {
        version false
    }

    String toString() {
        return "${name} (${ageRange})"
    }

    Book getPrimaryBook() {
        return books?.find { it.isPrimary } ?: books?.first()
    }

    List<Student> getActiveStudents() {
        return students?.findAll { it.isActive } ?: []
    }
}