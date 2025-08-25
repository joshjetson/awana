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
            startTime: sdf.parse("1900-01-01 18:30:00"),
            endTime: sdf.parse("1900-01-01 20:00:00"),
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
        createChapter(book, 1, "God Made Everything", "In the beginning God created the heavens and the earth. Genesis 1:1", "The Lord God made them all. Psalm 104:24")
        createChapter(book, 2, "God Made Me Special", "I praise you because I am fearfully and wonderfully made. Psalm 139:14", "Children are a heritage from the Lord. Psalm 127:3")
        createChapter(book, 3, "God Loves Me", "God so loved the world that he gave his one and only Son. John 3:16", "See what great love the Father has lavished on us. 1 John 3:1")
        createChapter(book, 4, "Jesus Is God's Son", "For God so loved the world that he gave his one and only Son. John 3:16", "This is my Son, whom I love. Matthew 3:17")
        
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
        createChapter(hangGlider, 1, "God", "In the beginning God created the heavens and the earth. Genesis 1:1", "Great is the Lord and most worthy of praise. Psalm 96:4")
        createChapter(hangGlider, 2, "Jesus", "For God so loved the world that he gave his one and only Son. John 3:16", "Jesus Christ is the same yesterday and today and forever. Hebrews 13:8") 
        createChapter(hangGlider, 3, "Salvation", "For all have sinned and fall short of the glory of God. Romans 3:23", "If we confess our sins, he is faithful and just. 1 John 1:9")
        createChapter(hangGlider, 4, "The Bible", "All Scripture is God-breathed and is useful for teaching. 2 Timothy 3:16", "Your word is a lamp for my feet. Psalm 119:105")
        
        log.info("Created Sparks books: HangGlider, WingRunner, SkyStormer")
    }

    private void createTTBooks(Club club) {
        Book book = new Book(
            name: "Ultimate Adventure", 
            club: club,
            isPrimary: true
        ).save(failOnError: true)
        
        // Create chapters for T&T
        createChapter(book, 1, "Starting Line", "In the beginning was the Word, and the Word was with God, and the Word was God. John 1:1", "These are written that you may believe. John 20:31")
        createChapter(book, 2, "God", "I am the Alpha and the Omega, says the Lord God. Revelation 1:8", "Great is the Lord and most worthy of praise. Psalm 145:3")
        createChapter(book, 3, "Jesus Christ", "And we know that the Son of God has come. 1 John 5:20", "Jesus Christ is the same yesterday and today and forever. Hebrews 13:8")
        createChapter(book, 4, "Salvation", "For it is by grace you have been saved, through faith. Ephesians 2:8", "Everyone who calls on the name of the Lord will be saved. Romans 10:13")
        
        log.info("Created T&T book: ${book.name}")
    }

    private void createTrekBooks(Club club) {
        Book book = new Book(
            name: "Into the Wild",
            club: club, 
            isPrimary: true
        ).save(failOnError: true)
        
        // Create chapters for Trek
        createChapter(book, 1, "Faith", "Now faith is confidence in what we hope for. Hebrews 11:1", "Without faith it is impossible to please God. Hebrews 11:6")
        createChapter(book, 2, "Prayer", "This, then, is how you should pray: 'Our Father in heaven...' Matthew 6:9", "Pray continually. 1 Thessalonians 5:17")
        createChapter(book, 3, "Bible Study", "All Scripture is God-breathed and is useful for teaching. 2 Timothy 3:16", "Study to show yourself approved. 2 Timothy 2:15")
        
        log.info("Created Trek book: ${book.name}")
    }

    private Chapter createChapter(Book book, Integer chapterNumber, String name, String sectionVerse, String parentVerse) {
        Chapter chapter = new Chapter(
            book: book,
            chapterNumber: chapterNumber,
            name: name,
            sectionVerse: sectionVerse,
            parentVerse: parentVerse
        ).save(failOnError: true)
        
        // Create regular sections
        createChapterSection(chapter, "1", "Introduction", false, false)
        createChapterSection(chapter, "2", "Bible Story", false, false) 
        createChapterSection(chapter, "3", "Memory Verse", false, false)
        createChapterSection(chapter, "4", "Application", false, false)
        
        // Create silver sections
        createChapterSection(chapter, "S1", "Extra Activity 1", true, false)
        createChapterSection(chapter, "S2", "Extra Activity 2", true, false)
        
        // Create gold sections  
        createChapterSection(chapter, "G1", "Advanced Study", false, true)
        createChapterSection(chapter, "G2", "Scripture Memory Challenge", false, true)
        
        return chapter
    }

    private ChapterSection createChapterSection(Chapter chapter, String sectionNumber, String content, Boolean isSilver, Boolean isGold) {
        return new ChapterSection(
            chapter: chapter,
            sectionNumber: sectionNumber,
            content: content,
            isSilverSection: isSilver,
            isGoldSection: isGold
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