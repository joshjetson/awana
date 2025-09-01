package awana

import grails.gorm.transactions.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.password.PasswordEncoder
import java.text.SimpleDateFormat

@Transactional
class BootstrapService {

    @Autowired
    PasswordEncoder passwordEncoder

    def createRoles() {
        // Create admin and user roles if they don't exist
        if (!Role.count()) {
            Role.findOrSaveWhere(authority: 'ROLE_ADMIN')
            Role.findOrSaveWhere(authority: 'ROLE_USER')
        }
    }

    def createDevelopmentUsers() {
        if (!User.count()) {
            User admin = new User(username: 'admin',
                    password: passwordEncoder.encode('admin123'),
                    enabled: true)
            admin.save(failOnError: true)
            UserRole.create(admin, Role.findByAuthority('ROLE_ADMIN'), true)

            User client = new User(username: 'user',
                    password: passwordEncoder.encode('user123'), 
                    enabled: true)
            client.save(failOnError: true)
            UserRole.create(client, Role.findByAuthority('ROLE_USER'), true)
            
            log.info("Created admin user: admin/admin123")
            log.info("Created client user: user/user123")
        }
    }

    def createDefaultAdminUser() {
        // Create default admin user for production
        User admin = new User(username: 'admin',
                password: passwordEncoder.encode('awana2024'),
                enabled: true)
        admin.save(failOnError: true)
        UserRole.create(admin, Role.findByAuthority('ROLE_ADMIN'), true)
        
        log.info("Created production admin user: admin/awana2024")
    }

    def createAwanaData() {
        
        // Create Calendar for current Awana year
        Calendar calendar = createAwanaCalendar()
        
        // Create all Awana clubs
        Map<String, Club> clubs = createAwanaClubs()
        
        // Create books for each club with chapters and sections
        createBooksAndChapters(clubs)
        
        // Create sample households and students
        createSampleFamilies(clubs.values() as List)
        
        log.info("Awana bootstrap data created successfully!")
    }

    private Calendar createAwanaCalendar() {
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        Date startDate = sdf.parse("2024-09-04") // First Wednesday in September
        Date endDate = sdf.parse("2025-05-07")   // First Wednesday in May
        
        Calendar calendar = new Calendar(
            startDate: startDate,
            endDate: endDate,
            dayOfWeek: "Wednesday",
            startTime: java.time.LocalTime.of(18, 30),
            endTime: java.time.LocalTime.of(20, 0),
            description: "Awana 2024-2025 School Year"
        ).save(failOnError: true)
        
        log.info("Created calendar: ${calendar}")
        return calendar
    }

    private Map<String, Club> createAwanaClubs() {
        Map<String, Club> clubs = [:]
        
        clubs.cubbies = new Club(
            name: "Cubbies",
            ageRange: "Ages 4-5",
            description: "Preschool program focusing on basic Bible truths"
        ).save(failOnError: true)
        
        clubs.sparks = new Club(
            name: "Sparks",
            ageRange: "K-2nd Grade", 
            description: "Elementary program building Bible knowledge"
        ).save(failOnError: true)
        
        clubs.tt = new Club(
            name: "Truth & Training",
            ageRange: "Grades 3-6",
            description: "Elementary program emphasizing Bible memorization"
        ).save(failOnError: true)
        
        clubs.trek = new Club(
            name: "Trek",
            ageRange: "Grades 6-8",
            description: "Middle school program for spiritual growth"
        ).save(failOnError: true)
        
        log.info("Created ${clubs.size()} clubs")
        return clubs
    }

    private void createBooksAndChapters(Map<String, Club> clubs) {
        
        // Cubbies Books
        createCubbiesBooks(clubs.cubbies)
        
        // Sparks Books
        createSparksBooks(clubs.sparks)
        
        // T&T Books  
        createTTBooks(clubs.tt)
        
        // Trek Books
        createTrekBooks(clubs.trek)
    }

    private void createCubbiesBooks(Club club) {
        Book book = new Book(
            name: "Bear Hug",
            club: club,
            isPrimary: true
        ).save(failOnError: true)
        
        // Create chapters for Cubbies
        createChapter(book, 1, "God Made Everything")
        createChapter(book, 2, "God Made Me Special")
        createChapter(book, 3, "God Loves Me")
        createChapter(book, 4, "Jesus Is God's Son")
        
        log.info("Created Cubbies book: ${book.name}")
    }

    private void createSparksBooks(Club club) {
        Book hangGlider = new Book(
            name: "HangGlider",
            club: club,
            isPrimary: true
        ).save(failOnError: true)
        
        Book wingRunner = new Book(
            name: "WingRunner", 
            club: club,
            isPrimary: false
        ).save(failOnError: true)
        
        Book skyStormer = new Book(
            name: "SkyStormer",
            club: club,
            isPrimary: false
        ).save(failOnError: true)
        
        // Create chapters for HangGlider
        createChapter(hangGlider, 1, "God")
        createChapter(hangGlider, 2, "Jesus") 
        createChapter(hangGlider, 3, "Salvation")
        createChapter(hangGlider, 4, "The Bible")
        
        log.info("Created Sparks books: HangGlider, WingRunner, SkyStormer")
    }

    private void createTTBooks(Club club) {
        Book book = new Book(
            name: "Ultimate Adventure", 
            club: club,
            isPrimary: true
        ).save(failOnError: true)
        
        // Create chapters for T&T
        createChapter(book, 1, "Starting Line")
        createChapter(book, 2, "God")
        createChapter(book, 3, "Jesus Christ")
        createChapter(book, 4, "Salvation")
        
        log.info("Created T&T book: ${book.name}")
    }

    private void createTrekBooks(Club club) {
        Book book = new Book(
            name: "Into the Wild",
            club: club, 
            isPrimary: true
        ).save(failOnError: true)
        
        // Create chapters for Trek
        createChapter(book, 1, "Faith")
        createChapter(book, 2, "Prayer")
        createChapter(book, 3, "Bible Study")
        
        log.info("Created Trek book: ${book.name}")
    }

    private Chapter createChapter(Book book, Integer chapterNumber, String name) {
        Chapter chapter = new Chapter(
            book: book,
            chapterNumber: chapterNumber,
            name: name
        ).save(failOnError: true)
        
        // Create regular sections
        createChapterSection(chapter, "1", "Introduction")
        createChapterSection(chapter, "2", "Bible Story") 
        createChapterSection(chapter, "3", "Memory Verse")
        createChapterSection(chapter, "4", "Application")
        
        // Create extra sections
        createChapterSection(chapter, "S1", "Extra Activity 1")
        createChapterSection(chapter, "S2", "Extra Activity 2")
        
        // Create advanced sections  
        createChapterSection(chapter, "G1", "Advanced Study")
        createChapterSection(chapter, "G2", "Scripture Memory Challenge")
        
        return chapter
    }

    private ChapterSection createChapterSection(Chapter chapter, String sectionNumber, String content) {
        return new ChapterSection(
            chapter: chapter,
            sectionNumber: sectionNumber,
            content: content
        ).save(failOnError: true)
    }

    private void createSampleFamilies(List<Club> clubs) {
        
        // Johnson Family
        Household johnsonFamily = new Household(
            name: "Johnson Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "123 Maple Street, Anytown ST 12345",
            phoneNumber: "(555) 123-4567", 
            email: "johnson.family@email.com"
        ).save(failOnError: true)
        
        createStudent("Emma", "Johnson", "2018-03-15", johnsonFamily, clubs.find { it.name == "Sparks" })
        createStudent("Liam", "Johnson", "2020-08-22", johnsonFamily, clubs.find { it.name == "Cubbies" })
        
        // Smith Family
        Household smithFamily = new Household(
            name: "Smith Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}", 
            address: "456 Oak Avenue, Anytown ST 12345",
            phoneNumber: "(555) 234-5678",
            email: "smith.family@email.com"
        ).save(failOnError: true)
        
        createStudent("Sophia", "Smith", "2015-11-08", smithFamily, clubs.find { it.name == "Truth & Training" })
        createStudent("Mason", "Smith", "2017-05-12", smithFamily, clubs.find { it.name == "Sparks" })
        
        // Brown Family
        Household brownFamily = new Household(
            name: "Brown Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "789 Pine Road, Anytown ST 12345", 
            phoneNumber: "(555) 345-6789",
            email: "brown.family@email.com"
        ).save(failOnError: true)
        
        createStudent("Olivia", "Brown", "2012-07-18", brownFamily, clubs.find { it.name == "Trek" })
        createStudent("Noah", "Brown", "2014-02-25", brownFamily, clubs.find { it.name == "Truth & Training" })
        createStudent("Ava", "Brown", "2019-09-10", brownFamily, clubs.find { it.name == "Cubbies" })
        
        log.info("Created 3 sample families with 8 students")
    }

    private Student createStudent(String firstName, String lastName, String birthDate, Household household, Club club) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        Date dateOfBirth = sdf.parse(birthDate)
        
        return new Student(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            household: household,
            club: club,
            isActive: true
        ).save(failOnError: true)
    }
}