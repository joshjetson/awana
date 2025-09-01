<div class="min-h-screen bg-gray-50 pb-20">
    <!-- Header -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-4 py-6">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-2">Verse Completion</h1>
            <div class="text-purple-100">
                Track Bible verse memorization and handbook progress
            </div>
        </div>
    </div>

    <div class="max-w-4xl mx-auto px-4 py-6 space-y-6">
        
        <!-- Student Selection Card -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4">Select Student</h2>
            
            <g:set var="searchIcon">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
            </g:set>

            <g:render template="/components/touchInput" model="[
                name: 'studentSearch',
                label: 'Search for Student',
                placeholder: 'Enter student name...',
                type: 'text',
                icon: searchIcon,
                id: 'student-search-input'
            ]"/>

            <div id="student-search-results" class="mt-4 space-y-3">
                <g:each in="${students}" var="student">
                    <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 cursor-pointer student-card" 
                         data-student-id="${student.id}"
                         onclick="selectStudent(${student.id})">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center text-white font-bold">
                                    ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                                </div>
                                <div>
                                    <h3 class="font-semibold text-gray-900">${student.firstName} ${student.lastName}</h3>
                                    <p class="text-sm text-gray-600">${student.club.name} • ${student.getAge()} years old</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-lg font-bold text-green-600">
                                    ${student.calculateTotalBucks()} bucks
                                </div>
                                <div class="text-sm text-gray-600">Total earned</div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>

        <!-- Verse Completion Form (Initially Hidden) -->
        <div id="verse-completion-form" class="bg-white rounded-xl shadow-lg p-6" style="display: none;">
            <div id="selected-student-info" class="mb-6">
                <!-- Student info will be populated here -->
            </div>

            <h3 class="text-lg font-bold text-gray-900 mb-4">Record Verse Completion</h3>

            <!-- Chapter Selection -->
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Chapter</label>
                <select name="chapterId" 
                        id="chapter-select" 
                        class="w-full p-3 border border-gray-300 rounded-lg text-lg"
                        hx-get="/renderView?viewType=chapterSections"
                        hx-trigger="change"
                        hx-target="#sections-container"
                        hx-swap="innerHTML">
                    <option value="">Choose a chapter...</option>
                    <g:each in="${chapters}" var="chapter">
                        <option value="${chapter.id}">${chapter.name}</option>
                    </g:each>
                </select>
            </div>

            <!-- Section Selection -->
            <div id="section-selection" class="mb-6" style="display: none;">
                <label class="block text-sm font-medium text-gray-700 mb-2">Chapter Sections</label>
                <div id="sections-container" 
                     class="space-y-3"
                     hx-on::after-request="if(event.detail.successful && this.innerHTML.trim() !== '') { document.getElementById('section-selection').style.display = 'block'; }">
                    <!-- Sections will be loaded here -->
                </div>
            </div>

            <!-- Completion Types -->
            <div id="completion-types" class="space-y-4" style="display: none;">
                <h4 class="font-semibold text-gray-900">Mark Completions</h4>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Student Verse -->
                    <g:set var="studentIcon">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </g:set>
                    
                    <g:render template="/components/touchToggle" model="[
                        id: 'student-completed',
                        text: 'Student Verse',
                        subtext: '+1 buck',
                        icon: studentIcon,
                        color: 'blue',
                        onclick: 'toggleCompletion(\"student\")'
                    ]"/>

                    <!-- Parent Verse -->
                    <g:set var="parentIcon">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                        </svg>
                    </g:set>
                    
                    <g:render template="/components/touchToggle" model="[
                        id: 'parent-completed',
                        text: 'Parent Verse',
                        subtext: '+2 bucks',
                        icon: parentIcon,
                        color: 'purple',
                        onclick: 'toggleCompletion(\"parent\")'
                    ]"/>

                    <!-- Silver Section -->
                    <g:set var="silverIcon">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </g:set>
                    
                    <g:render template="/components/touchToggle" model="[
                        id: 'silver-completed',
                        text: 'Silver Section',
                        subtext: '+1 buck',
                        icon: silverIcon,
                        color: 'blue',
                        onclick: 'toggleCompletion(\"silver\")'
                    ]"/>

                    <!-- Gold Section -->
                    <g:set var="goldIcon">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                        </svg>
                    </g:set>
                    
                    <g:render template="/components/touchToggle" model="[
                        id: 'gold-completed',
                        text: 'Gold Section',
                        subtext: '+3 bucks',
                        icon: goldIcon,
                        color: 'yellow',
                        onclick: 'toggleCompletion(\"gold\")'
                    ]"/>
                </div>
            </div>

            <!-- Save Button -->
            <div class="mt-8">
                <g:set var="saveIcon">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                </g:set>
                
                <g:render template="/components/touchButton" model="[
                    text: 'Save Verse Completion',
                    style: 'success',
                    size: 'lg',
                    icon: saveIcon,
                    onclick: 'saveVerseCompletion()',
                    id: 'save-completion-btn',
                    disabled: true
                ]"/>
            </div>
        </div>

        <!-- Success Message (Hidden) -->
        <div id="success-message" style="display: none;">
            <g:render template="/components/alertMessage" model="[
                type: 'success',
                title: 'Verse Completion Recorded!',
                message: 'Student progress has been saved successfully.',
                dismissible: true
            ]"/>
        </div>
    </div>
</div>

<!-- Bottom Navigation -->
<g:render template="/components/bottomNavBar" model="[currentPage: 'students']"/>

<script>
let selectedStudentId = null;
let selectedChapterId = null;
let selectedSectionId = null;
let completions = {
    student: false,
    parent: false,
    silver: false,
    gold: false
};

function selectStudent(studentId) {
    selectedStudentId = studentId;
    
    // Highlight selected student
    document.querySelectorAll('.student-card').forEach(card => {
        card.classList.remove('ring-2', 'ring-blue-500', 'bg-blue-50');
    });
    
    const selectedCard = document.querySelector(`[data-student-id="${studentId}"]`);
    selectedCard.classList.add('ring-2', 'ring-blue-500', 'bg-blue-50');
    
    // Show verse completion form
    document.getElementById('verse-completion-form').style.display = 'block';
    
    // Populate student info
    const studentInfo = selectedCard.innerHTML;
    document.getElementById('selected-student-info').innerHTML = `
        <div class="border-l-4 border-blue-500 pl-4">
            <h3 class="font-semibold text-gray-900">Selected Student:</h3>
            ${studentInfo}
        </div>
    `;
    
    // Scroll to form
    document.getElementById('verse-completion-form').scrollIntoView({ behavior: 'smooth' });
}


function selectSection(sectionId) {
    selectedSectionId = sectionId;
    
    // Highlight selected section
    document.querySelectorAll('.section-card').forEach(card => {
        card.classList.remove('ring-2', 'ring-purple-500', 'bg-purple-50');
    });
    
    const selectedSection = document.querySelector(`[data-section-id="${sectionId}"]`);
    selectedSection.classList.add('ring-2', 'ring-purple-500', 'bg-purple-50');
    
    // Show completion types
    document.getElementById('completion-types').style.display = 'block';
    updateSaveButton();
}

function toggleCompletion(type) {
    completions[type] = !completions[type];
    
    const toggle = document.getElementById(`${type}-completed`);
    if (completions[type]) {
        toggle.classList.add('bg-green-500', 'text-white');
        toggle.classList.remove('bg-gray-200', 'text-gray-700');
    } else {
        toggle.classList.remove('bg-green-500', 'text-white');
        toggle.classList.add('bg-gray-200', 'text-gray-700');
    }
    
    updateSaveButton();
}

function updateSaveButton() {
    const hasCompletions = Object.values(completions).some(c => c);
    const hasSelection = selectedStudentId && selectedSectionId;
    const saveBtn = document.getElementById('save-completion-btn');
    
    if (hasCompletions && hasSelection) {
        saveBtn.disabled = false;
        saveBtn.classList.remove('opacity-50', 'cursor-not-allowed');
    } else {
        saveBtn.disabled = true;
        saveBtn.classList.add('opacity-50', 'cursor-not-allowed');
    }
}

function saveVerseCompletion() {
    if (!selectedStudentId || !selectedSectionId) return;
    
    const data = {
        'student.id': selectedStudentId,
        'chapterSection.id': selectedSectionId,
        completionDate: new Date().toISOString(),
        studentCompleted: completions.student,
        parentCompleted: completions.parent,
        silverSectionCompleted: completions.silver,
        goldSectionCompleted: completions.gold,
        bucksEarned: calculateBucksEarned()
    };
    
    // Save via HTMX
    htmx.ajax('POST', '/api/universal/SectionVerseCompletion', {
        values: data,
        target: '#success-message'
    }).then(() => {
        document.getElementById('success-message').style.display = 'block';
        resetForm();
        
        // Scroll to success message
        document.getElementById('success-message').scrollIntoView({ behavior: 'smooth' });
    });
}

function calculateBucksEarned() {
    let bucks = 0;
    if (completions.student) bucks += 1;
    if (completions.parent) bucks += 2;
    if (completions.silver) bucks += 1;
    if (completions.gold) bucks += 3;
    return bucks;
}

function resetForm() {
    selectedStudentId = null;
    selectedChapterId = null;
    selectedSectionId = null;
    completions = { student: false, parent: false, silver: false, gold: false };
    
    document.getElementById('verse-completion-form').style.display = 'none';
    document.getElementById('chapter-select').value = '';
    document.getElementById('section-selection').style.display = 'none';
    document.getElementById('completion-types').style.display = 'none';
    
    document.querySelectorAll('.student-card').forEach(card => {
        card.classList.remove('ring-2', 'ring-blue-500', 'bg-blue-50');
    });
}

// Search functionality
document.getElementById('student-search-input').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    document.querySelectorAll('.student-card').forEach(card => {
        const studentName = card.textContent.toLowerCase();
        if (studentName.includes(searchTerm)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
});
</script>