package awana

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.GrailsNameUtils

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class UniversalController {

    UniversalDataService universalDataService

    /**
     * Dynamic view rendering map using closures
     * Frontend can specify viewType and context to render specific views
     */
    private def viewRenderMap = [
        'checkInFamily': { params -> 
            checkInFamilyView(params)
        },
        'studentSearch': { params ->
            studentSearchView(params)
        },
        'verseCompletion': { params ->
            verseCompletionView(params) 
        },
        'studentProgress': { params ->
            studentProgressView(params)
        },
        'storeTransaction': { params ->
            storeTransactionView(params)
        },
        'clubOverview': { params ->
            clubOverviewView(params)
        },
        'attendanceRecord': { params ->
            attendanceRecordView(params)
        }
    ]

    /**
     * GET /
     * Index page - Awana Club Dashboard
     */
    def index() {
        try {
            // Get all dashboard data in a single transaction for efficiency
            def studentCount = universalDataService.count(awana.Student)
            def householdCount = universalDataService.count(awana.Household)
            def clubCount = universalDataService.count(awana.Club)
            def clubs = universalDataService.list(awana.Club)
            def households = universalDataService.list(awana.Household)
            
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
        try {
            // Get households for manual search fallback
            def households = universalDataService.list(awana.Household)
            
            [
                households: households
            ]
        } catch (Exception e) {
            log.error("Error loading check-in data: ${e.message}", e)
            [households: []]
        }
    }

    /**
     * GET /checkin/family/{qrCode}
     * Display family by QR code for check-in
     */
    def checkInFamily() {
        String qrCode = params.qrCode
        
        if (!qrCode) {
            if (isHtmxRequest()) {
                render status: 400, template: 'checkInError', model: [message: "QR Code is required"]
                return
            } else {
                flash.error = "QR Code is required"
                redirect action: 'checkin'
                return
            }
        }

        try {
            def household = awana.Household.findByQrCode(qrCode)
            
            if (!household) {
                if (isHtmxRequest()) {
                    render status: 404, template: 'checkInError', model: [message: "Family not found for QR code: ${qrCode}"]
                    return
                } else {
                    flash.error = "Family not found for QR code: ${qrCode}"
                    redirect action: 'checkin'
                    return
                }
            }

            def students = household.getAllStudents()
            def today = new Date()
            
            // Get today's attendance for each student to show current status
            def attendanceMap = [:]
            students.each { student ->
                def todaysAttendance = awana.Attendance.findByStudentAndAttendanceDate(student, today)
                attendanceMap[student.id] = todaysAttendance
            }

            if (isHtmxRequest()) {
                render template: 'familyCheckIn', model: [
                    household: household,
                    students: students,
                    attendanceMap: attendanceMap,
                    today: today
                ]
            } else {
                [
                    household: household,
                    students: students,
                    attendanceMap: attendanceMap,
                    today: today
                ]
            }
        } catch (Exception e) {
            log.error("Error loading family for check-in: ${e.message}", e)
            if (isHtmxRequest()) {
                render status: 500, template: 'checkInError', model: [message: "Error loading family data"]
            } else {
                flash.error = "Error loading family data"
                redirect action: 'checkin'
            }
        }
    }

    /**
     * GET /universal/students
     * Student management page
     */
    def students() {
        try {
            def clubs = universalDataService.list(awana.Club)
            def studentCount = universalDataService.count(awana.Student)
            
            [
                clubs: clubs,
                studentCount: studentCount
            ]
        } catch (Exception e) {
            log.error("Error loading students page: ${e.message}", e)
            flash.error = "Error loading students page"
            redirect action: 'index'
        }
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
     * GET /universal/verseCompletion
     * Verse completion page
     */
    def verseCompletion() {
        try {
            def result = verseCompletionView(params)
            return result.model
        } catch (Exception e) {
            log.error("Error loading verse completion page: ${e.message}", e)
            flash.error = "Error loading verse completion page"
            redirect action: 'index'
        }
    }

    /**
     * GET /universal/chapterSections
     * Load chapter sections dynamically for verse completion
     */
    def chapterSections() {
        Long chapterId = params.long('chapter.id') ?: params.long('chapterId')
        
        if (!chapterId) {
            render status: 400, text: "Chapter ID is required"
            return
        }

        try {
            def chapter = universalDataService.getById(awana.Chapter, chapterId)
            if (!chapter) {
                render status: 404, text: "Chapter not found"
                return
            }

            def sections = chapter.chapterSections ?: []
            
            if (isHtmxRequest()) {
                render template: 'chapterSections', model: [sections: sections, chapter: chapter]
            } else if (isJsonRequest()) {
                render sections as JSON
            } else {
                render template: 'chapterSections', model: [sections: sections, chapter: chapter]
            }
        } catch (Exception e) {
            log.error("Error loading chapter sections: ${e.message}", e)
            render status: 500, text: "Error loading chapter sections"
        }
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
                    render(template: 'listTable', model: [result: result, domainName: domainName])
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
                    render(template: 'listItems', model: [instances: instances, domainName: domainName])
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
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            def instance = universalDataService.save(domainClass, params)
            
            if (instance) {
                if (isHtmxRequest()) {
                    // Render success template fragment for HTMX
                    render(template: 'createSuccess', model: [instance: instance, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render status: 201, contentType: 'application/json', text: (instance as JSON).toString()
                } else {
                    flash.success = "${domainName} created successfully"
                    redirect action: 'show', params: [domainName: domainName, id: instance.id]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 400, template: 'createError', model: [domainName: domainName, message: "Failed to create ${domainName}"]
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
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            def instance = universalDataService.update(domainClass, id, params)
            
            if (instance) {
                if (isHtmxRequest()) {
                    // Render updated template fragment for HTMX
                    render(template: 'updateSuccess', model: [instance: instance, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render instance as JSON
                } else {
                    flash.success = "${domainName} updated successfully"
                    redirect action: 'show', params: [domainName: domainName, id: id]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 400, template: 'updateError', model: [domainName: domainName, message: "Failed to update ${domainName}"]
                    return
                } else if (isJsonRequest()) {
                    render status: 400, text: "Failed to update ${domainName}"
                } else {
                    flash.error = "Failed to update ${domainName} or not found"
                    redirect action: 'list', params: [domainName: domainName]
                }
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

    // ====================================================================
    // DYNAMIC VIEW CLOSURE METHODS
    // ====================================================================

    private def checkInFamilyView(params) {
        String qrCode = params.qrCode ?: params.householdId
        
        if (!qrCode) {
            throw new IllegalArgumentException("QR Code or household ID required")
        }

        def household = awana.Household.findByQrCode(qrCode) ?: awana.Household.get(qrCode)
        if (!household) {
            throw new IllegalArgumentException("Family not found")
        }

        def students = household.getAllStudents()
        def today = new Date()
        def attendanceMap = [:]
        
        students.each { student ->
            def todaysAttendance = awana.Attendance.findByStudentAndAttendanceDate(student, today)
            attendanceMap[student.id] = todaysAttendance
        }

        return [
            template: 'familyCheckIn',
            model: [
                household: household,
                students: students, 
                attendanceMap: attendanceMap,
                today: today
            ]
        ]
    }

    private def studentSearchView(params) {
        def clubs = universalDataService.list(awana.Club)
        def students = []
        def title = "Student Search"
        def filter = params.filter
        def showAll = params.showAll == 'true'
        
        if (showAll) {
            students = universalDataService.list(awana.Student)
            title = "All Students"
        } else if (filter) {
            switch (filter) {
                case 'topPerformers':
                    students = awana.Student.list().sort { -it.calculateTotalBucks() }.take(10)
                    title = "Top Performers"
                    break
                case 'recentCompletions':
                    def recentCompletions = awana.SectionVerseCompletion.findAll(
                        "FROM SectionVerseCompletion WHERE completionDate >= :weekAgo ORDER BY completionDate DESC",
                        [weekAgo: new Date() - 7]
                    ).take(20)
                    students = recentCompletions.collect { it.student }.unique()
                    title = "Recent Verse Completions"
                    break
                case 'needsAttention':
                    students = awana.Student.list().findAll { it.calculateTotalBucks() < 5 }
                    title = "Students Needing Attention"
                    break
            }
        }
        
        // If showing filtered results, use the simple student list template
        if (showAll || filter) {
            return [
                template: 'studentList',
                model: [
                    students: students,
                    title: title
                ]
            ]
        } else {
            // Otherwise show the full search interface
            return [
                template: 'studentSearch',
                model: [
                    clubs: clubs,
                    studentCount: universalDataService.count(awana.Student)
                ]
            ]
        }
    }

    private def verseCompletionView(params) {
        Long studentId = params.long('studentId')
        String clubId = params.clubId
        
        def students = []
        def selectedStudent = null
        
        if (studentId) {
            selectedStudent = universalDataService.getById(awana.Student, studentId)
            students = [selectedStudent]
        } else if (clubId) {
            def club = universalDataService.getById(awana.Club, Long.valueOf(clubId))
            students = club?.students ?: []
        } else {
            students = universalDataService.list(awana.Student)
        }

        // Get available chapters for verse completion
        def clubs = universalDataService.list(awana.Club)
        def chapters = []
        
        // Get all chapters from all books across all clubs for now
        clubs.each { club ->
            club.books?.each { book ->
                chapters.addAll(book.chapters ?: [])
            }
        }

        return [
            template: 'verseCompletion',
            model: [
                students: students,
                selectedStudent: selectedStudent,
                clubs: clubs,
                chapters: chapters
            ]
        ]
    }

    private def studentProgressView(params) {
        Long studentId = params.long('studentId')
        
        if (!studentId) {
            throw new IllegalArgumentException("Student ID required")
        }
        
        def student = universalDataService.getById(awana.Student, studentId)
        if (!student) {
            throw new IllegalArgumentException("Student not found")
        }

        def completedSections = student.getCompletedSections()
        def attendanceHistory = student.attendances?.sort { -it.attendanceDate.time }
        def attendancePercentage = student.getAttendancePercentage()

        return [
            template: 'studentProgress',
            model: [
                student: student,
                completedSections: completedSections,
                attendanceHistory: attendanceHistory,
                attendancePercentage: attendancePercentage
            ]
        ]
    }

    private def storeTransactionView(params) {
        Long studentId = params.long('studentId')
        String action = params.action // 'browse', 'purchase', 'balance'
        
        def student = null
        if (studentId) {
            student = universalDataService.getById(awana.Student, studentId)
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
            template: 'storeTransaction', 
            model: [
                student: student,
                storeItems: storeItems,
                action: action ?: 'browse'
            ]
        ]
    }

    private def clubOverviewView(params) {
        Long clubId = params.long('clubId')
        
        def club = null
        def students = []
        
        if (clubId) {
            club = universalDataService.getById(awana.Club, clubId)
            students = club?.students?.toList() ?: []
        }

        def clubs = universalDataService.list(awana.Club)

        return [
            template: 'clubOverview',
            model: [
                club: club,
                clubs: clubs,
                students: students
            ]
        ]
    }

    private def attendanceRecordView(params) {
        String dateStr = params.date ?: new Date().format('yyyy-MM-dd')
        Date selectedDate = Date.parse('yyyy-MM-dd', dateStr)
        Long clubId = params.long('clubId')
        
        def club = null
        def attendanceRecords = []
        
        if (clubId) {
            club = universalDataService.getById(awana.Club, clubId)
            attendanceRecords = awana.Attendance.findAllByAttendanceDateAndStudentInList(
                selectedDate, 
                club.getActiveStudents()
            )
        } else {
            attendanceRecords = awana.Attendance.findAllByAttendanceDate(selectedDate)
        }

        def clubs = universalDataService.list(awana.Club)

        return [
            template: 'attendanceRecord',
            model: [
                selectedDate: selectedDate,
                club: club,
                clubs: clubs,
                attendanceRecords: attendanceRecords
            ]
        ]
    }

    // ====================================================================
    // PRIVATE HELPER METHODS
    // ====================================================================

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
                // Try without package
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