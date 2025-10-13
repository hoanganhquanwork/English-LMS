<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thảo Luận</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .content-editor {
                width: 100%;
                min-height: 400px;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                font-size: 16px;
                line-height: 1.8;
                background: #fafafa;
                color: #2c3e50;
                box-sizing: border-box;
                resize: vertical;
                transition: all 0.2s ease-in-out;
            }

            .content-editor:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
                background: #fff;
            }
            .lesson-content-page {
                display: flex;
                gap: 24px;
                min-height: 100vh;
            }

            .topic-sidebar {
                width: 280px;
                background: #fff;
                border-radius: 12px;
                padding: 16px;
                box-shadow: 0 2px 8px rgba(0,0,0,.08);
                height: fit-content;
            }

            .sidebar-header {
                font-weight: 600;
                margin-bottom: 12px;
                color: #2c3e50;
                font-size: 14px;
            }

            .sidebar-search {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 10px;
            }

            .sidebar-search input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
            }

            .topic-tree {
                border: 1px solid #eee;
                border-radius: 8px;
                height: 400px;
                overflow-y: auto;
                padding: 8px;
            }

            .tree-item {
                padding: 8px 12px;
                margin: 2px 0;
                border-radius: 6px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                transition: all 0.2s;
            }

            .tree-item:hover {
                background: #f5f7fb;
            }

            .tree-item.active {
                background: #3498db;
                color: white;
            }

            .tree-item i {
                width: 16px;
                text-align: center;
            }

            .guide-section {
                margin-top: 20px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }

            .guide-label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                font-size: 12px;
            }

            .guide-icon {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12px;
                color: #7f8c8d;
            }

            .main-content {
                flex: 1;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,.08);
                padding: 16px 24px;
                min-width: 0;
            }

            .main-content * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            .main-content .form-group {
                margin-bottom: 16px;
            }

            .main-content .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2c3e50;
            }

            .back-link{
                display:inline-flex;
                align-items:center;
                gap:8px;
                color:#2c3e50;
                text-decoration:none;
                margin-bottom:12px
            }
            .page-title-wrap{
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:16px
            }
            .hint{
                font-size:13px;
                color:#7f8c8d;
                margin-top:8px
            }
            .radio-row{
                display:flex;
                gap:24px;
                margin:8px 0 12px
            }
            .actions{
                display:flex;
                justify-content:flex-end;
                gap:12px;
                margin-top:20px;
                padding: 20px 0;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .btn-primary {
                background: #007bff;
                color: white;
            }

            .btn-primary:hover {
                background: #0056b3;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            }

            .module-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 8px 12px;
                margin: 2px 0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s;
            }

            .module-header:hover {
                background: #f5f7fb;
            }

            .module-title {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .module-actions {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .add-lesson-btn {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #3498db;
                color: white;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                transition: all 0.2s;
            }

            .add-lesson-btn:hover {
                background: #2980b9;
                transform: scale(1.1);
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 6px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                min-width: 180px;
                display: none;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                padding: 8px 12px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 13px;
                color: #2c3e50;
                transition: background 0.2s;
            }

            .dropdown-item:hover {
                background: #f5f7fb;
            }

            .dropdown-item i {
                width: 16px;
                text-align: center;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-group input[type="text"] {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                box-sizing: border-box;
            }

            .form-group input[type="text"]:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            .reading-preview {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 16px;
                margin-top: 12px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
            }

            .lesson-info {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
            }

            .lesson-info h3 {
                color: #2c3e50;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .info-item {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 8px;
                font-size: 14px;
                color: #6c757d;
            }

            .info-item i {
                color: #3498db;
                width: 16px;
            }

            .action-buttons {
                display: flex;
                gap: 12px;
                margin: 20px 0;
                flex-wrap: wrap;
            }

            .btn-action {
                padding: 10px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: white;
                color: #6c757d;
            }

            .btn-action:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .btn-action.btn-primary {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }

            .btn-action.btn-primary:hover {
                background: #0056b3;
                border-color: #0056b3;
                box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            }

            .btn-action.btn-secondary {
                background: white;
                color: #6c757d;
                border-color: #ddd;
            }

            .btn-action.btn-secondary:hover {
                background: #f8f9fa;
                border-color: #adb5bd;
                color: #495057;
            }

            .discussion-content {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
            }

            .discussion-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 16px;
            }

            .discussion-description {
                font-size: 16px;
                color: #495057;
                line-height: 1.6;
            }

            .delete-discussion-btn {
                background: #e74c3c;
                color: white;
                border-color: #e74c3c;
            }

            .delete-discussion-btn:hover {
                background: #c0392b;
                border-color: #c0392b;
                color: white;
            }
        </style>

        <script src="https://cdn.tiny.cloud/1/808iwiomkwovmb2cvokzivnjb0nka12kkujkdkuf8tpcoxtw/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                tinymce.init({
                    selector: '#description',
                    width: '200%',
                    height: 400,
                    branding: false,
                    statusbar: false,
                    menubar: false,
                    plugins: 'lists link image media table code',
                    toolbar:
                            'undo redo | bold italic underline | alignleft aligncenter alignright | bullist numlist | link image media table | code',
                    content_style: `
                body {
                  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                  font-size: 15px;
                  line-height: 1.6;
                  color: #2c3e50;
                  background-color: #fafafa;
                  padding: 16px;
                  border-radius: 8px;
                }
            `,
                    setup: function (editor) {
                        editor.on('change keyup', function () {
                            editor.save(); // cập nhật lại textarea
                        });
                    }
                });
            });
        </script>
    </head>
    <body>
        <div id="page" data-courseid="${param.courseId}"></div>
        <div class="container" style="max-width: 1600px; margin: 0 auto; padding: 0 20px;">
            <a class="back-link" href="manageModule?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Thảo Luận</h2>
            </div>

            <div class="lesson-content-page">
                <!-- Left Sidebar -->
                <aside class="topic-sidebar">
                    <div class="sidebar-search">
                        <input type="text" placeholder="Tìm kiếm">
                        <i class="fas fa-search" style="color: #7f8c8d;"></i>
                    </div>
                    <div class="topic-tree">
                        <c:forEach var="h" items="${requestScope.content}">
                            <div class="module-header" style="position: relative;">
                                <div class="module-title">
                                    <i class="fas fa-folder" style="color: #f39c12;"></i>
                                    ${h.key.title}
                                </div>
                                <div class="module-actions">
                                    <button class="add-lesson-btn" onclick="toggleDropdown('dropdown-${h.key.moduleId}')">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                                <div class="dropdown-menu" id="dropdown-${h.key.moduleId}">
                                    <div class="dropdown-item" onclick="createLesson('video', '${h.key.moduleId}')">
                                        <i class="fas fa-video" style="color: #e74c3c;"></i>
                                        Tạo bài học Video
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('reading', '${h.key.moduleId}')">
                                        <i class="fas fa-file-alt" style="color: #3498db;"></i>
                                        Tạo bài học Reading
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('discussion', '${h.key.moduleId}')">
                                        <i class="fas fa-comments" style="color: #f39c12;"></i>
                                        Tạo Thảo Luận
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('quiz', '${h.key.moduleId}')">
                                        <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                                        Tạo Quiz
                                    </div>
                                </div>
                            </div>
                            <c:forEach var="item" items="${h.value}">
                                <div class="tree-item ${item.moduleItemId == discussion.discussionId ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${item.itemType == 'lesson'}">
                                            <a href="updateLesson?courseId=${param.courseId}&moduleId=${h.key.moduleId}&lessonId=${item.moduleItemId}" style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-play" style="color: #e74c3c;"></i>  Bài học #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                        <c:when test="${item.itemType == 'discussion'}">
                                            <a href="updateDiscussion?courseId=${param.courseId}&moduleId=${h.key.moduleId}&discussionId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-comments" style="color: #f39c12;"></i>
                                                Thảo luận #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                        <c:when test="${item.itemType == 'quiz'}">
                                            <a href="updateQuiz?courseId=${param.courseId}&moduleId=${h.key.moduleId}&quizId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                                                Quiz #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:forEach>
                    </div>                
                    <div class="guide-section">
                        <div class="guide-label">HƯỚNG DẪN</div>
                        <div class="guide-icon">
                            <i class="fas fa-comments" style="color: #f39c12;"></i>
                            <span>DISCUSSION</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: 700px;">
                    <form action="updateDiscussion" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="discussionId" value="${discussion.discussionId}">

                        <div class="form-group">
                            <label for="title">Tiêu đề <span style="color:#e74c3c">*</span></label>
                            <input id="title" name="title" type="text" placeholder="Nhập tiêu đề thảo luận" 
                                   value="${discussion.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Nội dung mô tả <span style="color:#e74c3c">*</span></label>
                            <textarea id="description" name="description" class="content-editor" 
                                      placeholder="Nhập nội dung hướng dẫn cho discussion..." required>${discussion.description}</textarea>
                        </div>

                        <div class="actions">
                            <a class="btn btn-secondary" href="manageModule?courseId=${param.courseId}">
                                <i class="fas fa-times"></i>
                                Hủy bỏ
                            </a>
                            <a href="deleteDiscussion?courseId=${param.courseId}&moduleId=${param.moduleId}&discussionId=${discussion.discussionId}" 
                               class="btn delete-discussion-btn"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa thảo luận này không?')">
                                <i class="fas fa-trash"></i>
                                Xóa thảo luận
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Cập nhật thảo luận
                            </button>
                        </div>
                    </form>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                    </c:if>
                </main>
            </div>
    </div>

        <script>
            function toggleDropdown(dropdownId) {
                // Đóng tất cả dropdown khác
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu.id !== dropdownId) {
                        menu.classList.remove('show');
                    }
                });

                // Toggle dropdown hiện tại
                const dropdown = document.getElementById(dropdownId);
                dropdown.classList.toggle('show');
            }

            function createLesson(type, moduleId) {
                var courseId = document.getElementById('page').dataset.courseid || '';
                var url = '';

                if (type === 'video') {
                    url = "ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'reading') {
                    url = "createReadingLesson?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'discussion') {
                    url = "createDiscussion?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'quiz') {
                    url = "createQuiz?courseId=" + courseId + "&moduleId=" + moduleId;
                }

                if (url) {
                    window.location.href = url;
                }
            }

            document.addEventListener('click', function (event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

            // Xử lý form submit
            document.querySelector('form').addEventListener('submit', function (e) {
                const title = document.getElementById('title').value.trim();
                const content = tinymce.get('description').getContent();

                if (!title) {
                    e.preventDefault();
                    alert('Vui lòng nhập tiêu đề thảo luận');
                    document.getElementById('title').focus();
                    return false;
                }

                if (!content || content === '<p></p>' || content === '') {
                    e.preventDefault();
                    alert('Vui lòng nhập nội dung mô tả');
                    tinymce.get('description').focus();
                    return false;
                }
            });
        </script>
    </body>
</html>
