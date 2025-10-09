<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật bài học dạng video</title>
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

            .lesson-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 1px solid #eee;
            }

            .lesson-title {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .back-arrow {
                color: #2c3e50;
                text-decoration: none;
                font-size: 18px;
            }

            .lesson-title h1 {
                margin: 0;
                font-size: 24px;
                color: #2c3e50;
            }

            .lesson-actions {
                display: flex;
                gap: 12px;
            }

            .action-btn {
                padding: 8px 16px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background: white;
                color: #2c3e50;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: all 0.2s;
            }

            .action-btn:hover {
                background: #f5f7fb;
                border-color: #3498db;
            }

            .lesson-form {
                margin-bottom: 24px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                align-items: stretch;
                width: 100%;
            }

            .form-group input {
                width: 100%;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                margin: 0;
                box-sizing: border-box;
            }

            .video-container {
                width: 100%;
                display: flex;
                justify-content: center;
                margin-bottom: 30px;
            }

            .video-wrapper {
                position: relative;
                width: 100%;
                max-width: 800px;
                height: 0;
                padding-bottom: 40%; /* Giảm chiều cao từ 56.25% xuống 40% */
                background: #000;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            }

            .video-iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
                border-radius: 12px;
            }

            .delete-video-btn {
                position: absolute;
                top: 12px;
                right: 6px;
                width: 36px;
                height: 36px;
                background: rgba(231, 76, 60, 0.9);
                border: none;
                border-radius: 50%;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                transition: all 0.3s;
                z-index: 10;
                box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            }

            .delete-video-btn:hover {
                background: rgba(231, 76, 60, 1);
                transform: scale(1.1);
                box-shadow: 0 4px 12px rgba(231, 76, 60, 0.4);
            }

            .video-player {
                background: #000;
                border-radius: 8px;
            }

            .video-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 16px;
                background: rgba(0,0,0,0.8);
                color: white;
            }

            .video-info {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .video-avatar {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                object-fit: cover;
            }

            .video-channel {
                font-size: 14px;
                font-weight: 500;
            }

            .video-actions-header {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .share-btn {
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.3);
                color: white;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 12px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 4px;
                transition: all 0.2s;
            }

            .share-btn:hover {
                background: rgba(255,255,255,0.2);
            }

            .delete-video {
                width: 28px;
                height: 28px;
                background: rgba(231, 76, 60, 0.8);
                border: none;
                border-radius: 50%;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                transition: all 0.2s;
            }

            .delete-video:hover {
                background: rgba(231, 76, 60, 1);
            }

            .video-content {
                position: relative;
                width: 100%;
                height: 400px;
            }

            .video-thumbnail {
                width: 100%;
                height: 100%;
                position: relative;
            }

            .video-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .video-overlay {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.3);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .play-button {
                width: 80px;
                height: 80px;
                background: rgba(255,255,255,0.9);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                color: #2c3e50;
                cursor: pointer;
                transition: all 0.3s;
            }

            .play-button:hover {
                background: white;
                transform: scale(1.1);
            }

            .video-controls {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                background: rgba(0,0,0,0.8);
                color: white;
                gap: 12px;
            }

            .controls-left {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .control-btn {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 4px;
                border-radius: 4px;
                transition: all 0.2s;
            }

            .control-btn:hover {
                background: rgba(255,255,255,0.1);
            }

            .progress-container {
                flex: 1;
                margin: 0 12px;
            }

            .progress-bar {
                width: 100%;
                height: 4px;
                background: rgba(255,255,255,0.3);
                border-radius: 2px;
                position: relative;
                cursor: pointer;
            }

            .progress-fill {
                width: 30%;
                height: 100%;
                background: #ff0000;
                border-radius: 2px;
                transition: width 0.2s;
            }

            .controls-right {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .time-display {
                font-size: 12px;
                font-family: monospace;
            }

            .youtube-logo {
                color: #ff0000;
                font-size: 16px;
            }

            .video-actions {
                display: flex;
                gap: 12px;
                margin-bottom: 24px;
            }

            .video-action-btn {
                padding: 10px 16px;
                border: 1px solid #3498db;
                border-radius: 6px;
                background: #3498db;
                color: white;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s;
            }

            .video-action-btn:hover {
                background: #2980b9;
                border-color: #2980b9;
            }

            .video-action-btn.secondary {
                background: white;
                color: #2c3e50;
                border-color: #ddd;
            }

            .video-action-btn.secondary:hover {
                background: #f5f7fb;
                border-color: #3498db;
            }

            .page-actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-secondary {
                background: #95a5a6;
                color: white;
                border: 1px solid #95a5a6;
            }

            .btn-secondary:hover {
                background: #7f8c8d;
            }

            .btn-primary {
                background: #3498db;
                color: white;
                border: 1px solid #3498db;
            }

            .btn-primary:hover {
                background: #2980b9;
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
                <main class="main-content" style="height: 800px">
                    <div class="lesson-header">
                        <div class="lesson-title">
                            <a href="module.jsp?courseId=${param.courseId}" class="back-arrow">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            <h1>Cập nhật bài học dạng video</h1>
                        </div>
                        <div class="lesson-actions">
                            <a href="#" class="action-btn">
                                <i class="fas fa-comments"></i>
                                Thảo luận
                            </a>
                            <a href="#" class="action-btn">
                                <i class="fas fa-cog"></i>
                                Cài đặt
                            </a>
                        </div>
                    </div>

                                <form action="updateLesson" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${param.lessonId}">

                        <div class="lesson-form">
                            <div class="form-group">
                                <label for="lessonTitle">Tên bài học *</label>
                                <input type="text" id="lessonTitle" name="title" value="${lesson.title}" required>
                            </div>

                            <div class="video-container" id="videoContainer">
                                <c:choose>
                                    <c:when test="${not empty lesson.videoUrl}">
                                        <div class="video-wrapper" id="videoWrapper">
                                            <iframe 
                                                src="${lesson.videoUrl}" 
                                                frameborder="0" 
                                                allowfullscreen
                                                class="video-iframe">
                                            </iframe>
                                            <button type="button" class="delete-video-btn" onclick="deleteVideo()" title="Xóa hoặc thay video">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group" id="videoInputGroup">
                                            <label for="videoUrl">Nhập link YouTube *</label>
                                            <input type="text" id="videoUrl" name="videoUrl" placeholder="https://www.youtube.com/watch?v=..." required>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>


                            <div class="page-actions">
                                <a href="module.jsp?courseId=${param.courseId}" class="btn btn-secondary">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    Lưu
                                </button>
                            </div>
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
            document.addEventListener('click', function (event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

            function deleteVideo() {
                if (confirm('Bạn có chắc chắn muốn thay video này bằng link mới không?')) {
                    // Xóa phần hiển thị video hiện tại
                    const videoContainer = document.getElementById('videoContainer');
                    videoContainer.innerHTML = `
            <div class="form-group" id="videoInputGroup">
                <label for="videoUrl">Nhập link YouTube *</label>
                <input type="text" id="videoUrl" name="videoUrl" placeholder="https://www.youtube.com/watch?v=..." required>
            </div>
        `;
                }
            }

            // Xử lý click play button
            document.querySelector('.play-button').addEventListener('click', function () {
                // Xử lý phát video
                console.log('Phát video');
            });
        </script>
    </body>
</html>
