# SSE Live Student Check-In Implementation Plan

## Goal
Implement Server-Sent Events (SSE) to display student names in real-time on the dashboard when they check in. The Live Updates section will show one student name at a time in big bold text, and each checked-in student will be added to "Today's Roster" section.

## Architecture Overview
- **SSE Endpoint**: `/universal/sse` in UniversalController
- **Event Types**: `student-checkin`, `roster-update`
- **Data Flow**: Check-in → SSE event → Dashboard Live Updates + Today's Roster
- **Frontend**: HTMX SSE integration (already available in application.js)

---

## Phase 1: Basic SSE Infrastructure ✅ READY TO IMPLEMENT
**Goal**: Create basic SSE endpoint and test connection

### Implementation:
1. **Add SSE endpoint to UniversalController**
   ```groovy
   @Secured(['permitAll'])
   def sse() {
       response.contentType = MediaType.TEXT_EVENT_STREAM_VALUE
       response.characterEncoding = "UTF-8"
       response.setHeader("Cache-Control", "no-cache")
       response.setHeader("Connection", "keep-alive")

       // Simple test event loop
       while (true) {
           sseEvent(eventType: 'heartbeat', data: 'connected')
           sleep(5000)
       }
   }

   private void sseEvent(Map args) {
       String eventType = args.eventType ?: 'message'
       String data = args.data ?: ''

       response.writer.with {
           write("event: ${eventType}\ndata: ${data}\n\n")
           flush()
       }
   }
   ```

2. **Add SSE connection to dashboard**
   - Update dashboard.gsp to include SSE connection div
   - Add HTMX SSE attributes to connect to `/universal/sse`

### Test Criteria:
- Dashboard connects to SSE endpoint
- Browser dev tools shows SSE connection active
- Heartbeat events received every 5 seconds

---

## Phase 2: Live Updates Section UI ✅ READY TO IMPLEMENT
**Goal**: Create the Live Updates section on dashboard

### Implementation:
1. **Add Live Updates section to dashboard.gsp**
   ```html
   <div class="bg-blue-600 text-white p-6 rounded-lg mb-6">
       <h2 class="text-2xl font-bold mb-4">Live Updates</h2>
       <div id="live-student-name"
            class="text-4xl font-bold text-center min-h-[4rem] flex items-center justify-center"
            hx-ext="sse"
            sse-connect="/universal/sse"
            sse-swap="student-checkin">
           <span class="text-blue-200">Waiting for check-ins...</span>
       </div>
   </div>
   ```

2. **Add Today's Roster section**
   ```html
   <div class="bg-white border rounded-lg p-4 mb-6">
       <h3 class="text-lg font-semibold mb-3">Today's Roster</h3>
       <div id="todays-roster"
            sse-swap="roster-update"
            class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-2">
           <!-- Student names will appear here -->
       </div>
   </div>
   ```

### Test Criteria:
- Live Updates section appears on dashboard
- Today's Roster section appears on dashboard
- SSE connection established between sections and endpoint

---

## Phase 3: Student Check-In Detection ✅ READY TO IMPLEMENT
**Goal**: Detect when students are checked in and trigger SSE events

### Implementation:
1. **Create SSE event service**
   ```groovy
   // In UniversalController or separate service
   private static final List<PrintWriter> sseClients = Collections.synchronizedList([])

   static void broadcastStudentCheckin(Student student) {
       String studentName = "${student.firstName} ${student.lastName}"
       String eventData = groovy.json.JsonBuilder([
           studentName: studentName,
           studentId: student.id,
           timestamp: new Date().time
       ]).toString()

       synchronized(sseClients) {
           sseClients.removeAll { client ->
               try {
                   client.write("event: student-checkin\ndata: ${eventData}\n\n")
                   client.flush()
                   return false // Keep client
               } catch (Exception e) {
                   return true // Remove dead client
               }
           }
       }
   }
   ```

2. **Integrate with attendance creation**
   - Modify attendance save/update logic in UniversalController
   - Trigger `broadcastStudentCheckin()` when attendance is marked present
   - Only trigger for new check-ins (present = true)

3. **Update SSE endpoint to manage clients**
   ```groovy
   def sse() {
       response.contentType = MediaType.TEXT_EVENT_STREAM_VALUE
       response.characterEncoding = "UTF-8"
       response.setHeader("Cache-Control", "no-cache")
       response.setHeader("Connection", "keep-alive")

       PrintWriter writer = response.writer
       sseClients.add(writer)

       try {
           while (true) {
               writer.write("event: heartbeat\ndata: connected\n\n")
               writer.flush()
               sleep(30000) // 30 second heartbeat
           }
       } catch (Exception e) {
           log.debug "SSE client disconnected: ${e.message}"
       } finally {
           sseClients.remove(writer)
       }
   }
   ```

### Test Criteria:
- Check in a student via family check-in
- Student name appears in Live Updates section
- No errors in server logs

---

## Phase 4: Today's Roster Integration ✅ READY TO IMPLEMENT
**Goal**: Build and maintain today's roster list

### Implementation:
1. **Add roster update broadcasting**
   ```groovy
   static void broadcastRosterUpdate() {
       // Get today's attendance records where present = true
       Date today = new Date().clearTime()
       Date tomorrow = today + 1

       def attendances = Attendance.findAllByAttendanceDateBetweenAndPresent(
           today, tomorrow, true
       )

       List<Map> roster = attendances.collect { attendance ->
           [
               studentName: "${attendance.student.firstName} ${attendance.student.lastName}",
               studentId: attendance.student.id,
               club: attendance.student.club?.name
           ]
       }

       String eventData = new groovy.json.JsonBuilder(roster).toString()

       synchronized(sseClients) {
           sseClients.removeAll { client ->
               try {
                   client.write("event: roster-update\ndata: ${eventData}\n\n")
                   client.flush()
                   return false
               } catch (Exception e) {
                   return true
               }
           }
       }
   }
   ```

2. **Update attendance integration**
   - Call `broadcastRosterUpdate()` after `broadcastStudentCheckin()`
   - Ensure roster stays in sync with check-ins

3. **Add roster template**
   ```html
   <!-- In _todaysRoster.gsp -->
   <g:each in="${roster}" var="student">
       <div class="bg-gray-100 px-3 py-2 rounded text-sm">
           <div class="font-medium">${student.studentName}</div>
           <div class="text-gray-600 text-xs">${student.club}</div>
       </div>
   </g:each>
   ```

### Test Criteria:
- Check in multiple students
- Each student appears in Live Updates briefly
- All checked-in students appear in Today's Roster
- Roster updates after each check-in

---

## Phase 5: Error Handling & Polish ✅ READY TO IMPLEMENT
**Goal**: Add robust error handling and UI polish

### Implementation:
1. **Connection error handling**
   - Handle SSE disconnections gracefully
   - Automatic reconnection on connection loss
   - Fallback UI when SSE unavailable

2. **UI enhancements**
   - Smooth transitions between student names
   - Visual indicators for new check-ins
   - Empty state handling

3. **Performance optimization**
   - Limit SSE client connections
   - Memory cleanup for dead connections
   - Efficient database queries

### Test Criteria:
- SSE works reliably over extended periods
- Graceful handling of network interruptions
- Clean UI transitions and animations

---

## Technical Notes

### SSE Event Structure:
```
event: student-checkin
data: {"studentName": "John Doe", "studentId": 123, "timestamp": 1695123456789}

event: roster-update
data: [{"studentName": "John Doe", "studentId": 123, "club": "Sparks"}, ...]

event: heartbeat
data: connected
```

### Integration Points:
1. **UniversalController** - SSE endpoint and broadcasting
2. **Attendance save/update** - Trigger events on check-in
3. **Dashboard** - SSE consumption and display
4. **UniversalDataService** - Data retrieval for roster

### Dependencies:
- ✅ HTMX (already available)
- ✅ HTMX SSE extension (already in application.js)
- ✅ UniversalDataService (already available)
- ✅ Attendance domain model (already available)

---

## Current Status: Phase 1 Ready
Ready to implement Phase 1 - Basic SSE Infrastructure. Each phase will be implemented and tested before moving to the next phase.
