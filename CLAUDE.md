# Awana Club Management System

A Grails 6.2.3 PWA application for tracking Awana club members, attendance, and Awana bucks rewards system.

## About Awana
Awana is an international evangelical Christian nonprofit organization focused on child and youth discipleship. The name derives from "Approved Workmen Are Not Ashamed" (2 Timothy 2:15). This application manages club attendance, Bible verse memorization progress, and the Awana bucks reward system.

## Awana Club Age Ranges & Programs
- **Puggles:** Ages 2-3
- **Cubbies:** Ages 4-5 (Preschool)
- **Sparks:** Kindergarten - 2nd Grade
- **Truth & Training (T&T):** Grades 3-6
- **Trek:** Middle School (Grades 6-8)
- **Journey:** High School (Grades 9-12)

## Application Purpose
Track Awana club members' attendance, Bible verse memorization progress, handbook completion, and Awana bucks earned. Families can be quickly checked in via QR codes, and leaders can efficiently manage club activities and rewards.

## Scripts
- CSS build: `npm run build:css`
- Tests: `./gradlew test`
- Run: `./gradlew bootRun`

## Architecture
- Framework: Grails 6.2.3
- Frontend: HTMX + Tailwind CSS (mobile-first, minimal JS)
- Backend: Universal Data Service for CRUD operations
- Security: Spring Security
- PWA: Offline-capable with service workers

## Domain Structure & Relationships

### Core Domains

#### Household
- `String name` (family name)
- `String qrCode` (unique QR code for quick check-in)
- `String address`
- `String phoneNumber`
- `String email`
- `static hasMany = [students: Student]`

#### Student
- `String firstName`
- `String lastName`
- `Date dateOfBirth`
- `String profileImage` (nullable: true)
- `Integer awanaBucks = 0`
- `static belongsTo = [household: Household, club: Club]`
- `static hasMany = [attendances: Attendance, sectionVerseCompletions: SectionVerseCompletion]`

#### Club
- `String name` (e.g., "Cubbies", "Sparks", "T&T")
- `String ageRange` (e.g., "Ages 4-5", "K-2nd Grade")
- `static hasMany = [students: Student, books: Book]`
- `static belongsTo = [book: Book]`

#### Book
- `String name` (e.g., "HangGlider", "WingRunner", "SkyStormer")
- `String coverImage` (nullable: true)
- `static belongsTo = [club: Club]`
- `static hasMany = [chapters: Chapter]`

#### Chapter
- `String name`
- `Integer chapterNumber`
- `String chapterImage` (nullable: true)
- `String sectionVerse` (Bible verse for this chapter)
- `String parentVerse` (verse for parents to memorize)
- `static belongsTo = [book: Book]`
- `static hasMany = [chapterSections: ChapterSection]`

#### ChapterSection
- `String sectionNumber` (e.g., "1.2", "1.3", "1.4")
- `String content`
- `Boolean isSilverSection = false`
- `Boolean isGoldSection = false`
- `static belongsTo = [chapter: Chapter]`

#### Calendar
- `Date startDate` (e.g., September 10th)
- `Date endDate` (e.g., May 6th of following year)
- `String dayOfWeek` (e.g., "Wednesday")
- `Time startTime`
- `Time endTime`
- `String description` (e.g., "Fall 2024 Semester")

#### Attendance
- `Date attendanceDate`
- `Boolean present = false`
- `Boolean hasUniform = false`
- `Boolean hasBible = false`
- `Boolean hasHandbook = false`
- `Integer bucksEarned = 0` (calculated based on attendance criteria)
- `static belongsTo = [student: Student, calendar: Calendar]`

#### SectionVerseCompletion
- `Date completionDate`
- `Boolean studentCompleted = false`
- `Boolean parentCompleted = false`
- `Boolean silverSectionCompleted = false`
- `Boolean goldSectionCompleted = false`
- `Integer bucksEarned = 0` (calculated based on completion type)
- `static belongsTo = [student: Student, chapterSection: ChapterSection]`

## Awana Bucks Earning System
- **Present at club:** 1 Awana buck
- **Has uniform:** 1 Awana buck
- **Brought Bible and handbook:** 1 Awana buck
- **Student completes section verse:** 1 Awana buck
- **Parent memorizes section verse:** 2 Awana bucks (student receives)
- **Completes silver section:** 1 Awana buck
- **Completes gold section:** 3 Awana bucks

## Key Helper Methods Needed
- `Student.calculateTotalBucks()` - Sum all bucksEarned from attendance and completions
- `Attendance.calculateBucksEarned()` - Auto-calculate based on present/uniform/bible/handbook
- `SectionVerseCompletion.calculateBucksEarned()` - Auto-calculate based on completion types
- `Household.getAllStudents()` - Get all students for QR code check-in
- `Calendar.getCurrentSemesterDates()` - Get active Awana schedule

## Business Logic Flow
1. **Check-In:** Scan household QR code → Display all students in household
2. **Attendance:** Mark present, uniform, Bible, handbook → Auto-calculate attendance bucks
3. **Club Time:** Leaders verify verse memorization, silver/gold completion → Record in SectionVerseCompletion
4. **Buck Calculation:** Real-time calculation of total bucks via helper methods
5. **Awana Store:** End-of-semester spending of accumulated bucks