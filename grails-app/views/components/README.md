# Touch-Optimized Component Library

This directory contains reusable GSP templates optimized for touch devices and mobile-first design. All components follow the design principles established for the Awana Club Management System.

## Component Overview

### 1. Touch Button (`_touchButton.gsp`)
Large, touch-friendly buttons with proper accessibility and visual feedback.

**Usage:**
```gsp
<g:render template="/components/touchButton" model="[
    text: 'Check In Family',
    style: 'success', 
    size: 'lg',
    icon: qrIcon,
    onclick: 'checkInFamily()'
]"/>
```

**Parameters:**
- `text`: Button text (required)
- `style`: primary, secondary, success, warning, danger (default: primary)
- `size`: sm, md, lg, xl (default: md)
- `onclick`: JavaScript function (optional)
- `href`: Link URL (makes it a link button)
- `icon`: SVG icon HTML (optional)
- `disabled`: Boolean (optional)
- `fullWidth`: Boolean (optional, default true)

### 2. Touch Toggle (`_touchToggle.gsp`) 
Toggle buttons for attendance, preferences, etc. Like the attendance toggles in check-in.

**Usage:**
```gsp
<g:render template="/components/touchToggle" model="[
    id: 'present-${student.id}',
    text: 'Present',
    subtext: '+1 buck',
    icon: presentIcon,
    active: attendance.present,
    color: 'green',
    onclick: 'togglePresent(${student.id})'
]"/>
```

### 3. Touch Input (`_touchInput.gsp`)
Large, accessible form inputs optimized for touch devices.

**Usage:**
```gsp
<g:render template="/components/touchInput" model="[
    name: 'qrCode',
    label: 'Family QR Code',
    placeholder: 'Enter QR Code (e.g., HH-ABC123)',
    type: 'text',
    icon: qrIcon,
    required: true
]"/>
```

### 4. Status Card (`_statusCard.gsp`)
Dashboard cards for displaying stats, metrics, and clickable information.

**Usage:**
```gsp
<g:render template="/components/statusCard" model="[
    title: 'Active Students',
    value: '47',
    subtitle: 'checked in tonight',
    icon: studentsIcon,
    color: 'blue',
    clickable: true,
    href: '/students'
]"/>
```

### 5. Student Card (`_studentCard.gsp`)
Displays student information in lists, search results, etc.

**Usage:**
```gsp
<g:render template="/components/studentCard" model="[
    student: studentObject,
    showBucks: true,
    showAttendance: true,
    clickable: true,
    href: '/students/${student.id}'
]"/>
```

### 6. Bottom Nav Bar (`_bottomNavBar.gsp`)
Mobile-first bottom navigation with 5 main sections.

**Usage:**
```gsp
<g:render template="/components/bottomNavBar" model="[
    currentPage: 'dashboard'
]"/>
```

**Pages:** dashboard, checkin, students, store, reports

### 7. Alert Message (`_alertMessage.gsp`)
Success, error, warning, and info messages with proper styling.

**Usage:**
```gsp
<g:render template="/components/alertMessage" model="[
    type: 'success',
    title: 'Check-in Complete!',
    message: 'Johnson family has been successfully checked in.',
    dismissible: true
]"/>
```

## Design Principles

### Touch Targets
- **Minimum 44px height** for all interactive elements
- **60px+ height** for primary actions
- **Generous padding** around touch areas
- **Visual feedback** on hover/active states

### Colors
- **Primary:** Blue (actions, links)
- **Success:** Green (check-ins, confirmations)
- **Warning:** Yellow (alerts, attention needed)
- **Danger:** Red (errors, deletions)
- **Purple:** Verse/progress related
- **Orange:** Store/rewards related

### Typography
- **Large text** for mobile readability
- **Bold weights** for important information  
- **Clear hierarchy** with consistent sizing

### Animations
- **Hover effects:** Scale and shadow changes
- **Active states:** Slight scale down for tactile feedback
- **Fade-in animations** for new content
- **Smooth transitions** (200ms duration)

## Usage Examples

### Check-In Interface
```gsp
<!-- QR Input -->
<g:render template="/components/touchInput" model="[
    name: 'qrCode',
    label: 'Family QR Code',
    placeholder: 'Scan or enter QR code',
    icon: qrIcon
]"/>

<!-- Scan Button -->
<g:render template="/components/touchButton" model="[
    text: 'Find Family',
    style: 'success',
    size: 'lg',
    icon: searchIcon,
    onclick: 'scanQRCode()'
]"/>

<!-- Attendance Toggles -->
<div class="grid grid-cols-2 md:grid-cols-4 gap-3">
    <g:render template="/components/touchToggle" model="[
        id: 'present-${student.id}',
        text: 'Present', 
        subtext: '+1 buck',
        color: 'green',
        onclick: 'toggleAttendance(${student.id}, \"present\")'
    ]"/>
</div>
```

### Dashboard Stats
```gsp
<div class="grid grid-cols-2 md:grid-cols-4 gap-4">
    <g:render template="/components/statusCard" model="[
        title: 'Students',
        value: '${studentCount}',
        subtitle: 'Active',
        color: 'blue',
        clickable: true,
        href: '/students'
    ]"/>
</div>
```

### Student Lists
```gsp
<div class="space-y-3">
    <g:each in="${students}" var="student">
        <g:render template="/components/studentCard" model="[
            student: student,
            showBucks: true,
            clickable: true,
            href: '/students/${student.id}'
        ]"/>
    </g:each>
</div>
```

## Best Practices

1. **Always use components** instead of custom HTML for consistency
2. **Test on touch devices** to ensure proper finger accessibility  
3. **Provide visual feedback** for all interactions
4. **Use semantic colors** that match the action (green=success, red=danger)
5. **Keep touch targets large** especially for primary actions
6. **Add loading states** for HTMX interactions
7. **Include error handling** with appropriate alert messages