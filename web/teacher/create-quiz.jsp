<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo Quiz Mới</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div id="page" data-courseid="${param.courseId}"></div>
        <div class="container" style="max-width: 1600px; margin: 0 auto; padding: 0 20px;">
            <a class="back-link" href="manageModule?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Tạo Quiz Mới</h2>
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
                                <div class="tree-item">
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
                                         <c:when test="${item.itemType == 'assignment'}">
                                            <a href="updateAssignment?courseId=${param.courseId}&moduleId=${h.key.moduleId}&assignmentId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-tasks" style="color: #27ae60;"></i>
                                                Assignment #${item.moduleItemId}
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
                            <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                            <span>QUIZ</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: 700px;">
                    <form action="createQuiz" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">

                        <div class="form-group">
                            <label for="title">Tiêu đề Quiz <span style="color:#e74c3c">*</span></label>
                            <input id="title" name="title" type="text" placeholder="Nhập tiêu đề quiz" required>
                        </div>

<<<<<<< HEAD
                        <div class="form-row">
                            <div class="form-group">
                                <label for="attempts_allowed">Số lần thử cho phép</label>
                                <input id="attempts_allowed" name="attempts_allowed" type="number" 
                                       placeholder="Để trống = không giới hạn" min="1">
                            </div>
=======

                          
>>>>>>> main
                            <div class="form-group">
                                <label for="passing_score_pct">Điểm đạt (%)</label>
                                <input id="passing_score_pct" name="passing_score_pct" type="number" 
                                       placeholder="Để trống = chỉ ôn tập" min="0" max="100" step="0.01">
                            </div>
<<<<<<< HEAD
                        </div>
=======

>>>>>>> main

                        <div class="form-group">
                            <label for="pick_count">Số câu hỏi</label>
                            <input id="pick_count" name="pick_count" type="number" 
                                   placeholder="Để trống = lấy hết pool" min="1">
                        </div>
<<<<<<< HEAD
=======
                        <div class="form-group">
                                <label for="time_limit">Thời gian làm bài (phút)</label>
                                <input id="time_limit" name="time_limit" type="number" 
                                       
                                       placeholder="Để trống = không giới hạn thời gian" min="1">
                            </div>
>>>>>>> main
               

                        <div class="actions">
                            <a class="btn btn-secondary" href="manageModule?courseId=${param.courseId}">
                                <i class="fas fa-times"></i>
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Tạo Quiz
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

            // Xử lý form submit
            document.querySelector('form').addEventListener('submit', function (e) {
                const title = document.getElementById('title').value.trim();
                const attemptsAllowed = document.getElementById('attempts_allowed').value;
                const passingScore = document.getElementById('passing_score_pct').value;
                const pickCount = document.getElementById('pick_count').value;

                if (!title) {
                    e.preventDefault();
                    alert('Vui lòng nhập tiêu đề quiz');
                    document.getElementById('title').focus();
                    return false;
                }

<<<<<<< HEAD
                // Validate attempts_allowed
                if (attemptsAllowed && (parseInt(attemptsAllowed) < 1)) {
                    e.preventDefault();
                    alert('Số lần thử phải lớn hơn 0');
                    document.getElementById('attempts_allowed').focus();
                    return false;
                }

=======
              
>>>>>>> main
                // Validate passing_score_pct
                if (passingScore && (parseFloat(passingScore) < 0 || parseFloat(passingScore) > 100)) {
                    e.preventDefault();
                    alert('Điểm đạt phải từ 0% đến 100%');
                    document.getElementById('passing_score_pct').focus();
                    return false;
                }

                // Validate pick_count
                if (pickCount && (parseInt(pickCount) < 1)) {
                    e.preventDefault();
                    alert('Số câu hỏi lấy từ pool phải lớn hơn 0');
                    document.getElementById('pick_count').focus();
                    return false;
                }
            });

            document.addEventListener('click', function (event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });
        </script>
    </body>
</html>

