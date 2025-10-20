
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm mới hàng loạt - ${course.title}</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Dropdown Styles */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
                position: relative;
            }

            .dropdown-toggle i {
                transition: transform 0.3s;
            }

            .dropdown-toggle.active i {
                transform: rotate(180deg);
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                min-width: 250px;
                display: none;
                margin-top: 5px;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                padding: 12px 16px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                color: #2c3e50;
                transition: background 0.2s;
                border-bottom: 1px solid #f0f0f0;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background: #f8f9fa;
            }

            .dropdown-item i {
                width: 20px;
                text-align: center;
                font-size: 16px;
            }

            .dropdown-item:first-child i {
                color: #3498db;
            }

            .dropdown-item:last-child i {
                color: #27ae60;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-primary {
                background: #3498db;
                color: white;
            }

            .btn-primary:hover {
                background: #2980b9;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
            }

            /* Text Question Styles */
            .text-question-form {
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 12px;
                margin-bottom: 20px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .text-question-header {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px 20px;
                background: #f8f9fa;
                border-bottom: 1px solid #e9ecef;
            }

            .text-question-number {
                background: #27ae60;
                color: white;
                padding: 6px 12px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 14px;
            }

            .text-question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #2c3e50;
                font-size: 14px;
                font-weight: 500;
            }

            .text-question-type i {
                color: #27ae60;
                font-size: 16px;
            }

            .text-question-content {
                padding: 20px;
            }

            .file-upload-group {
                margin-bottom: 16px;
            }

            .file-upload-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .file-upload-input {
                width: 100%;
                padding: 12px 16px;
                border: 2px dashed #ddd;
                border-radius: 8px;
                background: #f8f9fa;
                cursor: pointer;
                transition: all 0.3s;
            }

            .file-upload-input:hover {
                border-color: #3498db;
                background: #e3f2fd;
            }

            .file-upload-input:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .file-info {
                margin-top: 8px;
                font-size: 12px;
                color: #6c757d;
            }

            .answer-group {
                margin-bottom: 16px;
            }

            .answer-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .answer-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                resize: vertical;
                min-height: 60px;
            }

            .answer-input:focus {
                outline: none;
                border-color: #27ae60;
                box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
            }

            .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: auto;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .delete-question-btn:hover {
                background: #c0392b;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="dashboard.html" class="brand">
                        <div class="logo"></div>
                        <span>EduPlatform</span>
                    </a>
                    <div class="nav">
                        <a href="instructorDashboard?id=3">Dashboard</a>
                        <a href="manage?id=3">Khóa học</a>                     
                    </div>
                    <button class="hamburger">
                        <i class="fas fa-bars"></i>
                    </button>
                </nav>
            </div>
        </header>

        <div class="container">
            <!-- Page Title -->
            <div class="page-title">
                <div>
                    <h2>Thêm mới hàng loạt</h2>
                    <p class="page-subtitle">Khóa học: ${course.title}</p>
                </div>
            </div>

            <!-- Course Info Card -->
            <div class="course-info-card">
                <div class="course-header">
                    <div class="course-thumbnail">
                        <i>${course.thumbnail}</i>
                    </div>
                    <div class="course-details">
                        <h3>${course.title}</h3>
                        <p>${course.description}</p>
                        <div class="course-stats">
                            <div class="stat">
                                <i class="fas fa-question-circle"></i>
                                <span>0 câu hỏi</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-layout">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-card">
                        <h4>Menu Khóa học</h4>
                        <nav class="sidebar-menu">
                            <a href="manageModule?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-play-circle"></i>
                                Nội dung khóa học
                            </a>
                            <a href="courseStudents?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-users"></i>
                                Học sinh
                            </a>
                            <a href="ManageQuestionServlet?courseId=${course.courseId}" class="sidebar-link   active">
                                <i class="fas fa-question-circle"></i>
                                Câu hỏi
                            </a>
                        </nav>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <!-- Add Questions Page -->
                    <div class="add-questions-page">
                        <!-- Warning Message -->
                        <form action="addQuestion" method="post" enctype="multipart/form-data" id="bulkQuestionForm">
                            <input type="hidden" name="courseId" value="${course.courseId}">
<!--                            <div class="form-section">
                                <div class="form-group">
                                    <label for="questionBank">Ngân hàng câu hỏi *</label>
                                    <select id="questionBank" name="moduleId" class="form-select" required>
                                        <option value="">-- Chọn module --</option>
                                        <c:forEach var="m" items="${moduleList}">
                                            <option value="${m.moduleId}">${m.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>-->

                            <div id="questionsList" class="questions-content-area">
                                <div class="empty-questions">
                                    <p>Chưa có câu hỏi nào được thêm</p>
                                </div>
                            </div>

                            <div class="actions">
                                <div class="dropdown">
                                    <button type="button" class="btn btn-primary dropdown-toggle" onclick="toggleDropdown()">
                                        + Thêm câu hỏi
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <div class="dropdown-menu" id="questionTypeDropdown">
                                        <div class="dropdown-item" onclick="addQuestion('mcq_single')">
                                            <i class="fas fa-check-circle"></i>
                                            Câu hỏi lựa chọn 1 đáp án
                                        </div>
                                        <div class="dropdown-item" onclick="addTextQuestion()">
                                            <i class="fas fa-file-text"></i>
                                            Câu hỏi dạng text
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-success">Lưu tất cả</button>
                            </div>
                        </form>

                    </div>
                </main>
            </div>
        </div>


        <script>
            let questionCount = 0;

            // Dropdown functions
            function toggleDropdown() {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                } else {
                    dropdown.classList.add('show');
                    toggle.classList.add('active');
                }
            }

            // Close dropdown when clicking outside
            window.onclick = function (event) {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (!event.target.closest('.dropdown')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                }
            };


            function createOptionHTML(questionNumber) {
                let html = "";
                for (let i = 1; i <= 4; i++) {
                    html += '<div class="answer-option">';
                    html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + i + '" ';
                    html += '        id="correct-' + questionNumber + '-' + i + '" class="correct-answer-checkbox">';
                    html += '    <label for="correct-' + questionNumber + '-' + i + '" class="correct-answer-label">';
                    html += '        <i class="fas fa-check"></i>';
                    html += '    </label>';
                    html += '    <input type="text" name="optionContent' + questionNumber + '_' + i + '" ';
                    html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                    html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                    html += '        <i class="fas fa-trash"></i>';
                    html += '    </button>';
                    html += '</div>';
                }
                return html;
            }

            function addQuestion(type) {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                // Bắt đầu ghép chuỗi HTML
                let html = '';
                html += '<div class="question-form" id="question-' + questionCount + '">';
                html += '    <div class="question-header">';
                html += '        <div class="question-number">Câu ' + questionCount + '.</div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '        </button>';
                html += '    </div>';

                html += '    <div class="question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="' + type + '">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';

                // Gọi hàm sinh option (vì createOptionHTML trả về HTML)
                html += '        <div class="answer-options">' + createOptionHTML(questionCount) + '</div>';

                html += '        <button type="button" class="add-option-btn" onclick="addOption(' + questionCount + ')">';
                html += '            <i class="fas fa-plus"></i> Thêm phương án';
                html += '        </button>';

                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';

                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                // Thêm vào danh sách
                list.insertAdjacentHTML("beforeend", html);
            }


            function deleteQuestion(number) {
                // Xóa toàn bộ phần câu hỏi theo id
                var question = document.getElementById("question-" + number);
                if (question) {
                    question.remove();
                }
            }

            function removeOption(button) {
                // Tìm div cha có class .answer-option và xóa nó
                var optionDiv = button.closest(".answer-option");
                if (optionDiv) {
                    optionDiv.remove();
                }
            }

            function addOption(questionNumber) {
                var optionsDiv = document.querySelector("#question-" + questionNumber + " .answer-options");
                var currentCount = optionsDiv.querySelectorAll(".answer-option").length;
                var newIndex = currentCount + 1;

                var html = '';
                html += '<div class="answer-option">';
                html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + newIndex + '" ';
                html += '        id="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-checkbox">';
                html += '    <label for="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-label">';
                html += '        <i class="fas fa-check"></i>';
                html += '    </label>';
                html += '    <input type="text" name="optionContent' + questionNumber + '_' + newIndex + '" ';
                html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                html += '        <i class="fas fa-trash"></i>';
                html += '    </button>';
                html += '</div>';

                optionsDiv.insertAdjacentHTML("beforeend", html);
            }

            function addTextQuestion() {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                let html = '';
                html += '<div class="text-question-form" id="question-' + questionCount + '">';
                html += '    <div class="text-question-header">';
                html += '        <div class="text-question-number">Câu ' + questionCount + '.</div>';
                html += '        <div class="text-question-type">';
                html += '            <i class="fas fa-file-text"></i>';
                html += '            Câu hỏi dạng text';
                html += '        </div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '            Xóa';
                html += '        </button>';
                html += '    </div>';
                html += '    <div class="text-question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="text">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';
                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';
                html += '        <div class="answer-group">';
                html += '            <label class="answer-label">Đáp án đúng:</label>';
                html += '            <textarea name="correctAnswer' + questionCount + '" ';
                html += '                class="answer-input" placeholder="Nhập đáp án đúng cho câu hỏi này..." required></textarea>';
                html += '        </div>';
                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                list.insertAdjacentHTML("beforeend", html);
            }
//            window.onload = function () {
//                const form = document.getElementById("bulkQuestionForm");
//                form.addEventListener("submit", function (e) {
//                    const moduleSelect = document.getElementById("questionBank");
//                    console.log("Module selected:", moduleSelect.value);
//                    console.log("Form data:", new FormData(form));
//                    
//                    if (!moduleSelect.value) {
//                        alert("⚠️ Vui lòng chọn module trước khi lưu câu hỏi!");
//                        e.preventDefault();
//                        return;
//                    }
//                    
//                    // Check if there are any questions
//                    const questionCount = document.querySelectorAll('.question-form, .text-question-form').length;
//                    console.log("Question count:", questionCount);
//                    
//                    if (questionCount === 0) {
//                        alert("⚠️ Vui lòng thêm ít nhất một câu hỏi!");
//                        e.preventDefault();
//                        return;
//                    }
//                    
//                    console.log("Form submitting...");
//                });
//            };
        </script>
    </body>
</html>
