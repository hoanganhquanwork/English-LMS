<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật bài học Reading</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link rel="stylesheet" href="css/teacher-content-editor.css">
        <link rel="stylesheet" href="css/teacher-questions.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <script src="https://cdn.tiny.cloud/1/808iwiomkwovmb2cvokzivnjb0nka12kkujkdkuf8tpcoxtw/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                tinymce.init({
                    selector: '#content',
                    width: '200%',
                    branding: false,
                    statusbar: false,
                    height: 400,
                    menubar: false,
                    plugins: 'lists link image media table code fontsize',
                    toolbar:
                            'undo redo | bold italic underline | fontsize | alignleft aligncenter alignright | bullist numlist | link image media table | code',
                    fontsize_formats: '8pt 10pt 12pt 14pt 16pt 18pt 20pt 24pt 28pt 32pt 36pt',
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
                <h2>Cập nhật bài học Reading</h2>
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
                                    <c:if test="${course.status == 'draft' || course.status == 'submitted'}">
                                        <button class="add-lesson-btn" onclick="toggleDropdown('dropdown-${h.key.moduleId}')">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </c:if>
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
                                <div class="tree-item ${item.moduleItemId == lesson.moduleItemId ? 'active' : ''}" style="margin-left: 16px;">
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
                            <i class="fas fa-file-alt" style="color: #3498db;"></i>
                            <span>READING</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: 700px;">
                    <form action="updateLessonReading" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

                        <div class="form-group">
                            <label for="title">Tên bài học <span style="color:#e74c3c">*</span></label>
                            <input id="title" name="title" type="text" placeholder="Nhập tên bài học" 
                                   value="${lesson.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="content">Nội dung bài đọc <span style="color:#e74c3c">*</span></label>
                            <textarea id="content" name="content" class="content-editor" 
                                      placeholder="Nhập nội dung bài đọc..." required>${lesson.textContent}</textarea>
                        </div>


                        <div class="actions">
                            <a class="btn btn-secondary" href="manageModule?courseId=${param.courseId}">
                                <i class="fas fa-times"></i>
                                Hủy bỏ
                            </a>
                            <c:if test="${course.status == 'draft' || course.status == 'submitted'}">
                                <a href="deleteLesson?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}" 
                                   class="btn delete-lesson-btn"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này không?')">
                                    <i class="fas fa-trash"></i>
                                    Xóa bài học
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Cập nhật bài học
                                </button>
                            </c:if>
                        </div>
                    </form>



                </main>
            </div>
        </div>

        <script>
            let questionCount = 0;
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
            // Action button functions


            // Xử lý form submit
            document.querySelector('form').addEventListener('submit', function (e) {
                const title = document.getElementById('title').value.trim();
                const content = tinymce.get('content').getContent();

                if (!title) {
                    e.preventDefault();
                    alert('Vui lòng nhập tên bài học');
                    document.getElementById('title').focus();
                    return false;
                }

                if (!content || content === '<p></p>' || content === '') {
                    e.preventDefault();
                    alert('Vui lòng nhập nội dung bài đọc');
                    tinymce.get('content').focus();
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
            function createOptionHTML(questionNumber) {
                var html = "";
                for (var i = 1; i <= 4; i++) {
                    html += '<div class="answer-option">';
                    html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + i + '" ' +
                            'id="correct-' + questionNumber + '-' + i + '" class="correct-answer-checkbox">';
                    html += '    <label for="correct-' + questionNumber + '-' + i + '" class="correct-answer-label">';
                    html += '        <i class="fas fa-check"></i>';
                    html += '    </label>';
                    html += '    <input type="text" name="optionContent' + questionNumber + '_' + i + '" ' +
                            'class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                    html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                    html += '        <i class="fas fa-trash"></i>';
                    html += '    </button>';
                    html += '</div>';
                }
                return html;
            }

            function addQuestion(type) {
                questionCount++;
                var list = document.getElementById("questionsList");
                var empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                var html = '';
                html += '<div class="question-form" id="question-' + questionCount + '" data-question-id="new-' + questionCount + '">';
                html += '    <div class="question-header" onclick="toggleQuestionContent(\'question-' + questionCount + '\')">';
                html += '        <div class="question-number">Câu ' + questionCount + '</div>';
                html += '        <div class="question-type">';
                html += '            <i class="fas fa-check-circle"></i>';
                html += '            Trắc nghiệm';
                html += '        </div>';
                html += '        <div class="question-header-actions">';
                html += '            <button class="question-toggle-btn" id="toggle-' + questionCount + '" onclick="event.stopPropagation(); toggleQuestionContent(\'question-' + questionCount + '\')">';
                html += '                <i class="fas fa-chevron-up"></i>';
                html += '                Thu gọn';
                html += '            </button>';
                html += '            <button type="button" class="delete-question-btn" onclick="event.stopPropagation(); deleteQuestion(' + questionCount + ')">';
                html += '                <i class="fas fa-trash"></i>';
                html += '                Xóa';
                html += '            </button>';
                html += '        </div>';
                html += '    </div>';
                html += '    <div class="question-content expanded">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="' + type + '">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" class="question-input" ' +
                        'placeholder="Nhập nội dung câu hỏi..." required></textarea>';
                html += '        </div>';
                html += '        <div class="answer-options">' + createOptionHTML(questionCount) + '</div>';
                html += '        <button type="button" class="add-option-btn" onclick="addOption(' + questionCount + ')">';
                html += '            <i class="fas fa-plus"></i> Thêm phương án';
                html += '        </button>';
                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" class="explanation-input" ' +
                        'placeholder="Nhập lời giải chi tiết (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                list.insertAdjacentHTML("beforeend", html);
            }

            function deleteQuestion(number) {
                var q = document.getElementById("question-" + number);
                if (q)
                    q.remove();
            }

            function removeOption(button) {
                var optionDiv = button.closest(".answer-option");
                if (optionDiv)
                    optionDiv.remove();
            }

            function addOption(questionNumber) {
                var optionsDiv = document.querySelector("#question-" + questionNumber + " .answer-options");
                var currentCount = optionsDiv.querySelectorAll(".answer-option").length;
                var newIndex = currentCount + 1;

                var html = '';
                html += '<div class="answer-option">';
                html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + newIndex + '" ' +
                        'id="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-checkbox">';
                html += '    <label for="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-label">';
                html += '        <i class="fas fa-check"></i>';
                html += '    </label>';
                html += '    <input type="text" name="optionContent' + questionNumber + '_' + newIndex + '" ' +
                        'class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                html += '        <i class="fas fa-trash"></i>';
                html += '    </button>';
                html += '</div>';

                optionsDiv.insertAdjacentHTML("beforeend", html);
            }

            // Questions collapse/expand functionality
            function toggleQuestionsCollapse() {
                const content = document.getElementById('questionsContent');
                const toggle = document.querySelector('.collapse-btn');

                if (content.classList.contains('expanded')) {
                    content.classList.remove('expanded');
                    content.classList.add('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-down"></i> Mở rộng';
                } else {
                    content.classList.remove('collapsed');
                    content.classList.add('expanded');
                    toggle.innerHTML = '<i class="fas fa-chevron-up"></i> Thu gọn';
                }
            }



        </script>
    </body>
</html>
