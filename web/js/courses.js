// ===== Modal khóa học (dùng chung cho tạo mới và sửa) =====

// Mở modal tạo khóa học mới
function openCreateCourseModal() {
 const form = document.getElementById('courseForm');
    const modalTitle = document.getElementById('modalTitle');
    const submitBtn = document.getElementById('submitBtn');

    form.reset();
    form.action = 'addCourse';

    document.getElementById('courseId').value = '';


    modalTitle.textContent = 'Tạo khóa học mới';
    submitBtn.textContent = 'Tạo khóa học';

    document.getElementById('courseModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

// Mở modal sửa khóa học
function editCourse(btn) {
    const row = btn.closest('tr');
    const d = row.dataset;

    const form = document.getElementById('courseForm');
    const modalTitle = document.getElementById('modalTitle');
    const submitBtn = document.getElementById('submitBtn');

    form.reset();
    form.action = 'updateCourse';

    // Gán hidden input
    document.getElementById('courseId').value = d.id || '';

    // Gán dữ liệu vào form
    document.getElementById('courseTitle').value = d.title || '';
    document.getElementById('courseLanguage').value = d.language || '';
    document.getElementById('courseLevel').value = d.level || '';
    document.getElementById('courseCategory').value = d.category || '';
    document.getElementById('courseDescription').value = d.description || '';

    modalTitle.textContent = 'Sửa khóa học';
    submitBtn.textContent = 'Lưu thay đổi';

    document.getElementById('courseModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

// Đóng modal
function closeCourseModal() {
    const modal = document.getElementById('courseModal');
    const form = document.getElementById('courseForm');
    const statusGroup = document.getElementById('statusGroup');

    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
    if (form)
        form.reset();

}

// Preview thumbnail (nếu có)
//function previewThumbnail(input) {
//    const preview = document.getElementById('thumbnailPreview');
//    const previewImg = document.getElementById('previewImg');
//    if (!preview || !previewImg)
//        return;
//
//    if (input.files && input.files[0]) {
//        const reader = new FileReader();
//        reader.onload = function (e) {
//            previewImg.src = e.target.result;
//            preview.style.display = 'block';
//        };
//        reader.readAsDataURL(input.files[0]);
//    } else {
//        preview.style.display = 'none';
//    }
//}



// Đóng modal khi click bên ngoài
window.addEventListener('click', function (event) {
    const modal = document.getElementById('courseModal');
    if (event.target === modal) {
        closeCourseModal();
    }
});

// Đóng modal bằng phím ESC
document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        closeCourseModal();
    }
});


