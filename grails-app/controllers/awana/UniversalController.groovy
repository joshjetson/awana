package awana

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.GrailsNameUtils
import groovy.time.TimeCategory
import java.text.SimpleDateFormat

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class UniversalController {

    UniversalDataService universalDataService
    
    def parseDate(String value) {
        if (!value) return null
        try {
            // Handle yyyy-MM-dd format (most common and safest)
            if (value ==~ /^\d{4}-\d{2}-\d{2}$/) {
                return new SimpleDateFormat('yyyy-MM-dd').parse(value)
            }
            // Handle ISO format from FullCalendar (extract date part safely)
            if (value.contains('T') && value.split('T')[0] ==~ /^\d{4}-\d{2}-\d{2}$/) {
                String datePart = value.split('T')[0]
                return new SimpleDateFormat('yyyy-MM-dd').parse(datePart)
            }
            // For everything else, use Groovy's built-in Date.parse() which handles most formats
            return Date.parse(value)
        } catch (Exception e) {
            log.warn("Date parse failed for value: ${value}, using current date")
            return new Date() // Return current date as fallback
        }
    }

    /**
     * Dynamic view rendering map using closures
     * Frontend can specify viewType and context to render specific views
     */
    private def viewRenderMap = [
        'checkInFamily': { params ->
            String qrCode = params.qrCode ?: params.householdId
            
            if (!qrCode) {
                throw new IllegalArgumentException("QR Code or household ID required")
            }

            def household = Household.findByQrCode(qrCode) ?: Household.get(qrCode)
            if (!household) {
                throw new IllegalArgumentException("Family not found")
            }

            def students = household.getAllStudents()
            def today = new Date()
            def attendanceMap = [:]
            
            students.each { student ->
                def todaysAttendance = Attendance.findByStudentAndAttendanceDate(student, today)
                attendanceMap[student.id] = todaysAttendance
            }

            return [
                template: 'checkin/familyCheckIn',
                model: [
                    household: household,
                    students: students, 
                    attendanceMap: attendanceMap,
                    today: today
                ]
            ]
        },
        'studentSearch': { params ->
            def clubs = universalDataService.list(Club)
            def students = []
            def title = "Student Search"
            def filter = params.filter
            def showAll = params.showAll == 'true'
            
            if (showAll) {
                students = universalDataService.list(Student)
                title = "All Students"
            } else if (filter) {
                switch (filter) {
                    case 'topPerformers':
                        students = Student.list().sort { -it.calculateTotalBucks() }.take(10)
                        title = "Top Performers"
                        break
                    case 'recentCompletions':
                        def recentCompletions = SectionVerseCompletion.findAll(
                            "FROM SectionVerseCompletion WHERE completionDate >= :weekAgo ORDER BY completionDate DESC",
                            [weekAgo: new Date() - 7]
                        ).take(20)
                        students = recentCompletions.collect { it.student }.unique()
                        title = "Recent Verse Completions"
                        break
                    case 'needsAttention':
                        students = Student.list().findAll { it.calculateTotalBucks() < 5 }
                        title = "Students Needing Attention"
                        break
                }
            }
            
            // If showing filtered results, use the simple student list template
            if (showAll || filter) {
                return [
                    template: 'students/studentList',
                    model: [
                        students: students,
                        title: title
                    ]
                ]
            } else {
                // Otherwise show the full search interface
                return [
                    template: 'students/studentSearch',
                    model: [
                        clubs: clubs,
                        studentCount: universalDataService.count(Student)
                    ]
                ]
            }
        },
        'verseCompletion': { params ->
            Long studentId = params.long('studentId')
            String clubId = params.clubId
            
            def students = []
            def selectedStudent = null
            
            if (studentId) {
                selectedStudent = universalDataService.getById(Student, studentId)
                students = [selectedStudent]
            } else if (clubId) {
                def club = universalDataService.getById(Club, Long.valueOf(clubId))
                students = club?.students ?: []
            } else {
                students = universalDataService.list(Student)
            }

            // Get available chapters for verse completion
            def clubs = universalDataService.list(Club)
            def chapters = []
            
            // Get all chapters from all books across all clubs for now
            clubs.each { club ->
                club.books?.each { book ->
                    chapters.addAll(book.chapters ?: [])
                }
            }

            return [
                template: 'books/verseCompletion',
                model: [
                    students: students,
                    selectedStudent: selectedStudent,
                    clubs: clubs,
                    chapters: chapters
                ]
            ]
        },
        'studentProgress': { params ->
            Long studentId = params.long('studentId')
            
            if (!studentId) {
                throw new IllegalArgumentException("Student ID required")
            }
            
            def student = universalDataService.getById(Student, studentId)
            if (!student) {
                throw new IllegalArgumentException("Student not found")
            }

            def completedSections = student.getCompletedSections()
            def attendanceHistory = student.attendances?.sort { -it.attendanceDate.time }
            def attendancePercentage = student.getAttendancePercentage()

            return [
                template: 'students/studentProgress',
                model: [
                    student: student,
                    completedSections: completedSections,
                    attendanceHistory: attendanceHistory,
                    attendancePercentage: attendancePercentage
                ]
            ]
        },
        'storeTransaction': { params ->
            Long studentId = params.long('studentId')
            String action = params.action // 'browse', 'purchase', 'balance'
            
            def student = null
            if (studentId) {
                student = universalDataService.getById(Student, studentId)
            }

            // Mock store items (in real app these would be in database)
            def storeItems = [
                [id: 1, name: 'Candy Bar', price: 2, category: 'Snacks', inStock: true],
                [id: 2, name: 'Small Toy', price: 5, category: 'Toys', inStock: true],
                [id: 3, name: 'Bible Stickers', price: 1, category: 'Stickers', inStock: true],
                [id: 4, name: 'Pencil', price: 3, category: 'School Supplies', inStock: true],
                [id: 5, name: 'Big Prize', price: 15, category: 'Special', inStock: true]
            ]

            return [
                template: 'shared/storeTransaction', 
                model: [
                    student: student,
                    storeItems: storeItems,
                    action: action ?: 'browse'
                ]
            ]
        },
        'clubOverview': { params ->
            Long clubId = params.long('clubId')
            
            def club = null
            def students = []
            
            if (clubId) {
                club = universalDataService.getById(Club, clubId)
                students = club?.students?.toList() ?: []
            }

            def clubs = universalDataService.list(Club)

            return [
                template: 'clubs/clubOverview',
                model: [
                    club: club,
                    clubs: clubs,
                    students: students
                ]
            ]
        },
        'attendanceRecord': { params ->
            String dateStr = params.date ?: new Date().format('yyyy-MM-dd')
            Date selectedDate = Date.parse('yyyy-MM-dd', dateStr)
            Long clubId = params.long('clubId')
            
            def club = null
            def attendanceRecords = []
            
            if (clubId) {
                club = universalDataService.getById(Club, clubId)
                attendanceRecords = Attendance.findAllByAttendanceDateAndStudentInList(
                    selectedDate, 
                    club.getActiveStudents()
                )
            } else {
                attendanceRecords = Attendance.findAllByAttendanceDate(selectedDate)
            }

            def clubs = universalDataService.list(Club)

            return [
                template: 'checkin/attendanceRecord',
                model: [
                    selectedDate: selectedDate,
                    club: club,
                    clubs: clubs,
                    attendanceRecords: attendanceRecords
                ]
            ]
        },
        'clubs': { params ->
            def clubs = universalDataService.list(Club)
            return [
                template: 'clubs/clubs',
                model: [clubs: clubs, clubCount: clubs.size()]
            ]
        },
        'attendance': { params ->
            def calendar = Calendar.list([sort: 'id', order: 'desc'])?.find() // Get the most recent calendar
            def clubs = universalDataService.list(Club)
            def totalStudents = universalDataService.count(Student)
            
            // Calculate real attendance metrics
            def attendanceMetrics = [:]
            if (calendar) {
                use(TimeCategory) {
                    // Get current month meetings
                    def currentMonthEnd = new Date()
                    def currentMonthStart = currentMonthEnd - 30.days
                    
                    // Count meetings this month
                    def allAttendances = Attendance.findAll()
                    def thisMonthAttendances = allAttendances.findAll { attendance ->
                        attendance.attendanceDate >= currentMonthStart && attendance.attendanceDate <= currentMonthEnd
                    }
                    
                    // Calculate metrics
                    def totalMeetingDates = thisMonthAttendances.collect { it.attendanceDate.format('yyyy-MM-dd') }.unique()
                    attendanceMetrics.totalMeetings = totalMeetingDates.size()
                    attendanceMetrics.meetingsCompleted = totalMeetingDates.size()
                    
                    if (thisMonthAttendances.size() > 0) {
                        def presentCount = thisMonthAttendances.count { it.present }
                        attendanceMetrics.averageAttendance = (presentCount / thisMonthAttendances.size()) * 100
                    } else {
                        attendanceMetrics.averageAttendance = 0
                    }
                }
            }
            
            // Calculate club-specific attendance rates for sidebar
            def clubAttendanceRates = [:]
            clubs.each { club ->
                def clubStudents = club.students?.toList() ?: []
                if (clubStudents.size() > 0) {
                    // Calculate overall attendance rate for this club (last 30 days)
                    def thirtyDaysAgo
                    use(TimeCategory) {
                        thirtyDaysAgo = new Date() - 30.days
                    }
                    def recentAttendances = []
                    
                    clubStudents.each { student ->
                        def studentAttendances = student.attendances?.findAll { 
                            it.attendanceDate > thirtyDaysAgo 
                        } ?: []
                        recentAttendances.addAll(studentAttendances)
                    }
                    
                    if (recentAttendances.size() > 0) {
                        def presentCount = recentAttendances.count { it.present }
                        def rate = Math.round((presentCount / recentAttendances.size()) * 100)
                        clubAttendanceRates[club.id] = rate
                    } else {
                        clubAttendanceRates[club.id] = 0
                    }
                } else {
                    clubAttendanceRates[club.id] = 0
                }
            }
            
            return [
                template: 'attendance/attendance',
                model: [
                    calendar: calendar,
                    clubs: clubs,
                    totalStudents: totalStudents,
                    attendanceMetrics: attendanceMetrics,
                    clubAttendanceRates: clubAttendanceRates
                ]
            ]
        },
        'calendarSetup': { params ->
            // Always get the most recent calendar for editing
            def calendar = Calendar.list([sort: 'id', order: 'desc'])?.find()
            log.info("CalendarSetup - Found calendar: ${calendar != null}, ID: ${calendar?.id}")
            
            return [
                template: 'attendance/calendarSetup',
                model: [calendar: calendar]
            ]
        },
        'calendarEvents': { params ->
            // Parse date strings from FullCalendar
            def startDate = parseDate(params.start)
            def endDate = parseDate(params.end)
            
            if (!startDate || !endDate) {
                use(TimeCategory) {
                    startDate = startDate ?: (new Date() - 30.days)
                    endDate = endDate ?: (new Date() + 30.days)
                }
            }
            
            def events = []
            
            // Get the most recent Calendar object
            def calendar = Calendar.list([sort: 'id', order: 'desc'])?.find()
            
            if (calendar) {
                // Map day names to Calendar constants
                def dayMap = [
                    'Sunday': java.util.Calendar.SUNDAY,
                    'Monday': java.util.Calendar.MONDAY,
                    'Tuesday': java.util.Calendar.TUESDAY,
                    'Wednesday': java.util.Calendar.WEDNESDAY,
                    'Thursday': java.util.Calendar.THURSDAY,
                    'Friday': java.util.Calendar.FRIDAY,
                    'Saturday': java.util.Calendar.SATURDAY
                ]
                
                def meetingDay = dayMap[calendar.dayOfWeek]
                if (meetingDay) {
                    def cal = java.util.Calendar.getInstance()
                    cal.setTime(startDate)
                    
                    // Loop until we go past the end date to ensure we don't miss the last meeting
                    while (cal.getTime() <= endDate) {
                        if (cal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                            def meetingDate = new Date(cal.getTimeInMillis())
                            
                            // Only include dates within the calendar season
                            if (meetingDate >= calendar.startDate && meetingDate <= calendar.endDate) {
                                // Calculate attendance rate (sample data for now)
                                def attendanceRate = Math.random() * 40 + 60 // 60-100%
                                
                                def eventTitle = "Awana Meeting"
                                if (calendar.startTime && calendar.endTime) {
                                    eventTitle += " (${calendar.startTime} - ${calendar.endTime})"
                                }
                                
                                def sdf = new SimpleDateFormat("yyyy-MM-dd")
                                events << [
                                    title: "${eventTitle} ${Math.round(attendanceRate)}%",
                                    start: sdf.format(meetingDate),
                                    type: "meeting",
                                    attendanceRate: attendanceRate,
                                    className: attendanceRate >= 90 ? "awana-event-high" : 
                                             attendanceRate >= 70 ? "awana-event-medium" : "awana-event-low"
                                ]
                            }
                        }
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1)
                    }
                }
            }
            
            response.contentType = 'application/json'
            render([events: events] as JSON)
            return null // Don't render template
        },
        'clubCreateForm': { params ->
            return [
                template: 'clubs/clubCreateForm',
                model: [:]
            ]
        },
        'clubEdit': { params ->
            Long clubId = params.long('clubId')
            def club = universalDataService.getById(Club, clubId)
            return [
                template: 'clubs/clubEdit',
                model: [club: club]
            ]
        },
        'clubStudents': { params ->
            Long clubId = params.long('refreshClubId') ?: params.long('clubId')
            def club = universalDataService.getById(Club, clubId)
            if (club) {
                club.refresh() // Refresh to get updated associations
            }
            def allStudents = universalDataService.list(Student)
            return [
                template: 'clubs/clubStudents',
                model: [club: club, allStudents: allStudents]
            ]
        },
        'clubBooks': { params ->
            Long clubId = params.long('refreshClubId') ?: params.long('clubId')
            def club = universalDataService.getById(Club, clubId)
            if (club) {
                club.refresh() // Refresh to get updated associations
            }
            def allBooks = universalDataService.list(Book)
            return [
                template: 'clubs/clubBooks',
                model: [club: club, allBooks: allBooks]
            ]
        },
        'checkin': { params ->
            def households = universalDataService.list(Household)
            return [
                template: 'checkin/checkin',
                model: [households: households]
            ]
        },
        'students': { params ->
            def clubs = universalDataService.list(Club)
            def studentCount = universalDataService.count(Student)
            return [
                template: 'students/students',
                model: [clubs: clubs, studentCount: studentCount]
            ]
        },
        'chapterSections': { params ->
            Long chapterId = params.long('chapterId') 
            def chapter = universalDataService.getById(Chapter, chapterId)
            def sections = chapter?.chapterSections ?: []
            return [
                template: 'books/chapterSections',
                model: [sections: sections, chapter: chapter]
            ]
        },
        'createHousehold': { params ->
            return [
                template: 'students/createHousehold',
                model: [:]
            ]
        },
        'manageHouseholds': { params ->
            def households = universalDataService.list(Household).sort { it.name }
            return [
                template: 'students/manageHouseholds',
                model: [households: households]
            ]
        },
        'editHousehold': { params ->
            Long householdId = params.long('refreshHouseholdId') ?: params.long('householdId')
            def household = universalDataService.getById(Household, householdId)
            if (!household) {
                throw new IllegalArgumentException("Household not found")
            }
            return [
                template: 'students/editHousehold',
                model: [household: household]
            ]
        },
        'addStudentToHousehold': { params ->
            Long householdId = params.long('refreshHouseholdId') ?: params.long('householdId')
            def household = universalDataService.getById(Household, householdId)
            def clubs = universalDataService.list(Club)
            if (!household) {
                throw new IllegalArgumentException("Household not found")
            }
            return [
                template: 'students/addStudentToHousehold',
                model: [household: household, clubs: clubs]
            ]
        },
        'editStudent': { params ->
            Long studentId = params.long('studentId')
            def student = universalDataService.getById(Student, studentId)
            def clubs = universalDataService.list(Club)
            if (!student) {
                throw new IllegalArgumentException("Student not found")
            }
            return [
                template: 'students/addStudentToHousehold',
                model: [student: student, household: student.household, clubs: clubs]
            ]
        },
        'attendanceManagement': { params ->
            def meetingDate = parseDate(params.meetingDate) ?: new Date()
            return [
                template: 'attendance/attendanceManagement',
                model: [meetingDate: meetingDate]
            ]
        },
        'attendanceClubOverview': { params ->
            def meetingDate = parseDate(params.meetingDate) ?: new Date()
            def clubs = universalDataService.list(Club)
            
            // Calculate attendance stats for each club
            def attendanceStats = [:]
            clubs.each { club ->
                def studentsInClub = club.students ?: []
                def presentCount = studentsInClub.count { student ->
                    // Find attendance for the specific meeting date
                    def attendance = student.attendances?.find { att -> 
                        att.attendanceDate && meetingDate && 
                        att.attendanceDate.format('yyyy-MM-dd') == meetingDate.format('yyyy-MM-dd') 
                    }
                    attendance?.present ?: false
                }
                attendanceStats[club.id] = [
                    presentCount: presentCount,
                    attendanceRate: studentsInClub.size() > 0 ? (presentCount / studentsInClub.size()) : 0
                ]
            }
            
            return [
                template: 'attendance/attendanceClubOverview',
                model: [
                    clubs: clubs,
                    meetingDate: meetingDate,
                    attendanceStats: attendanceStats
                ]
            ]
        },
        'attendanceStudentSearch': { params ->
            def searchTerm = params.attendanceSearch?.trim()
            def meetingDate = parseDate(params.meetingDate) ?: new Date()
            
            Map searchResult = universalDataService.listPaginated([
                domainClass: Student,
                params: params,
                searchableFields: ['firstName', 'lastName', 'household.name'],
                defaultSort: 'firstName'
            ])
            
            // Filter by search term if provided
            def students = searchResult.list
            if (searchTerm) {
                students = students.findAll { student ->
                    student.firstName.toLowerCase().contains(searchTerm.toLowerCase()) ||
                    student.lastName.toLowerCase().contains(searchTerm.toLowerCase()) ||
                    student.household.name.toLowerCase().contains(searchTerm.toLowerCase())
                }
            }
            
            return [
                template: 'attendance/attendanceStudentList',
                model: [
                    students: students,
                    meetingDate: meetingDate,
                    searchTerm: searchTerm
                ]
            ]
        },
        'attendanceClubStudents': { params ->
            Long clubId = params.long('clubId')
            def meetingDate = parseDate(params.meetingDate) ?: new Date()
            def club = universalDataService.getById(Club, clubId)
            
            if (!club) {
                throw new IllegalArgumentException("Club not found")
            }
            
            // Calculate club attendance stats
            def studentsInClub = club.students ?: []
            def presentCount = studentsInClub.count { student ->
                // Find attendance for the specific meeting date
                def attendance = student.attendances?.find { att -> 
                    att.attendanceDate && meetingDate && 
                    att.attendanceDate.format('yyyy-MM-dd') == meetingDate.format('yyyy-MM-dd') 
                }
                attendance?.present ?: false
            }
            def attendanceRate = studentsInClub.size() > 0 ? (presentCount / studentsInClub.size()) : 0
            
            return [
                template: 'attendance/attendanceClubStudents',
                model: [
                    club: club,
                    meetingDate: meetingDate,
                    presentCount: presentCount,
                    attendanceRate: attendanceRate
                ]
            ]
        },
        'studentAttendanceDetail': { params ->
            Long studentId = params.long('studentId')
            def meetingDate = parseDate(params.meetingDate) ?: new Date()
            def student = universalDataService.getById(Student, studentId)
            
            if (!student) {
                throw new IllegalArgumentException("Student not found")
            }
            
            // Find attendance record for this student on this date
            def attendance = student.attendances?.find { att -> 
                att.attendanceDate && meetingDate && 
                att.attendanceDate.format('yyyy-MM-dd') == meetingDate.format('yyyy-MM-dd') 
            }
            
            return [
                template: 'attendance/studentAttendanceDetail',
                model: [
                    student: student,
                    meetingDate: meetingDate,
                    attendance: attendance
                ]
            ]
        },
        'sidebarClubStudents': { params ->
            Long clubId = params.long('clubId')
            def club = universalDataService.getById(Club, clubId)
            
            if (!club) {
                return [
                    template: 'attendance/sidebarClubStudents',
                    model: [students: []]
                ]
            }
            
            return [
                template: 'attendance/sidebarClubStudents',
                model: [
                    students: club.students?.sort { it.firstName },
                    club: club
                ]
            ]
        }
    ]

    /**
     * GET /
     * Index page - Awana Club Dashboard
     */
    def index() {
        try {
            // Get all dashboard data in a single transaction for efficiency
            def studentCount = universalDataService.count(Student)
            def householdCount = universalDataService.count(Household)
            def clubCount = universalDataService.count(Club)
            def clubs = universalDataService.list(Club)
            def households = universalDataService.list(Household)
            
            [
                studentCount: studentCount,
                householdCount: householdCount,
                clubCount: clubCount,
                clubs: clubs,
                households: households
            ]
        } catch (Exception e) {
            log.error("Error loading dashboard data: ${e.message}", e)
            // Return empty data on error to prevent page crash
            [
                studentCount: 0,
                householdCount: 0,
                clubCount: 0,
                clubs: [],
                households: []
            ]
        }
    }

    /**
     * GET /checkin
     * Family Check-In page - QR code scanning and family display
     */
    def checkin() {
        // This just renders the checkin.gsp page skeleton
        // The actual content is loaded via /renderView?viewType=checkin
        [:]
    }

    /**
     * GET /students
     * Student management page
     */
    def students() {
        // This just renders the students.gsp page skeleton
        // The actual content is loaded via /renderView?viewType=students
        [:]
    }

    /**
     * GET /clubs
     * Club management page - renders clubs.gsp which loads content dynamically
     */
    def clubs() {
        // This just renders the clubs.gsp page skeleton
        // The actual content is loaded via /renderView?viewType=clubs
        [:]
    }

    /**
     * GET /attendance
     * Attendance tracking and calendar management page
     */
    def attendance() {
        // This just renders the attendance.gsp page skeleton
        // The actual content is loaded via /renderView?viewType=attendance
        [:]
    }

    /**
     * GET /store
     * Awana store page - placeholder for now
     */
    def store() {
        try {
            // Placeholder - could use storeTransaction view or create dedicated store view
            flash.message = "Awana Store coming soon!"
            redirect action: 'index'
        } catch (Exception e) {
            log.error("Error loading store page: ${e.message}", e)
            flash.error = "Error loading store page"
            redirect action: 'index'
        }
    }

    /**
     * GET /reports  
     * Reports and analytics page - placeholder for now
     */
    def reports() {
        try {
            // Placeholder - could use attendanceRecord view or create dedicated reports view
            flash.message = "Reports and Analytics coming soon!"
            redirect action: 'index'
        } catch (Exception e) {
            log.error("Error loading reports page: ${e.message}", e)
            flash.error = "Error loading reports page"
            redirect action: 'index'
        }
    }

    /**
     * GET /verseCompletion
     * Verse completion page
     */
    def verseCompletion() {
        // This just renders the verseCompletion.gsp page skeleton
        // The actual content is loaded via /renderView?viewType=verseCompletion
        [:]
    }


    /**
     * GET /universal/{domainName}
     * List all instances of a domain class with optional pagination and search
     */
    def list() {
        String domainName = params.domainName
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            if (params.paginated == 'true') {
                // Advanced paginated listing
                def searchableFields = getSearchableFields(domainClass)
                def result = universalDataService.listPaginated([
                    domainClass: domainClass,
                    params: params,
                    searchableFields: searchableFields,
                    defaultSort: 'id',
                    defaultOrder: 'desc'
                ])
                
                if (isHtmxRequest()) {
                    // Render template fragment for HTMX
                    render(template: 'shared/listTable', model: [result: result, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render result as JSON
                } else {
                    [result: result, domainName: domainName]
                }
            } else {
                // Simple listing
                def instances = universalDataService.list(domainClass)
                
                if (isHtmxRequest()) {
                    // Render template fragment for HTMX
                    render(template: 'shared/listItems', model: [instances: instances, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render instances as JSON
                } else {
                    [instances: instances, domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error listing ${domainName}: ${e.message}")
            render status: 500, text: "Error listing ${domainName}"
        }
    }

    /**
     * GET /universal/{domainName}/{id}
     * Show specific instance
     */
    def show() {
        String domainName = params.domainName
        Long id = params.long('id')
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            def instance = universalDataService.getById(domainClass, id)
            
            if (!instance) {
                render status: 404, text: "${domainName} with ID ${id} not found"
                return
            }

            if (isHtmxRequest()) {
                // Render template fragment for HTMX
                render(template: 'showDetail', model: [instance: instance, domainName: domainName])
                return
            } else if (isJsonRequest()) {
                render instance as JSON
            } else {
                [instance: instance, domainName: domainName]
            }
        } catch (Exception e) {
            log.error("Error showing ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error retrieving ${domainName}"
        }
    }

    /**
     * POST /universal/{domainName}
     * Create new instance
     */
    def save() {
        String domainName = params.domainName
        String viewType = params.viewType   // <-- front end can pass this
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            def instance = universalDataService.save(domainClass, params)
            
            
            if (instance) {
                if (isHtmxRequest()) {
                    if (viewType && viewRenderMap.containsKey(viewType)) {
                        def viewClosure = viewRenderMap[viewType]


                        def view = viewClosure(params)
                        // Add success message to response headers for HTMX
                        response.setHeader('HX-Trigger', 'showSuccessToast')
                        response.setHeader('HX-Trigger-Data', '{"message": "' + domainName + ' created successfully"}')
                        render template: view.template, model: view.model
                        return
                    }
                    // fallback if no view requested
                    render status: 201, text: "Created successfully"
                    return
                } else if (isJsonRequest()) {
                    render status: 201, contentType: 'application/json', text: (instance as JSON).toString()
                } else {
                    flash.success = "${domainName} created successfully"
                    redirect action: 'show', params: [domainName: domainName, id: instance.id]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 400, template: 'shared/createError', model: [domainName: domainName, message: "Failed to create ${domainName}"]
                    return
                } else if (isJsonRequest()) {
                    render status: 400, text: "Failed to create ${domainName}"
                } else {
                    flash.error = "Failed to create ${domainName}"
                    redirect action: 'list', params: [domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error creating ${domainName}: ${e.message}")
            render status: 500, text: "Error creating ${domainName}"
        }
    }

    /**
     * PUT /universal/{domainName}/{id}
     * Update existing instance
     */
    def update() {
        String domainName = params.domainName
        Long id = params.long('id')
        String viewType = params.viewType   // <-- front end can pass this
        println "${viewType} SHOULD BE THE VIEWTYPE"

        Class domainClass = getDomainClass(domainName)

        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            def instance = universalDataService.update(domainClass, id, params)

            if (instance) {
                if (isHtmxRequest()) {
                    if (viewType && viewRenderMap.containsKey(viewType)) {
                        def viewClosure = viewRenderMap[viewType]
                        def view = viewClosure(params)
                        // Add success message to response headers for HTMX
                        response.setHeader('HX-Trigger', 'showSuccessToast')
                        response.setHeader('HX-Trigger-Data', '{"message": "' + domainName + ' updated successfully"}')
                        render template: view.template, model: view.model
                        return
                    }
                    // fallback if no view requested
                    render status: 200, text: "Success"
                    return
                } else if (isJsonRequest()) {
                    render instance as JSON
                } else {
                    flash.success = "${domainName} updated successfully"
                    redirect action: 'show', params: [domainName: domainName, id: id]
                }
            } else {
                render status: 400, text: "Failed to update ${domainName}"
            }
        } catch (Exception e) {
            log.error("Error updating ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error updating ${domainName}"
        }
    }


    /**
     * DELETE /universal/{domainName}/{id}
     * Delete instance
     */
    def delete() {
        String domainName = params.domainName
        Long id = params.long('id')
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            boolean deleted = universalDataService.deleteById(domainClass, id)
            
            if (deleted) {
                if (isHtmxRequest()) {
                    // For HTMX deletes, typically remove the element from DOM or show success message
                    render status: 200, template: 'deleteSuccess', model: [domainName: domainName, id: id]
                    return
                } else if (isJsonRequest()) {
                    render status: 204, text: ''
                } else {
                    flash.success = "${domainName} deleted successfully"
                    redirect action: 'list', params: [domainName: domainName]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 404, template: 'deleteError', model: [domainName: domainName, message: "${domainName} not found"]
                    return
                } else if (isJsonRequest()) {
                    render status: 404, text: "${domainName} not found"
                } else {
                    flash.error = "${domainName} not found or could not be deleted"
                    redirect action: 'list', params: [domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error deleting ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error deleting ${domainName}"
        }
    }

    /**
     * GET /universal/{domainName}/count
     * Get count of instances
     */
    def count() {
        String domainName = params.domainName
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            def count = universalDataService.count(domainClass)
            render contentType: 'application/json', text: [count: count] as JSON
        } catch (Exception e) {
            log.error("Error counting ${domainName}: ${e.message}")
            render status: 500, text: "Error counting ${domainName}"
        }
    }

    /**
     * POST /universal/renderView
     * Dynamic view rendering based on frontend instructions
     */
    def renderView() {
        String viewType = params.viewType
        String context = params.context
        
        if (!viewType) {
            render status: 400, text: "viewType parameter is required"
            return
        }

        try {
            def viewClosure = viewRenderMap[viewType]
            if (viewClosure) {
                def result = viewClosure(params)
                
                // If closure returns null, it handled its own rendering
                if (result == null) {
                    return
                }
                
                if (isJsonRequest()) {
                    render result.model as JSON
                } else {
                    // Always render template for SPA approach
                    render template: result.template, model: result.model
                }
            } else {
                render status: 404, text: "Unknown view type: ${viewType}"
            }
        } catch (Exception e) {
            log.error("Error rendering view ${viewType}: ${e.message}", e)
            render status: 500, text: "Error rendering view"
        }
    }

    /**
     * Resolve domain class from string name
     */
    private Class getDomainClass(String domainName) {
        if (!domainName) return null
        
        try {
            // Try with the awana package first
            String className = "awana.${GrailsNameUtils.getClassName(domainName)}"
            return Class.forName(className)
        } catch (ClassNotFoundException e1) {
            try {
                // Try without package as fallback
                return Class.forName(GrailsNameUtils.getClassName(domainName))
            } catch (ClassNotFoundException e2) {
                log.warn("Domain class not found: ${domainName}")
                return null
            }
        }
    }

    /**
     * Get searchable fields for a domain class
     * This is a basic implementation - in real app you might want to configure this per domain
     */
    private List<String> getSearchableFields(Class domainClass) {
        def fields = []
        
        // Common searchable fields for most domains
        if (domainClass.declaredFields.find { it.name == 'name' }) {
            fields << 'name'
        }
        if (domainClass.declaredFields.find { it.name == 'username' }) {
            fields << 'username'
        }
        if (domainClass.declaredFields.find { it.name == 'email' }) {
            fields << 'email'
        }
        if (domainClass.declaredFields.find { it.name == 'title' }) {
            fields << 'title'
        }
        if (domainClass.declaredFields.find { it.name == 'description' }) {
            fields << 'description'
        }
        
        return fields
    }

    /**
     * Check if this is an HTMX request
     */
    private boolean isHtmxRequest() {
        return request.getHeader('HX-Request') == 'true'
    }

    /**
     * Check if this is a JSON API request (for REST endpoints)
     */
    private boolean isJsonRequest() {
        return params.format == 'json' || 
               request.getHeader('Accept')?.contains('application/json')
    }
}