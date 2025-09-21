package awana

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.GrailsNameUtils
import groovy.time.TimeCategory
import java.text.SimpleDateFormat
import java.time.*
import java.time.temporal.ChronoUnit

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
            // Handle timestamp format (e.g., 1725426000000)
            if (value ==~ /^\d{13}$/) {
                return new Date(Long.parseLong(value))
            }
            // For everything else, use Groovy's built-in Date.parse() which handles most formats
            return Date.parse(value)
        } catch (Exception e) {
            log.warn("Date parse failed for value: ${value}, error: ${e.message}")
            return null // Return null to let caller handle the fallback
        }
    }
    
    /**
     * Preprocess Calendar params to convert time strings to LocalTime objects
     */
    private Map preprocessCalendarTimeFields(Map params) {
        Map processedParams = new HashMap(params)
        
        // Convert startTime from "HH:mm" string to LocalTime
        if (params.startTime && params.startTime instanceof String) {
            try {
                processedParams.startTime = LocalTime.parse(params.startTime)
            } catch (Exception e) {
                log.warn("Invalid startTime format: ${params.startTime}")
                processedParams.remove('startTime') // Remove invalid value
            }
        }
        
        // Convert endTime from "HH:mm" string to LocalTime  
        if (params.endTime && params.endTime instanceof String) {
            try {
                processedParams.endTime = LocalTime.parse(params.endTime)
            } catch (Exception e) {
                log.warn("Invalid endTime format: ${params.endTime}")
                processedParams.remove('endTime') // Remove invalid value
            }
        }
        
        return processedParams
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
                        def weekAgo = LocalDate.now().minus(7, ChronoUnit.DAYS)
                        def weekAgoDate = Date.from(weekAgo.atStartOfDay(ZoneId.systemDefault()).toInstant())
                        def recentCompletions = SectionVerseCompletion.findAll(
                            "FROM SectionVerseCompletion WHERE completionDate >= :weekAgo ORDER BY completionDate DESC",
                            [weekAgo: weekAgoDate]
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
            def selectedStudent = studentId ? universalDataService.getById(Student, studentId) : null
            
            // Load only the primary book with all chapters and sections (same as editBook pattern)
            def books = []
            if (selectedStudent?.club?.books) {
                def primaryBook = selectedStudent.club.books.find { it.isPrimary }
                if (primaryBook) {
                    def fullBook = universalDataService.getById(Book, primaryBook.id)
                    books << fullBook
                }
            }
            
            return [
                template: 'books/verseCompletion',
                model: [
                    selectedStudent: selectedStudent,
                    books: books
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
            String dateStr = params.date ?: new SimpleDateFormat('yyyy-MM-dd').format(new Date())
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
                    // Get current month meetings for meetings count
                    def currentMonthEnd = new Date()
                    def currentMonthStart = currentMonthEnd - 30.days
                    
                    // Count meetings this month
                    def allAttendances = Attendance.findAll()
                    def thisMonthAttendances = allAttendances.findAll { attendance ->
                        attendance.attendanceDate >= currentMonthStart && attendance.attendanceDate <= currentMonthEnd
                    }
                    
                    // Keep monthly calculation for any legacy code that might need it
                    def sdf = new SimpleDateFormat('yyyy-MM-dd')
                    def monthlyMeetingDates = thisMonthAttendances.collect { sdf.format(it.attendanceDate) }.unique()
                    // (Note: attendanceMetrics.totalMeetings and meetingsCompleted will be overridden by season calculation below)
                    
                    // Calculate SEASON-WIDE average attendance using proper formula like club calculations
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
                    
                    // Count all meetings in the season so far (up to today)
                    def seasonMeetingDates = []
                    def tempCal = java.util.Calendar.getInstance()
                    tempCal.setTime(calendar.startDate)
                    def today = new Date()
                    

                    while (tempCal.getTime() <= calendar.endDate) {
                        if (tempCal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                            seasonMeetingDates.add(new Date(tempCal.getTimeInMillis()))
                        }
                        tempCal.add(java.util.Calendar.DAY_OF_MONTH, 1)
                    }
                    

                    // Calculate season meetings - total meetings vs meetings that have passed
                    attendanceMetrics.totalMeetings = seasonMeetingDates.size()  // Use actual count, not hardcoded 36
                    def pastMeetings = seasonMeetingDates.findAll { it <= today }
                    attendanceMetrics.meetingsCompleted = pastMeetings.size()
                    

                    // Calculate total possible vs actual present
                    def totalPresentCount = 0
                    seasonMeetingDates.each { meetingDate ->
                        def dayAttendances = Attendance.findAllByAttendanceDate(meetingDate)
                        totalPresentCount += dayAttendances.count { it.present }
                    }
                    
                    def totalPossibleAttendances = seasonMeetingDates.size() * totalStudents
                    attendanceMetrics.averageAttendance = totalPossibleAttendances > 0 ? 
                        (totalPresentCount / totalPossibleAttendances) * 100 : 0
                    
                }
            }
            
            // Calculate club-specific attendance rates for sidebar (calendar season dates)
            def clubAttendanceRates = [:]
            clubs.each { club ->
                def clubStudents = club.students?.toList() ?: []
                if (clubStudents.size() > 0 && calendar) {
                    // Count all possible meeting dates in the calendar season
                    def meetingDay = null
                    def dayMap = [
                        'Sunday': java.util.Calendar.SUNDAY,
                        'Monday': java.util.Calendar.MONDAY,
                        'Tuesday': java.util.Calendar.TUESDAY,
                        'Wednesday': java.util.Calendar.WEDNESDAY,
                        'Thursday': java.util.Calendar.THURSDAY,
                        'Friday': java.util.Calendar.FRIDAY,
                        'Saturday': java.util.Calendar.SATURDAY
                    ]
                    meetingDay = dayMap[calendar.dayOfWeek]
                    
                    // Count total possible meeting dates in season
                    def totalMeetingDates = 0
                    if (meetingDay) {
                        def cal = java.util.Calendar.getInstance()
                        cal.setTime(calendar.startDate)
                        while (cal.getTime() <= calendar.endDate) {
                            if (cal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                                totalMeetingDates++
                            }
                            cal.add(java.util.Calendar.DAY_OF_MONTH, 1)
                        }
                    }
                    
                    if (totalMeetingDates > 0) {
                        // Count actual present students across all meetings
                        def totalPresentCount = 0
                        clubStudents.each { student ->
                            def studentAttendances = student.attendances?.findAll { attendance ->
                                attendance.attendanceDate && attendance.present &&
                                attendance.attendanceDate >= calendar.startDate && 
                                attendance.attendanceDate <= calendar.endDate
                            } ?: []
                            totalPresentCount += studentAttendances.size()
                        }
                        
                        // Calculate rate: actualPresent / (totalMeetings × totalStudents)
                        def totalPossibleAttendances = totalMeetingDates * clubStudents.size()
                        def rate = Math.round((totalPresentCount / totalPossibleAttendances) * 100)
                        clubAttendanceRates[club.id] = rate
                    } else {
                        clubAttendanceRates[club.id] = 0
                    }
                } else {
                    clubAttendanceRates[club.id] = 0
                }
            }
            
            // Calculate monthly rates for sidebar (current month)
            def clubMonthlyRates = [:]
            if (calendar) {
                use(TimeCategory) {
                    def today = new Date()
                    def cal = java.util.Calendar.getInstance()
                    cal.setTime(today)
                    
                    // Set to first day of current month
                    cal.set(java.util.Calendar.DAY_OF_MONTH, 1)
                    cal.set(java.util.Calendar.HOUR_OF_DAY, 0)
                    cal.set(java.util.Calendar.MINUTE, 0)
                    cal.set(java.util.Calendar.SECOND, 0)
                    cal.set(java.util.Calendar.MILLISECOND, 0)
                    def monthStart = cal.getTime()
                    
                    // Set to last day of current month  
                    cal.set(java.util.Calendar.DAY_OF_MONTH, cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH))
                    cal.set(java.util.Calendar.HOUR_OF_DAY, 23)
                    cal.set(java.util.Calendar.MINUTE, 59)
                    cal.set(java.util.Calendar.SECOND, 59)
                    def monthEnd = cal.getTime()
                    
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
                    
                    clubs.each { club ->
                        def clubStudents = club.students?.toList() ?: []
                        if (clubStudents.size() > 0 && meetingDay) {
                            // Count meetings in current month
                            def monthMeetingDates = []
                            def tempCal = java.util.Calendar.getInstance()
                            tempCal.setTime(monthStart)
                            while (tempCal.getTime() <= monthEnd) {
                                if (tempCal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                                    def tempMeetingDate = new Date(tempCal.getTimeInMillis())
                                    if (tempMeetingDate >= calendar.startDate && tempMeetingDate <= calendar.endDate) {
                                        monthMeetingDates.add(tempMeetingDate)
                                    }
                                }
                                tempCal.add(java.util.Calendar.DAY_OF_MONTH, 1)
                            }
                            
                            if (monthMeetingDates.size() > 0) {
                                // Calculate monthly attendance rate
                                def totalPresentCount = 0
                                monthMeetingDates.each { meetingDate ->
                                    def clubAttendances = Attendance.withCriteria {
                                        eq('attendanceDate', meetingDate)
                                        'in'('student', clubStudents)
                                    }
                                    totalPresentCount += clubAttendances.count { it.present }
                                }
                                
                                def totalPossibleAttendances = monthMeetingDates.size() * clubStudents.size()
                                def rate = totalPossibleAttendances > 0 ? 
                                    Math.round((totalPresentCount / totalPossibleAttendances) * 100) : 0
                                
                                clubMonthlyRates[club.id] = rate
                            } else {
                                clubMonthlyRates[club.id] = 0
                            }
                        } else {
                            clubMonthlyRates[club.id] = 0
                        }
                    }
                }
            }
            
            return [
                template: 'attendance/attendance',
                model: [
                    calendar: calendar,
                    clubs: clubs,
                    totalStudents: totalStudents,
                    attendanceMetrics: attendanceMetrics,
                    clubAttendanceRates: clubAttendanceRates,
                    clubMonthlyRates: clubMonthlyRates
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
            Long studentId = params.long('studentId') // Check if filtering by specific student
            Long clubId = params.long('clubId') // Check if filtering by specific club
            
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
                    
                    // Get student or club for filtering if provided
                    def student = studentId ? universalDataService.getById(Student, studentId) : null
                    def club = clubId ? universalDataService.getById(Club, clubId) : null
                    
                    // Loop until we go past the end date to ensure we don't miss the last meeting
                    while (cal.getTime() <= endDate) {
                        if (cal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                            def meetingDate = new Date(cal.getTimeInMillis())
                            
                            // Only include dates within the calendar season
                            if (meetingDate >= calendar.startDate && meetingDate <= calendar.endDate) {
                                def eventTitle = "Awana"
                                if (calendar.timeRangeDisplay) {
                                    eventTitle += " (${calendar.timeRangeDisplay})"
                                }
                                
                                def sdf = new SimpleDateFormat("yyyy-MM-dd")
                                def eventData = [
                                    start: sdf.format(meetingDate),
                                    type: "meeting"
                                ]
                                
                                if (student) {
                                    // STUDENT FILTER: Show boolean colors (green/red/gray) for individual student
                                    def attendance = student.attendances?.find { att ->
                                        att.attendanceDate && 
                                        sdf.format(att.attendanceDate) == sdf.format(meetingDate)
                                    }
                                    
                                    if (attendance) {
                                        // Student has an attendance record - show if present or absent
                                        eventData.title = attendance.present ? 
                                            "${student.firstName} - Present" : 
                                            "${student.firstName} - Absent"
                                        eventData.className = attendance.present ? 
                                            "awana-event-high" : 
                                            "awana-event-low"
                                        eventData.present = attendance.present
                                    } else {
                                        // No attendance record for this date
                                        eventData.title = "${student.firstName} - No Record"
                                        eventData.className = "awana-event-scheduled"
                                        eventData.present = null
                                    }
                                } else if (club) {
                                    // CLUB FILTER: Calculate percentage for specific club on this specific meeting
                                    def clubStudents = club.students?.toList() ?: []
                                    def clubAttendances = Attendance.withCriteria {
                                        eq('attendanceDate', meetingDate)
                                        'in'('student', clubStudents)
                                    }
                                    def presentCount = clubAttendances.count { it.present }
                                    
                                    def attendanceRate = 0
                                    if (clubStudents.size() > 0) {
                                        attendanceRate = (presentCount / clubStudents.size()) * 100
                                    }
                                    
                                    eventData.title = "${eventTitle} - ${club.name} ${Math.round(attendanceRate)}%"
                                    eventData.attendanceRate = attendanceRate
                                    eventData.className = attendanceRate >= 90 ? "awana-event-high" : 
                                                        attendanceRate >= 70 ? "awana-event-medium" : 
                                                        attendanceRate > 0 ? "awana-event-low" : "awana-event-scheduled"
                                } else {
                                    // DEFAULT: Calculate percentage for this specific meeting
                                    // Get total students and attendances for this specific date
                                    def totalStudents = universalDataService.count(Student)
                                    def dayAttendances = Attendance.findAllByAttendanceDate(meetingDate)
                                    def presentCount = dayAttendances.count { it.present }
                                    
                                    def attendanceRate = 0
                                    if (totalStudents > 0) {
                                        attendanceRate = (presentCount / totalStudents) * 100
                                    }
                                    
                                    eventData.title = "${eventTitle} ${Math.round(attendanceRate)}%"
                                    eventData.attendanceRate = attendanceRate
                                    eventData.className = attendanceRate >= 90 ? "awana-event-high" : 
                                                        attendanceRate >= 70 ? "awana-event-medium" : 
                                                        attendanceRate > 0 ? "awana-event-low" : "awana-event-scheduled"
                                }
                                
                                events << eventData
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
        'sections': { params ->
            Long chapterId = params.long('chapterId')
            Long sectionId = params.long('sectionId')
            Long studentId = params.long('refreshStudentId') ?: params.long('studentId')
            
            // Load the chapter to get its book, then load the full book (same as editBook pattern)
            def chapter = universalDataService.getById(Chapter, chapterId)
            def book = null
            if (chapter?.book) {
                book = universalDataService.getById(Book, chapter.book.id)
                // Find the specific chapter within the fully loaded book
                chapter = book.chapters?.find { it.id == chapterId }
            }
            
            def sections = chapter?.chapterSections?.sort { it.sectionNumber } ?: []
            def selectedStudent = studentId ? universalDataService.getById(Student, studentId) : null
            
            // Get completion for the specific section (or first section if no sectionId)
            def sectionCompletion = null
            def currentSection = null
            if (selectedStudent && sections) {
                if (sectionId) {
                    currentSection = universalDataService.getById(ChapterSection, sectionId)
                } else {
                    currentSection = sections[0] // Default to first section
                }
                
                if (currentSection) {
                    sectionCompletion = SectionVerseCompletion.findByStudentAndChapterSection(selectedStudent, currentSection)
                }
            }
            
            return [
                template: 'books/sections',
                model: [sections: sections, chapter: chapter, selectedStudent: selectedStudent, sectionCompletion: sectionCompletion, currentSection: currentSection]
            ]
        },
        'chapterSections': { params ->
            Long chapterId = params.long('chapterId')
            Long sectionId = params.long('sectionId')
            Long studentId = params.long('refreshStudentId') ?: params.long('studentId')
            
            // Load the chapter to get its book, then load the full book (exactly like editBook)
            def chapter = universalDataService.getById(Chapter, chapterId)
            def book = null
            if (chapter?.book) {
                book = universalDataService.getById(Book, chapter.book.id)
                // Find the specific chapter within the fully loaded book
                chapter = book.chapters?.find { it.id == chapterId }
            }
            
            def sections = chapter?.chapterSections?.sort { it.sectionNumber } ?: []
            def student = studentId ? universalDataService.getById(Student, studentId) : null
            
            // Get fresh completion data for this student and all sections
            def completions = [:]
            if (student && sections) {
                sections.each { section ->
                    // Force fresh query by using findBy instead of cached relationships
                    def completion = SectionVerseCompletion.findByStudentAndChapterSection(student, section)
                    if (completion) {
                        completions[section.id] = completion
                    }
                }
            }
            
            return [
                template: 'books/chapterSections',
                model: [sections: sections, chapter: chapter, student: student, completions: completions]
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
        'search': { params ->
            def searchTerm = params.familySearch?.trim()

            if (!searchTerm) {
                // No search term - show all households
                def households = universalDataService.list(Household)
                return [
                    template: 'checkin/search',
                    model: [households: households, searchTerm: '']
                ]
            }

            // Search households by name and also find households containing students with matching names
            def matchingHouseholds = []

            // Direct household name search
            def householdsByName = Household.findAll(
                "FROM Household WHERE LOWER(name) LIKE :searchTerm",
                [searchTerm: "%${searchTerm.toLowerCase()}%"]
            )
            matchingHouseholds.addAll(householdsByName)

            // Find households with students matching the search term
            def studentsMatching = Student.findAll(
                "FROM Student WHERE LOWER(firstName) LIKE :searchTerm OR LOWER(lastName) LIKE :searchTerm",
                [searchTerm: "%${searchTerm.toLowerCase()}%"]
            )

            studentsMatching.each { student ->
                if (student.household && !matchingHouseholds.contains(student.household)) {
                    matchingHouseholds.add(student.household)
                }
            }

            return [
                template: 'checkin/search',
                model: [households: matchingHouseholds, searchTerm: searchTerm]
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
                    def sdf = new SimpleDateFormat('yyyy-MM-dd')
                    def attendance = student.attendances?.find { att -> 
                        att.attendanceDate && meetingDate && 
                        sdf.format(att.attendanceDate) == sdf.format(meetingDate) 
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
                def sdf = new SimpleDateFormat('yyyy-MM-dd')
                def attendance = student.attendances?.find { att -> 
                    att.attendanceDate && meetingDate && 
                    sdf.format(att.attendanceDate) == sdf.format(meetingDate) 
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
        'checkinStudent': { params ->
            Long studentId = params.long('refreshStudentId') ?: params.long('studentId')
            
            // Debug the meetingDate parameter
            log.info("checkinStudent - meetingDate param: '${params.meetingDate}'")
            def meetingDate = parseDate(params.meetingDate)
            if (!meetingDate) {
                log.warn("Failed to parse meetingDate '${params.meetingDate}', using current date")
                meetingDate = new Date()
            }
            log.info("checkinStudent - parsed meetingDate: ${meetingDate}")
            
            def student = universalDataService.getById(Student, studentId)
            
            if (!student) {
                throw new IllegalArgumentException("Student not found")
            }
            
            // Find attendance record for this student on this date
            def sdf = new SimpleDateFormat('yyyy-MM-dd')
            def attendance = student.attendances?.find { att -> 
                att.attendanceDate && meetingDate && 
                sdf.format(att.attendanceDate) == sdf.format(meetingDate) 
            }
            
            // Get the current calendar
            def calendar = Calendar.list([sort: 'id', order: 'desc'])?.find()
            
            return [
                template: 'attendance/checkinStudent',
                model: [
                    student: student,
                    meetingDate: meetingDate,
                    attendance: attendance,
                    calendar: calendar
                ]
            ]
        },
        'sidebarClubStudents': { params ->
            Long clubId = params.long('clubId')
            def club = universalDataService.getById(Club, clubId)
            def startDate = parseDate(params.start)
            def endDate = parseDate(params.end)
            
            if (!club) {
                return [
                    template: 'attendance/sidebarClubStudents',
                    model: [students: [], startDate: startDate, endDate: endDate]
                ]
            }
            
            return [
                template: 'attendance/sidebarClubStudents',
                model: [
                    students: club.students?.sort { it.firstName },
                    club: club,
                    startDate: startDate,
                    endDate: endDate
                ]
            ]
        },
        'updateSidebarStats': { params ->
            // Calculate sidebar stats - for monthly view, use actual month, not calendar display range
            def viewStartDate = parseDate(params.start)
            def viewEndDate = parseDate(params.end)
            
            // Determine if this is a monthly view by checking if date range spans more than 35 days
            def daysBetween = (viewEndDate.time - viewStartDate.time) / (1000 * 60 * 60 * 24)
            
            def startDate, endDate
            if (daysBetween > 35) {
                // This is likely a monthly view - use the actual month from the middle date
                def middleTime = (viewStartDate.time + viewEndDate.time) / 2
                def middleDate = new Date(middleTime as long)
                def cal = java.util.Calendar.getInstance()
                cal.setTime(middleDate)
                
                // Set to first day of this month
                cal.set(java.util.Calendar.DAY_OF_MONTH, 1)
                cal.set(java.util.Calendar.HOUR_OF_DAY, 0)
                cal.set(java.util.Calendar.MINUTE, 0)
                cal.set(java.util.Calendar.SECOND, 0)
                cal.set(java.util.Calendar.MILLISECOND, 0)
                startDate = cal.getTime()
                
                // Set to last day of this month  
                cal.set(java.util.Calendar.DAY_OF_MONTH, cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH))
                cal.set(java.util.Calendar.HOUR_OF_DAY, 23)
                cal.set(java.util.Calendar.MINUTE, 59)
                cal.set(java.util.Calendar.SECOND, 59)
                endDate = cal.getTime()
            } else {
                // Weekly or daily view - use the exact date range
                startDate = viewStartDate
                endDate = viewEndDate
            }
            
            def clubs = universalDataService.list(Club)
            def calendar = Calendar.list([sort: 'id', order: 'desc'])?.find()
            def clubAttendanceRates = [:]
            

            if (calendar) {
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
                
                clubs.each { club ->
                    def clubStudents = club.students?.toList() ?: []
                    if (clubStudents.size() > 0 && meetingDay) {
                        // Count meetings in current view period
                        def viewMeetingDates = []
                        def tempCal = java.util.Calendar.getInstance()
                        tempCal.setTime(startDate)
                        while (tempCal.getTime() <= endDate) {
                            if (tempCal.get(java.util.Calendar.DAY_OF_WEEK) == meetingDay) {
                                def tempMeetingDate = new Date(tempCal.getTimeInMillis())
                                if (tempMeetingDate >= calendar.startDate && tempMeetingDate <= calendar.endDate) {
                                    viewMeetingDates.add(tempMeetingDate)
                                }
                            }
                            tempCal.add(java.util.Calendar.DAY_OF_MONTH, 1)
                        }
                        
                        // Calculate attendance rate using the exact formula: totalPresentCount / (enrolled × meetings) × 100
                        def totalPresentCount = 0
                        viewMeetingDates.each { meetingDate ->
                            def clubAttendances = Attendance.withCriteria {
                                eq('attendanceDate', meetingDate)
                                'in'('student', clubStudents)
                            }
                            totalPresentCount += clubAttendances.count { it.present }
                        }
                        
                        def totalPossibleAttendances = viewMeetingDates.size() * clubStudents.size()
                        def rate = totalPossibleAttendances > 0 ? 
                            Math.round((totalPresentCount / totalPossibleAttendances) * 100) : 0
                        

                        clubAttendanceRates[club.id] = rate
                    } else {
                        clubAttendanceRates[club.id] = 0
                    }
                }
            }
            
            response.contentType = 'application/json'
            render(clubAttendanceRates as JSON)
            return null
        },
        'createBook': { params ->
            Long clubId = params.long('clubId')
            def club = null
            

            if (clubId) {
                club = universalDataService.getById(Club, clubId)
            }
            

            return [
                template: 'books/createBook',
                model: [club: club]
            ]
        },
        'editBook': { params ->
            Long bookId = params.long('bookId')
            Long clubId = params.long('clubId')
            def book = null
            def club = null
            

            if (bookId) {
                book = universalDataService.getById(Book, bookId)
            }
            
            if (clubId) {
                club = universalDataService.getById(Club, clubId)
            }
            

            return [
                template: 'books/createBook',
                model: [book: book, club: club, editMode: true]
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
            // Handle Calendar LocalTime conversion before save
            Map processedParams = (domainClass == Calendar) ? 
                preprocessCalendarTimeFields(params) : params
            
            def instance = universalDataService.save(domainClass, processedParams)
            
            
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

        Class domainClass = getDomainClass(domainName)

        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            // Handle Calendar LocalTime conversion before update
            Map processedParams = (domainClass == Calendar) ? 
                preprocessCalendarTimeFields(params) : params
            
            def instance = universalDataService.update(domainClass, id, processedParams)

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