<%-- 
    Document   : add-questions
    Created on : Dec 27, 2024
    Author     : Lenovo
--%>

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
                        <form action="addQuestion" method="post" id="bulkQuestionForm">
                            <input type="hidden" name="courseId" value="${course.courseId}">
                            <div class="form-section">
                                <div class="form-group">
                                    <label for="questionBank">Ngân hàng câu hỏi *</label>
                                    <select id="questionBank" name="moduleId" class="form-select" required>
                                        <option value="">-- Chọn module --</option>
                                        <c:forEach var="m" items="${moduleList}">
                                            <option value="${m.moduleId}">${m.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div id="questionsList" class="questions-content-area">
                                <div class="empty-questions">
                                    <p>Chưa có câu hỏi nào được thêm</p>
                                </div>
                            </div>

                            <div class="actions">
                                <button type="button" class="btn btn-primary" onclick="addQuestion('mcq_single')">
                                    + Thêm câu hỏi
                                </button>
                                <button type="submit" class="btn btn-success">Lưu tất cả</button>
                            </div>
                        </form>

                    </div>
                </main>
            </div>
        </div>

        <script>
            let questionCount = 0;

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
    if (empty) empty.remove();

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



        </script>
    </body>
</html>
