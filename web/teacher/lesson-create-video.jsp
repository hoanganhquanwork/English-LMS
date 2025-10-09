<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm mới bài học dạng video</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .lesson-content-page {
                display: flex;
                gap: 24px;
                min-height: 100vh;
            }

            .topic-sidebar {
                width: 320px;
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
                padding: 24px;
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
                margin-top:20px
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
        </style>
    </head>
    <body>
        <div id="page" data-courseid="${courseId}"></div>
        <div class="container" style="max-width: 1500px;">
            <a class="back-link" href="manageModule?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Thêm mới bài học dạng video</h2>
            </div>

            <div class="lesson-content-page">
                <!-- Left Sidebar -->
                <aside class="topic-sidebar">
                    <div class="sidebar-header">Hướng dẫn</div>
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
                                </div>
                            </div>
                            <c:forEach var="lesson" items="${h.value}">
                                <div class="tree-item" style="margin-left: 16px;">
                                    <a href="updateLesson?courseId=${param.courseId}&moduleId=${h.key.moduleId}&lessonId=${lesson.moduleItemId}" style="text-decoration: none; color: inherit;">
                                        <i class="fas fa-play" style="color: #e74c3c;"></i> ${lesson.title}
                                    </a>
                                </div>
                            </c:forEach>
                        </c:forEach>
                    </div>

                    <div class="guide-section">
                        <div class="guide-label">HƯỚNG DẪN</div>
                        <div class="guide-icon">
                            <i class="fas fa-user" style="color: #3498db;"></i>
                            <span>NEWS</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: 400px;">
                    <form action="createLesson" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${requestScope.moduleId}">

                        <div class="form-group">
                            <label for="title">Tên bài học <span style="color:#e74c3c">*</span></label>
                            <input id="title" name="title" type="text" placeholder="Nhập tên bài học" required>
                        </div>

                        <div class="form-group">
                            <label>Video <span style="color:#e74c3c">*</span></label>
                            <div class="radio-row">
                                <label><input type="radio" name="videoType" value="upload"> Tải video lên</label>
                                <label><input type="radio" name="videoType" value="youtube" checked> Video có sẵn trên Youtube</label>
                            </div>
                            <input type="text" name="youtubeUrl" placeholder="Đường dẫn URL Youtube">
                            <div class="hint">Chú ý: Vui lòng chỉ nhập đường dẫn trực tiếp của video. Đường dẫn kênh youtube, video riêng tư hoặc danh sách phát là không hợp lệ!</div>
                        </div>

                        <div class="actions">
                            <a class="btn btn-secondary" href="module.jsp?courseId=${param.courseId}">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
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
                   const courseId = document.getElementById('page').dataset.courseid || ''; 
                let url = '';
                
                if (type === 'video') {
                    url = `ManageLessonServlet?courseId=${courseId}&moduleId=${moduleId}`;
                } else if (type === 'reading') {
                    url = `lesson-create-reading.jsp?courseId=${courseId}&moduleId=${moduleId}`;
                }
                
                if (url) {
                    window.location.href = url;
                }
            }

            // Đóng dropdown khi click bên ngoài
            document.addEventListener('click', function(event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });
        </script>
    </body>
</html>



