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
        Date startDate = sdf.parse("2025-09-10") // Second Wednesday in September
        Date endDate = sdf.parse("2026-05-06")   // First Wednesday in May
        
        Calendar calendar = new Calendar(
            startDate: startDate,
            endDate: endDate,
            dayOfWeek: "Wednesday",
            startTime: java.time.LocalTime.of(1, 0),
            endTime: java.time.LocalTime.of(23, 0),
            description: "Awana 2025-2026 School Year"
        ).save(failOnError: true)
        
        log.info("Created calendar: ${calendar}")
        return calendar
    }

    private Map<String, Club> createAwanaClubs() {
        Map<String, Club> clubs = [:]

        clubs.puggles = new Club(
            name: "Puggles",
            ageRange: "Ages 2-3",
            description: "Toddler program introducing basic Bible concepts"
        ).save(failOnError: true)

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

        // Puggles Books
        createPugglesBooks(clubs.puggles)

        // Cubbies Books
        createCubbiesBooks(clubs.cubbies)

        // Sparks Books
        createSparksBooks(clubs.sparks)

        // T&T Books
        createTTBooks(clubs.tt)

        // Trek Books
        createTrekBooks(clubs.trek)
    }

    private void createPugglesBooks(Club club) {
        Book book = new Book(
            name: "First Steps",
            club: club,
            isPrimary: true
        ).save(failOnError: true)

        // Create chapters for Puggles
        createChapter(book, 1, "God Loves Me")
        createChapter(book, 2, "Jesus Is My Friend")
        createChapter(book, 3, "I Can Pray")
        createChapter(book, 4, "Bible Time")

        log.info("Created Puggles book: ${book.name}")
    }

    private void createCubbiesBooks(Club club) {
        Book honeyComb = new Book(
            name: "HoneyComb",
            club: club,
            isPrimary: true
        ).save(failOnError: true)

        // Create chapters for HoneyComb with specific structure
        createHoneyCombChapters(honeyComb)

        log.info("Created Cubbies book: HoneyComb")
    }

    private void createSparksBooks(Club club) {
        Book wingRunner = new Book(
            name: "Wing Runner",
            club: club,
            isPrimary: true
        ).save(failOnError: true)

        // Create chapters for Wing Runner with specific structure
        createWingRunnerChapters(wingRunner)

        log.info("Created Sparks book: Wing Runner")
    }

    private void createTTBooks(Club club) {
        Book agentsOfGrace = new Book(
            name: "Agents of Grace",
            club: club,
            isPrimary: true
        ).save(failOnError: true)

        // Create chapters for Agents of Grace with specific structure
        createAgentsOfGraceChapters(agentsOfGrace)

        log.info("Created T&T book: Agents of Grace")
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
        
        // Create sections numbered like 1.1, 1.2, 1.3, etc.
        createChapterSection(chapter, "${chapterNumber}.1", "Introduction")
        createChapterSection(chapter, "${chapterNumber}.2", "Bible Story") 
        createChapterSection(chapter, "${chapterNumber}.3", "Memory Verse")
        createChapterSection(chapter, "${chapterNumber}.4", "Application")
        createChapterSection(chapter, "${chapterNumber}.5", "Review Questions")
        createChapterSection(chapter, "${chapterNumber}.6", "Prayer Time")
        createChapterSection(chapter, "${chapterNumber}.7", "Closing Activity")
        
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

        // Baggett Family
        Household baggettFamily = new Household(
            name: "Baggett Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "123 Maple Street, Anytown ST 12345",
            phoneNumber: "780-233-1702",
            email: "baggett.family@email.com"
        ).save(failOnError: true)

        createStudent("Aiden", "Baggett", "2021-05-06", baggettFamily, clubs.find { it.name == "Cubbies" })
        createStudent("Owen", "Baggett", "2023-04-27", baggettFamily, clubs.find { it.name == "Puggles" })

        // Brownlee Family
        Household brownleeFamily = new Household(
            name: "Brownlee Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "456 Oak Avenue, Anytown ST 12345",
            phoneNumber: "210-535-9544",
            email: "brownlee.family@email.com"
        ).save(failOnError: true)

        createStudent("Peter", "Brownlee", "2022-08-02", brownleeFamily, clubs.find { it.name == "Cubbies" })
        createStudent("Makeo", "Brownlee", "2024-05-19", brownleeFamily, clubs.find { it.name == "Puggles" })

        // Burkhead Family
        Household burkheadFamily = new Household(
            name: "Burkhead Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "789 Pine Road, Anytown ST 12345",
            phoneNumber: "815-708-2232",
            email: "burkhead.family@email.com"
        ).save(failOnError: true)

        createStudent("Caleb", "Burkhead", "2022-04-04", burkheadFamily, clubs.find { it.name == "Cubbies" })
        createStudent("Jemma", "Burkhead", "2019-08-30", burkheadFamily, clubs.find { it.name == "Sparks" })
        createStudent("Noah", "Burkhead", "2016-10-31", burkheadFamily, clubs.find { it.name == "Truth & Training" })

        // Dominguez Family
        Household dominguezFamily = new Household(
            name: "Dominguez Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "321 Cedar Lane, Anytown ST 12345",
            phoneNumber: "830-358-9834",
            email: "dominguez.family@email.com"
        ).save(failOnError: true)

        createStudent("Audrey", "Dominguez", "2016-08-16", dominguezFamily, clubs.find { it.name == "Truth & Training" })
        createStudent("Laiken", "Dominguez", "2014-09-23", dominguezFamily, clubs.find { it.name == "Truth & Training" })

        // Davis Family
        Household davisFamily = new Household(
            name: "Davis Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "654 Birch Street, Anytown ST 12345",
            phoneNumber: "210-627-8093",
            email: "davis.family@email.com"
        ).save(failOnError: true)

        createStudent("Zao", "Davis", "2018-09-29", davisFamily, clubs.find { it.name == "Sparks" })

        // Halley Family
        Household halleyFamily = new Household(
            name: "Halley Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "987 Elm Drive, Anytown ST 12345",
            phoneNumber: "832-970-1545",
            email: "halley.family@email.com"
        ).save(failOnError: true)

        createStudent("James", "Halley", "2018-12-01", halleyFamily, clubs.find { it.name == "Sparks" })
        createStudent("Johnathan", "Halley", "2017-03-27", halleyFamily, clubs.find { it.name == "Truth & Training" })

        // Johnson Family 1 (Emily & Philip) - Only Ashley
        Household johnson1Family = new Household(
            name: "Johnson Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "111 Willow Way, Anytown ST 12345",
            phoneNumber: "210-852-6501",
            email: "johnson.emilyandphilip@email.com"
        ).save(failOnError: true)

        createStudent("Ashley", "Johnson", "2017-03-17", johnson1Family, clubs.find { it.name == "Truth & Training" })

        // Johnson Family 2 (Derick & Joanna) - Amethyst, Avalon, Sebastian, Tatiana
        Household johnson2Family = new Household(
            name: "Johnson Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "222 Oak Heights, Anytown ST 12345",
            phoneNumber: "520-686-1088",
            email: "johnson.derickandjoanna@email.com"
        ).save(failOnError: true)

        createStudent("Amethyst", "Johnson", "2017-03-11", johnson2Family, clubs.find { it.name == "Truth & Training" })
        createStudent("Avalon", "Johnson", "2020-08-11", johnson2Family, clubs.find { it.name == "Sparks" })
        createStudent("Sebastian", "Johnson", "2018-09-10", johnson2Family, clubs.find { it.name == "Sparks" })
        createStudent("Tatiana", "Johnson", "2016-10-24", johnson2Family, clubs.find { it.name == "Truth & Training" })

        // Leland Family
        Household lelandFamily = new Household(
            name: "Leland Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "333 Maple Grove, Anytown ST 12345",
            phoneNumber: "940-447-3847",
            email: "leland.family@email.com"
        ).save(failOnError: true)

        createStudent("Theo", "Leland", "2019-09-23", lelandFamily, clubs.find { it.name == "Sparks" })

        // Madden Family
        Household maddenFamily = new Household(
            name: "Madden Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "444 Pine Circle, Anytown ST 12345",
            phoneNumber: "918-706-7813",
            email: "madden.family@email.com"
        ).save(failOnError: true)

        createStudent("Lucy", "Madden", "2017-12-07", maddenFamily, clubs.find { it.name == "Truth & Training" })

        // Oliver Family
        Household oliverFamily = new Household(
            name: "Oliver Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "555 Cherry Lane, Anytown ST 12345",
            phoneNumber: "210-296-1071",
            email: "oliver.family@email.com"
        ).save(failOnError: true)

        createStudent("Harrison", "Oliver", "2018-09-07", oliverFamily, clubs.find { it.name == "Sparks" })

        // Padilla Family
        Household padillaFamily = new Household(
            name: "Padilla Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "666 Aspen Drive, Anytown ST 12345",
            phoneNumber: "940-704-2190",
            email: "padilla.family@email.com"
        ).save(failOnError: true)

        createStudent("Maeve", "Padilla", "2021-02-03", padillaFamily, clubs.find { it.name == "Cubbies" })
        createStudent("Violet", "Padilla", "2021-02-03", padillaFamily, clubs.find { it.name == "Cubbies" })

        // Ramirez Family
        Household ramirezFamily = new Household(
            name: "Ramirez Family",
            qrCode: "HH-${UUID.randomUUID().toString().substring(0, 8).toUpperCase()}",
            address: "777 Spruce Court, Anytown ST 12345",
            phoneNumber: "210-542-1346",
            email: "ramirez.family@email.com"
        ).save(failOnError: true)

        createStudent("Abraham", "Ramirez", "2024-02-19", ramirezFamily, clubs.find { it.name == "Puggles" })
        createStudent("Emma", "Ramirez", "2021-02-06", ramirezFamily, clubs.find { it.name == "Cubbies" })

        log.info("Created 15 families with 30 students")
    }

    private Student createStudent(String firstName, String lastName, String birthDate, Household household, Club club) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        Date dateOfBirth = sdf.parse(birthDate)
        
        Student student = new Student(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            household: household,
            club: club,
            isActive: true
        ).save(failOnError: true)
        
        // Create SectionVerseCompletion records for each section of each chapter in the club's books
        createSectionVerseCompletions(student, club)
        
        return student
    }
    
    private void createSectionVerseCompletions(Student student, Club club) {
        // Get all books for this club
        def books = Book.findAllByClub(club)
        
        books.each { book ->
            // Get all chapters for this book (will be sorted by chapterNumber due to domain mapping)
            book.chapters.each { chapter ->
                // Get all sections for this chapter (will be sorted by sectionNumber due to domain mapping)
                chapter.chapterSections.each { section ->
                    // Create a SectionVerseCompletion record for this student and section
                    new SectionVerseCompletion(
                        student: student,
                        chapterSection: section,
                        studentCompleted: false,
                        parentCompleted: false,
                        silverSectionCompleted: false,
                        goldSectionCompleted: false,
                        bucksEarned: 0
                    ).save(failOnError: true)
                }
            }
        }
        
        log.info("Created SectionVerseCompletion records for student: ${student.firstName} ${student.lastName}")
    }

    private void createWingRunnerChapters(Book book) {
        // WingRunner Rank (Chapter)
        Chapter wingRunnerRank = new Chapter(
            book: book,
            chapterNumber: 1,
            name: "WingRunner Rank"
        ).save(failOnError: true)

        createChapterSectionWithVerse(wingRunnerRank, "Rank 1", "John 3:16", "John 3:16")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 2", "S is for Savior and P is for Power", "1 John 4:14, Psalm 147:5")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 3", "A is for Accordance and R is for Raised", "1 Corinthians 15:3, 1 Corinthians 15:4")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 4", "K is for Keep and S is for Saved", "James 2:10, Acts 16:31")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 5", "Prayer", "John 20:3, Psalm 118:1")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 6", "Eternal Life", "Romans 6:23")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 7", "New Testament Books Puzzle", "All NT books")
        createChapterSectionWithVerse(wingRunnerRank, "Rank 8", "New Testament Books", "All NT books")

        // Red Jewel 1 (Chapter)
        Chapter redJewel1 = new Chapter(
            book: book,
            chapterNumber: 2,
            name: "Red Jewel 1"
        ).save(failOnError: true)

        createChapterSectionWithVerse(redJewel1, "1:1", "Bring a Friend", "N/A")
        createChapterSectionWithVerse(redJewel1, "1:2", "Deborah: A Mother in Israel", "Deuteronomy 6:5, Psalm 96:2")
        createChapterSectionWithVerse(redJewel1, "1:3", "Samson: The Strong Judge", "Jeremiah 32:27, Leviticus 19:2")
        createChapterSectionWithVerse(redJewel1, "1:4", "Samuel: The Listening Prophet", "Proverbs 20:11")

        // Green Jewel 1 (Chapter)
        Chapter greenJewel1 = new Chapter(
            book: book,
            chapterNumber: 3,
            name: "Green Jewel 1"
        ).save(failOnError: true)

        createChapterSectionWithVerse(greenJewel1, "1:1", "David: The Shepherd King", "Psalm 23:1-3")
        createChapterSectionWithVerse(greenJewel1, "1:2", "Solomon: The Wise King", "Psalm 23:4-5")
        createChapterSectionWithVerse(greenJewel1, "1:3", "Elijah: The Running Prophet", "Psalm 23:6, 1 Peter 5:7")
        createChapterSectionWithVerse(greenJewel1, "1:4", "Psalm 23", "Psalm 23:1-6")

        // Red Jewel 2 (Chapter)
        Chapter redJewel2 = new Chapter(
            book: book,
            chapterNumber: 4,
            name: "Red Jewel 2"
        ).save(failOnError: true)

        createChapterSectionWithVerse(redJewel2, "2:1", "A Friend From Far Away", "N/A")
        createChapterSectionWithVerse(redJewel2, "2:2", "A Very Different Sparks Club", "N/A")
        createChapterSectionWithVerse(redJewel2, "2:3", "Not That Different After All", "Mark 16:15")
        createChapterSectionWithVerse(redJewel2, "2:4", "Tell Everybody!", "N/A")

        // Green Jewel 2 (Chapter)
        Chapter greenJewel2 = new Chapter(
            book: book,
            chapterNumber: 5,
            name: "Green Jewel 2"
        ).save(failOnError: true)

        createChapterSectionWithVerse(greenJewel2, "2:1", "Josiah: Lover of God's Word", "1 Peter 1:25")
        createChapterSectionWithVerse(greenJewel2, "2:2", "Daniel: The Praying Prophet", "1 Thessalonians 5:17-18")
        createChapterSectionWithVerse(greenJewel2, "2:3", "Nehemiah: God's Workman", "Colossians 3:23")
        createChapterSectionWithVerse(greenJewel2, "2:4", "Return Flight", "Romans 6:23, Deuteronomy 6:5, 1 Thessalonians 5:17-18")

        // Red Jewel 3 (Chapter)
        Chapter redJewel3 = new Chapter(
            book: book,
            chapterNumber: 6,
            name: "Red Jewel 3"
        ).save(failOnError: true)

        createChapterSectionWithVerse(redJewel3, "3:1", "Facts About the Bible", "OT and NT Bible Facts")
        createChapterSectionWithVerse(redJewel3, "3:2", "Old Testament Books", "First 5 OT Books")
        createChapterSectionWithVerse(redJewel3, "3:3", "Old Testament Books", "Next 7 OT Books")
        createChapterSectionWithVerse(redJewel3, "3:4", "Old Testament Books", "Next 8 OT Books")

        // Green Jewel 3 (Chapter)
        Chapter greenJewel3 = new Chapter(
            book: book,
            chapterNumber: 7,
            name: "Green Jewel 3"
        ).save(failOnError: true)

        createChapterSectionWithVerse(greenJewel3, "3:1", "Old Testament Books", "Next 7 OT Books")
        createChapterSectionWithVerse(greenJewel3, "3:2", "Old Testament Books", "Next 7 OT Books")
        createChapterSectionWithVerse(greenJewel3, "3:3", "Old Testament Books", "Next 5 OT Books")
        createChapterSectionWithVerse(greenJewel3, "3:4", "Old Testament Books", "All OT Books")

        // Red Jewel 4 (Chapter)
        Chapter redJewel4 = new Chapter(
            book: book,
            chapterNumber: 8,
            name: "Red Jewel 4"
        ).save(failOnError: true)

        createChapterSectionWithVerse(redJewel4, "4:1", "The Priest Who Didn't Believe", "John 1:1")
        createChapterSectionWithVerse(redJewel4, "4:2", "Mary: Handmaiden Who Believed", "John 1:2")
        createChapterSectionWithVerse(redJewel4, "4:3", "Shepherds Tell the Good News", "John 1:3")
        createChapterSectionWithVerse(redJewel4, "4:4", "John 1:1-3", "John 1:1-3")

        // Green Jewel 4 (Chapter)
        Chapter greenJewel4 = new Chapter(
            book: book,
            chapterNumber: 9,
            name: "Green Jewel 4"
        ).save(failOnError: true)

        createChapterSectionWithVerse(greenJewel4, "4:1", "Ephesians 4:32", "Ephesians 4:32")
        createChapterSectionWithVerse(greenJewel4, "4:2", "Philippians 2:14", "Philippians 2:14")
        createChapterSectionWithVerse(greenJewel4, "4:3", "Good Attitude Rules", "Good Attitude Rules")
        createChapterSectionWithVerse(greenJewel4, "4:4", "Return Flight", "1 Peter 5:7, Mark 16:15, Col. 3:23, Eph. 4:32, Phil. 2:14")
    }

    private void createAgentsOfGraceChapters(Book book) {
        // Unit 1 - God is...
        Chapter unit1 = new Chapter(
            book: book,
            chapterNumber: 1,
            name: "Unit 1 - God is..."
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit1, "1.1", "God is our Savior", "Titus 3:4-5")
        createChapterSectionWithVerse(unit1, "1.2", "God is our Hope", "Romans 15:13")
        createChapterSectionWithVerse(unit1, "1.3", "God the Son is our Advocate", "1 John 2:1")
        createChapterSectionWithVerse(unit1, "1.4", "God is our Strength", "Psalm 46:1")
        createChapterSectionWithVerse(unit1, "1.5", "God is our Peace", "John 16:33")
        createChapterSectionWithVerse(unit1, "1.6", "Unit 1 Review", "All Above")

        // Unit 2 - The Bible
        Chapter unit2 = new Chapter(
            book: book,
            chapterNumber: 2,
            name: "Unit 2 - The Bible"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit2, "2.1", "The Bible is God's Revelation", "Romans 1:20")
        createChapterSectionWithVerse(unit2, "2.2", "The Bible is God's Inspired Word", "2 Timothy 3:16")
        createChapterSectionWithVerse(unit2, "2.3", "The Bible Lights Our Path", "John 14:26")
        createChapterSectionWithVerse(unit2, "2.4", "The Bible is True and Useful", "Psalm 12:6")
        createChapterSectionWithVerse(unit2, "2.5", "The Bible is the Standard", "2 Peter 3:2")
        createChapterSectionWithVerse(unit2, "2.6", "The Bible is Trustworthy", "2 Peter 1:16")
        createChapterSectionWithVerse(unit2, "2.7", "The Bible is Helpful to Correct", "Hebrews 4:12")
        createChapterSectionWithVerse(unit2, "2.8", "Unit 2 Review", "All Above")

        // Unit 3 - Jesus... I AM
        Chapter unit3 = new Chapter(
            book: book,
            chapterNumber: 3,
            name: "Unit 3 - Jesus... I AM"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit3, "3.1", "I Am The Bread of Life", "John 6:35")
        createChapterSectionWithVerse(unit3, "3.2", "I Am The Light of the World", "John 8:12")
        createChapterSectionWithVerse(unit3, "3.3", "I Am The Door", "John 10:7")
        createChapterSectionWithVerse(unit3, "3.4", "I Am The Good Shepherd", "John 10:14")
        createChapterSectionWithVerse(unit3, "3.5", "I Am The Resurrection and the Life", "John 11:25")
        createChapterSectionWithVerse(unit3, "3.6", "I Am The Way, The Truth, and the Life", "John 14:6")
        createChapterSectionWithVerse(unit3, "3.7", "I Am The True Vine", "John 15:1")
        createChapterSectionWithVerse(unit3, "3.8", "Unit 3 Review", "All Above")

        // Unit 4 - Agents of...
        Chapter unit4 = new Chapter(
            book: book,
            chapterNumber: 4,
            name: "Unit 4 - Agents of..."
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit4, "4.1", "Agents of Courage", "Joshua 1:9")
        createChapterSectionWithVerse(unit4, "4.2", "Agents of Humility", "Philippians 2:3")
        createChapterSectionWithVerse(unit4, "4.3", "Agents of Wisdom", "James 1:5")
        createChapterSectionWithVerse(unit4, "4.4", "Agents of Obedience", "John 14:15")
        createChapterSectionWithVerse(unit4, "4.5", "Agents of Honor", "Romans 12:10")
        createChapterSectionWithVerse(unit4, "4.6", "Agents of Hope", "Psalm 43:5")
        createChapterSectionWithVerse(unit4, "4.7", "Agents of Grace", "1 Corinthians 15:10")
        createChapterSectionWithVerse(unit4, "4.8", "Unit 4 Review", "All Above")
    }

    private void createHoneyCombChapters(Book book) {
        // Apple Acres Entrance Booklet (Chapter)
        Chapter appleAcres = new Chapter(
            book: book,
            chapterNumber: 1,
            name: "Apple Acres Entrance Booklet"
        ).save(failOnError: true)

        createChapterSectionWithVerse(appleAcres, "Bear Hug A", "Parent Night; Cubbies Key Verse", "")
        createChapterSectionWithVerse(appleAcres, "Bear Hug B", "Cubbies Motto", "")

        // Handbook HoneyComb Trail (Chapter)
        Chapter honeyCombTrail = new Chapter(
            book: book,
            chapterNumber: 2,
            name: "Handbook HoneyComb Trail"
        ).save(failOnError: true)

        createChapterSectionWithVerse(honeyCombTrail, "Bear Hug 1", "A Is for All", "")
        createChapterSectionWithVerse(honeyCombTrail, "Bear Hug 2", "C Is for Christ", "")

        // Unit 1: God Is Creator (Chapter)
        Chapter unit1 = new Chapter(
            book: book,
            chapterNumber: 3,
            name: "Unit 1: God Is Creator"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit1, "Bear Hug 3", "Our Magnificent Creator", "")
        createChapterSectionWithVerse(unit1, "Bear Hug 4", "God Created All People and You Too!", "")
        createChapterSectionWithVerse(unit1, "Bear Hug 5", "God Made Your Family!", "")
        createChapterSectionWithVerse(unit1, "Bear Hug 6", "Unit 1 Review", "")

        // Unit 2: God Is the One True God (Chapter)
        Chapter unit2 = new Chapter(
            book: book,
            chapterNumber: 4,
            name: "Unit 2: God Is the One True God"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit2, "Bear Hug 7", "The Israelites Worship God at the Temple", "")
        createChapterSectionWithVerse(unit2, "Bear Hug 8", "Elijah Reminds the Israelites to Worship Only God", "")
        createChapterSectionWithVerse(unit2, "Bear Hug 9", "Shadrach, Meshach and Abednego Worship Only God", "")
        createChapterSectionWithVerse(unit2, "Bear Hug 10", "Unit 2 Review", "")

        // Unit 3: Jesus Is the Good Shepherd (Chapter)
        Chapter unit3 = new Chapter(
            book: book,
            chapterNumber: 5,
            name: "Unit 3: Jesus Is the Good Shepherd"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit3, "Bear Hug 11", "The Good Shepherd Knows and Leads His Sheep", "")
        createChapterSectionWithVerse(unit3, "Bear Hug 12", "The Good Shepherd Looks for Lost Sheep", "")
        createChapterSectionWithVerse(unit3, "Bear Hug 13", "The Good Shepherd Is With Us in Scary Times", "")
        createChapterSectionWithVerse(unit3, "Bear Hug 14", "Unit 3 Review", "")

        // Unit 4: Jesus Loves All People (Chapter)
        Chapter unit4 = new Chapter(
            book: book,
            chapterNumber: 6,
            name: "Unit 4: Jesus Loves All People"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit4, "Bear Hug 15", "Jesus Loves the Paralyzed Man", "")
        createChapterSectionWithVerse(unit4, "Bear Hug 16", "Jesus Loves Two Daughters", "")
        createChapterSectionWithVerse(unit4, "Bear Hug 17", "Jesus Loves the Crowd of 5,000", "")
        createChapterSectionWithVerse(unit4, "Bear Hug 18", "Unit 4 Review", "")

        // Unit 5: Jesus Came to Save Us (Chapter)
        Chapter unit5 = new Chapter(
            book: book,
            chapterNumber: 7,
            name: "Unit 5: Jesus Came to Save Us"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit5, "Bear Hug 19", "Jesus Loves Blind Bartimaeus", "")
        createChapterSectionWithVerse(unit5, "Bear Hug 20", "Jesus Loves Zaccheus", "")
        createChapterSectionWithVerse(unit5, "Bear Hug 21", "Jesus Loves Mary of Bethany", "")
        createChapterSectionWithVerse(unit5, "Bear Hug 22", "Unit 5 Review", "")

        // Unit 6: Jesus Says to Tell the Good News (Chapter)
        Chapter unit6 = new Chapter(
            book: book,
            chapterNumber: 8,
            name: "Unit 6: Jesus Says to Tell the Good News"
        ).save(failOnError: true)

        createChapterSectionWithVerse(unit6, "Bear Hug 23", "Peter and the Disciples Tell the Good News", "")
        createChapterSectionWithVerse(unit6, "Bear Hug 24", "Philip Tells the Good News", "")
        createChapterSectionWithVerse(unit6, "Bear Hug 25", "Paul and Silas Tell the Good News", "")
        createChapterSectionWithVerse(unit6, "Bear Hug 26", "We Can Tell the Good News", "")
    }

    private ChapterSection createChapterSectionWithVerse(Chapter chapter, String sectionNumber, String content, String memoryVerse) {
        return new ChapterSection(
            chapter: chapter,
            sectionNumber: sectionNumber,
            content: content,
            sectionVerse: memoryVerse
        ).save(failOnError: true)
    }
}