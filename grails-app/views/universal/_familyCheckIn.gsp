<!-- Family Check-In Card -->
<div class="bg-white rounded-2xl shadow-xl p-6 border-l-4 border-blue-500 animate-fade-in">
    <!-- Family Header -->
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center space-x-4">
            <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-500 
                        rounded-full flex items-center justify-center text-white font-bold text-xl">
                ${household.name.substring(0, 2).toUpperCase()}
            </div>
            <div>
                <h2 class="text-2xl font-bold text-gray-900">${household.name}</h2>
                <p class="text-gray-600">${students.size()} children • ${household.qrCode}</p>
            </div>
        </div>
        <div class="text-right">
            <div class="text-2xl font-bold text-green-600">
                ${household.getTotalFamilyBucks()} bucks
            </div>
            <div class="text-sm text-gray-500">Family Total</div>
        </div>
    </div>

    <!-- Students Check-In List -->
    <div class="space-y-4">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Check In Children:</h3>
        
        <g:each in="${students}" var="student">
            <div class="border border-gray-200 rounded-xl p-4 hover:bg-gray-50 transition-colors">
                <!-- Student Header -->
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 bg-gradient-to-br from-orange-400 to-pink-500 
                                    rounded-full flex items-center justify-center text-white font-bold">
                            ${student.firstName.substring(0, 1)}${student.lastName.substring(0, 1)}
                        </div>
                        <div>
                            <div class="font-bold text-gray-900 text-lg">${student.getFullName()}</div>
                            <div class="text-sm text-gray-600">
                                ${student.club.name} • Age ${student.getAge()} • ${student.calculateTotalBucks()} bucks
                            </div>
                        </div>
                    </div>
                    
                    <!-- Current Status -->
                    <g:set var="attendance" value="${attendanceMap[student.id]}"/>
                    <div class="text-right">
                        <g:if test="${attendance?.present}">
                            <div class="flex items-center text-green-600">
                                <svg class="w-5 h-5 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                </svg>
                                <span class="font-medium">Checked In</span>
                            </div>
                        </g:if>
                        <g:else>
                            <div class="flex items-center text-gray-500">
                                <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <span class="font-medium">Not Checked In</span>
                            </div>
                        </g:else>
                    </div>
                </div>

                <!-- Check-In Options (Touch-Optimized Toggles) -->
                <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                    
                    <!-- Present Toggle -->
                    <button onclick="toggleAttendance(${student.id}, 'present')"
                            id="present-${student.id}"
                            class="attendance-toggle ${attendance?.present ? 'bg-green-500 text-white' : 'bg-gray-100 text-gray-700'}
                                   min-h-[60px] rounded-lg font-medium transition-all duration-200
                                   hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                                   flex flex-col items-center justify-center space-y-1">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        <span class="text-sm">Present</span>
                        <span class="text-xs font-bold">+1 buck</span>
                    </button>

                    <!-- Uniform Toggle -->
                    <button onclick="toggleAttendance(${student.id}, 'uniform')"
                            id="uniform-${student.id}"
                            class="attendance-toggle ${attendance?.hasUniform ? 'bg-blue-500 text-white' : 'bg-gray-100 text-gray-700'}
                                   min-h-[60px] rounded-lg font-medium transition-all duration-200
                                   hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                                   flex flex-col items-center justify-center space-y-1">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zM7 3H5a2 2 0 00-2 2v12a4 4 0 004 4h2V3z"/>
                        </svg>
                        <span class="text-sm">Uniform</span>
                        <span class="text-xs font-bold">+1 buck</span>
                    </button>

                    <!-- Bible Toggle -->
                    <button onclick="toggleAttendance(${student.id}, 'bible')"
                            id="bible-${student.id}"
                            class="attendance-toggle ${attendance?.hasBible ? 'bg-purple-500 text-white' : 'bg-gray-100 text-gray-700'}
                                   min-h-[60px] rounded-lg font-medium transition-all duration-200
                                   hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                                   flex flex-col items-center justify-center space-y-1">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                        </svg>
                        <span class="text-sm">Bible</span>
                        <span class="text-xs">& Handbook</span>
                    </button>

                    <!-- Handbook Toggle (combined with Bible) -->
                    <button onclick="toggleAttendance(${student.id}, 'handbook')"
                            id="handbook-${student.id}"
                            class="attendance-toggle ${attendance?.hasHandbook ? 'bg-orange-500 text-white' : 'bg-gray-100 text-gray-700'}
                                   min-h-[60px] rounded-lg font-medium transition-all duration-200
                                   hover:scale-105 active:scale-95 shadow-sm hover:shadow-md
                                   flex flex-col items-center justify-center space-y-1">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        <span class="text-sm">Handbook</span>
                        <span class="text-xs font-bold">+1 buck</span>
                    </button>
                </div>

                <!-- Potential Bucks for This Student -->
                <div class="mt-4 bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                    <div class="flex items-center justify-between">
                        <span class="text-yellow-800 font-medium">Tonight's Potential:</span>
                        <span id="potential-bucks-${student.id}" class="text-yellow-900 font-bold">
                            ${(attendance?.present ? 1 : 0) + (attendance?.hasUniform ? 1 : 0) + ((attendance?.hasBible && attendance?.hasHandbook) ? 1 : 0)} bucks
                        </span>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

    <!-- Complete Check-In Button -->
    <div class="mt-6 pt-6 border-t border-gray-200">
        <button onclick="completeCheckIn('${household.qrCode}')"
                class="w-full bg-gradient-to-r from-green-600 to-blue-600 
                       hover:from-green-700 hover:to-blue-700 
                       text-white font-bold py-4 px-6 rounded-xl text-xl
                       transition-all duration-200 transform hover:scale-105
                       shadow-lg hover:shadow-xl">
            <svg class="w-6 h-6 inline mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
            Complete Family Check-In
        </button>
    </div>
</div>

<script>
// Toggle attendance attributes for student
function toggleAttendance(studentId, attribute) {
    const button = document.getElementById(attribute + '-' + studentId);
    const isActive = button.classList.contains('bg-green-500') || 
                    button.classList.contains('bg-blue-500') || 
                    button.classList.contains('bg-purple-500') || 
                    button.classList.contains('bg-orange-500');
    
    // Toggle button state
    if (isActive) {
        // Deactivate
        button.className = button.className.replace(/(bg-\w+-500)/g, 'bg-gray-100')
                                         .replace('text-white', 'text-gray-700');
    } else {
        // Activate with appropriate color
        const colorMap = {
            'present': 'bg-green-500 text-white',
            'uniform': 'bg-blue-500 text-white', 
            'bible': 'bg-purple-500 text-white',
            'handbook': 'bg-orange-500 text-white'
        };
        
        button.className = button.className.replace(/bg-gray-100 text-gray-700/g, colorMap[attribute]);
    }
    
    // Update potential bucks calculation
    updatePotentialBucks(studentId);
    
    // TODO: Send HTMX request to update attendance record
    console.log('Toggle', attribute, 'for student', studentId, 'to', !isActive);
}

// Calculate and display potential bucks for student
function updatePotentialBucks(studentId) {
    const presentBtn = document.getElementById('present-' + studentId);
    const uniformBtn = document.getElementById('uniform-' + studentId);
    const bibleBtn = document.getElementById('bible-' + studentId);
    const handbookBtn = document.getElementById('handbook-' + studentId);
    
    let bucks = 0;
    
    if (presentBtn.classList.contains('bg-green-500')) bucks += 1;
    if (uniformBtn.classList.contains('bg-blue-500')) bucks += 1;
    if (bibleBtn.classList.contains('bg-purple-500') && handbookBtn.classList.contains('bg-orange-500')) bucks += 1;
    
    document.getElementById('potential-bucks-' + studentId).textContent = bucks + ' bucks';
}

// Complete check-in for entire family
function completeCheckIn(qrCode) {
    // TODO: Send all attendance data via HTMX POST
    alert('Check-in completed! (TODO: Implement save functionality)');
    
    // Show success message and return to main screen
    document.getElementById('family-checkin-area').innerHTML = `
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-xl text-center">
            <div class="flex items-center justify-center mb-2">
                <svg class="w-8 h-8 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                </svg>
            </div>
            <div class="font-bold text-lg">Family Successfully Checked In!</div>
            <div class="text-sm mt-1">Attendance recorded and Awana bucks calculated</div>
        </div>
    `;
    
    // Clear the QR input for next family
    document.getElementById('qr-input').value = '';
}
</script>