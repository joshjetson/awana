package awana

class Household {

    String name
    String qrCode
    String address
    String phoneNumber
    String email

    static hasMany = [students: Student]

    static constraints = {
        name blank: false, nullable: false
        qrCode blank: false, nullable: false, unique: true
        address nullable: true
        phoneNumber nullable: true
        email nullable: true, email: true
    }

    static mapping = {
        version false
        qrCode index: true
    }

    String toString() {
        return name
    }

    List<Student> getAllStudents() {
        return students ? students.sort { it.firstName } : []
    }

    Integer getTotalFamilyBucks() {
        return students?.sum { it.calculateTotalBucks() } ?: 0
    }

    def beforeInsert() {
        if (!qrCode) {
            qrCode = generateQrCode()
        }
    }

    private String generateQrCode() {
        return "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}"
    }
}