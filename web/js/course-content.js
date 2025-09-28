<<<<<<< HEAD
// Modal functions
function openCreateModuleModal() {
    resetForm();
    document.getElementById('createModuleModal').classList.add('show');
    document.body.style.overflow = 'hidden';

    // set action về addModule
    document.getElementById("moduleForm").action = "addModule";
    document.getElementById("moduleId").value = "";
    
     const submitBtn = document.getElementById('submitBtn');
      submitBtn.textContent = 'Tạo Module';
}

function editModule(moduleId, title, description) {
    document.getElementById('createModuleModal').classList.add('show');
    document.body.style.overflow = 'hidden';
     const submitBtn = document.getElementById('submitBtn');

    // set form action về updateModule
    document.getElementById("moduleForm").action = "UpdateModule";
    document.getElementById("moduleId").value = moduleId;
    document.getElementById("moduleName").value = title;
    document.getElementById("moduleDescription").value = description;
    
     submitBtn.textContent = 'Lưu thay đổi';
}

function closeCreateModuleModal() {
    document.getElementById('createModuleModal').classList.remove('show');
    document.body.style.overflow = 'auto';
    resetForm();
}

// Close modal when clicking outside
document.getElementById('createModuleModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeCreateModuleModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeCreateModuleModal();
    }
});



function resetForm() {
    document.getElementById('moduleForm').reset();
}

function viewModule(moduleId) {
    alert(`Xem chi tiết Module ${moduleId}`);
    // Implement view functionality
}

=======
// Modal functions
function openCreateModuleModal() {
    resetForm();
    document.getElementById('createModuleModal').classList.add('show');
    document.body.style.overflow = 'hidden';

    // set action về addModule
    document.getElementById("moduleForm").action = "addModule";
    document.getElementById("moduleId").value = "";
    
     const submitBtn = document.getElementById('submitBtn');
      submitBtn.textContent = 'Tạo Module';
}

function editModule(moduleId, title, description) {
    document.getElementById('createModuleModal').classList.add('show');
    document.body.style.overflow = 'hidden';
     const submitBtn = document.getElementById('submitBtn');

    // set form action về updateModule
    document.getElementById("moduleForm").action = "UpdateModule";
    document.getElementById("moduleId").value = moduleId;
    document.getElementById("moduleName").value = title;
    document.getElementById("moduleDescription").value = description;
    
     submitBtn.textContent = 'Lưu thay đổi';
}

function closeCreateModuleModal() {
    document.getElementById('createModuleModal').classList.remove('show');
    document.body.style.overflow = 'auto';
    resetForm();
}

// Close modal when clicking outside
document.getElementById('createModuleModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeCreateModuleModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeCreateModuleModal();
    }
});



function resetForm() {
    document.getElementById('moduleForm').reset();
}

function viewModule(moduleId) {
    alert(`Xem chi tiết Module ${moduleId}`);
    // Implement view functionality
}

>>>>>>> 4a28538 (feat: Add course-management and manager-profile)
