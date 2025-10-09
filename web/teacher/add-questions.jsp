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
                            <a href="module?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-play-circle"></i>
                                Nội dung khóa học
                            </a>
                            <a href="courseStudents?courseId=${course.courseId}" class="sidebar-link">
                                <i class="fas fa-users"></i>
                                Học sinh
                            </a>
                            <a href="ManageQuestionServlet" class="sidebar-link">
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


                        <!--                         Form Section 
                                                <div class="form-section">
                                                    <div class="form-row">
                                                        <div class="form-group">
                                                            <label for="questionBank">Ngân hàng câu hỏi *</label>
                                                            <select id="questionBank" name="questionBank" class="form-select" required>
                                                                <option value="">-- Chọn --</option>
                                                                <option value="1">Ngân hàng câu hỏi 1</option>
                                                                <option value="2">Ngân hàng câu hỏi 2</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                        
                                                 Questions List Section 
                                                <div class="questions-list-section">
                                                    <div class="section-header">
                                                        <h3>Danh sách câu hỏi</h3>
                                                        <button class="btn btn-outline collapse-btn">
                                                            <i class="fas fa-chevron-up"></i>
                                                            Thu gọn các câu hỏi
                                                        </button>
                                                    </div>
                        
                                                     Questions Content Area 
                                                    <div class="questions-content-area">
                                                        <div id="questionsList">
                                                            <div class="empty-questions">
                                                                <div class="empty-icon">
                                                                    <i class="fas fa-question-circle"></i>
                                                                </div>
                                                                <p>Chưa có câu hỏi nào được thêm</p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                        
                                                 Action Buttons 
                                                <div class="action-buttons">
                                                    <div class="left-actions">
                                                        <div class="dropdown">
                                                            <button class="btn btn-primary dropdown-toggle" onclick="toggleQuestionDropdown()">
                                                                <i class="fas fa-plus"></i>
                                                                Thêm câu hỏi
                                                            </button>
                                                            <div id="questionDropdown" class="dropdown-menu">
                                                                <a href="#" onclick="addQuestion('single')" class="dropdown-item">
                                                                    <i class="fas fa-circle"></i>
                                                                    Câu hỏi lựa chọn 1 đáp án
                                                                </a>
                                                                <a href="#" onclick="addQuestion('multiple')" class="dropdown-item">
                                                                    <i class="fas fa-check-square"></i>
                                                                    Chọn nhiều đáp án
                                                                </a>
                                                            </div>
                                                        </div>
                                                                                        <div class="dropdown">
                                                                                            <button class="btn btn-outline dropdown-toggle">
                                                                                                <i class="fas fa-file-word"></i>
                                                                                                Nhập từ Word
                                                                                            </button>
                                                                                        </div>
                                                                                        <button class="btn btn-outline">
                                                                                            <i class="fas fa-file-excel"></i>
                                                                                            Nhập từ Excel
                                                                                        </button>
                                                    </div>
                                                </div>-->

                        <!-- Navigation Buttons -->
                                                <div class="navigation-buttons">
                                                    <a href="ManageQuestionServlet" class="btn btn-outline">
                                                        <i class="fas fa-chevron-left"></i>
                                                        <<< Quay lại danh sách
                                                    </a>
                                                    <button class="btn btn-primary">
                                                        Lưu
                                                    </button>
                                                </div>
                    </div>
                </main>
            </div>
        </div>

        <script>

            let questionCount = 0;
            function createOptionHTML(questionNumber) {
                let html = "";
                for (let i = 1; i <= 4; i++) {
                    html +=
                            '<div>' +
                            '<input type="text" name="optionContent' + questionNumber + '_' + i + '" ' +
                            'class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">' +
                            '<input type="checkbox" name="correct' + questionNumber + '" value="' + i + '"> Đúng' +
                            '</div>';
                }
                return html;
            }


            function addQuestion(type) {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();
                const html =
                        '<div class="question-item" style="border:1px solid #ddd;padding:10px;margin-bottom:10px">' +
                        '<h4>Câu ' + questionCount + '</h4>' +
                        '<input type="hidden" name="questionType' + questionCount + '" value="' + type + '">' +
                        '<textarea name="questionText' + questionCount + '" placeholder="Nhập nội dung câu hỏi..." required></textarea>' +
                        '<div class="options">' + createOptionHTML(questionCount) + '</div>' +
                        '<textarea name="explanation' + questionCount + '" placeholder="Giải thích (nếu có)"></textarea>' +
                        '</div>';
                list.insertAdjacentHTML("beforeend", html);
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Collapse/Expand functionality
                const collapseBtn = document.querySelector('.collapse-btn');
                const questionsContent = document.querySelector('.questions-content-area');
                collapseBtn.addEventListener('click', function () {
                    const isCollapsed = questionsContent.style.display === 'none';
                    questionsContent.style.display = isCollapsed ? 'block' : 'none';
                    const icon = this.querySelector('i');
                    icon.className = isCollapsed ? 'fas fa-chevron-up' : 'fas fa-chevron-down';
                    this.innerHTML = isCollapsed ?
                            '<i class="fas fa-chevron-up"></i> Thu gọn các câu hỏi' :
                            '<i class="fas fa-chevron-down"></i> Mở rộng các câu hỏi';
                });
            });
            function toggleQuestionDropdown() {
                const dropdown = document.getElementById('questionDropdown');
                dropdown.classList.toggle('show');
            }

//            function addQuestion(type) {
//                questionCount++;
//                const questionsList = document.getElementById('questionsList');
//
//                // Remove empty state if exists
//                const emptyState = questionsList.querySelector('.empty-questions');
//                if (emptyState) {
//                    emptyState.remove();
//                }
//
//                const questionHtml = createQuestionForm(questionCount, type);
//                questionsList.insertAdjacentHTML('beforeend', questionHtml);
//
//                // Close dropdown
//                document.getElementById('questionDropdown').classList.remove('show');
//            }

            function createQuestionForm(questionNumber, type) {
                const isMultiple = type === 'multiple';
                const inputType = isMultiple ? 'checkbox' : 'radio';
                const iconClass = isMultiple ? 'fas fa-check-square' : 'fas fa-circle';
                const typeText = isMultiple ? 'Chọn nhiều đáp án' : 'Câu hỏi lựa chọn 1 đáp án';
                return `
                    <div class="question-form" id="question-${questionNumber}">
                        <div class="question-header">
                            <div class="question-number">Câu ${questionNumber}.</div>
                            <div class="question-type">
                                <i class="${iconClass}"></i>
            ${typeText}
                            </div>
                           
                       
                            <button class="delete-question-btn" onclick="deleteQuestion(${questionNumber})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                        
                        <div class="question-content">
                            <div class="question-input-group">
                               <input type="text" name="questionText' + questionNumber + '" class="question-input" placeholder="Nhập nội dung câu hỏi tại đây....">
                            </div>
                            
                            <div class="answer-options">
                                <div class="answer-option">
                                    <input type="checkbox" class="correct-answer-checkbox" id="correct-${questionNumber}-1">
                                    <label for="correct-${questionNumber}-1" class="correct-answer-label">
                                        <i class="fas fa-check"></i>
                                    </label>
                                    <input type="text" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                                    <button class="remove-option-btn" onclick="removeOption(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="answer-option">
                                    <input type="checkbox" class="correct-answer-checkbox" id="correct-${questionNumber}-2">
                                    <label for="correct-${questionNumber}-2" class="correct-answer-label">
                                        <i class="fas fa-check"></i>
                                    </label>
                                    <input type="text" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                                    <button class="remove-option-btn" onclick="removeOption(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="answer-option">
                                    <input type="checkbox" class="correct-answer-checkbox" id="correct-${questionNumber}-3">
                                    <label for="correct-${questionNumber}-3" class="correct-answer-label">
                                        <i class="fas fa-check"></i>
                                    </label>
                                    <input type="text" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                                    <button class="remove-option-btn" onclick="removeOption(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="answer-option">
                                    <input type="checkbox" class="correct-answer-checkbox" id="correct-${questionNumber}-4">
                                    <label for="correct-${questionNumber}-4" class="correct-answer-label">
                                        <i class="fas fa-check"></i>
                                    </label>
                                    <input type="text" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                                    <button class="remove-option-btn" onclick="removeOption(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <button class="add-option-btn" onclick="addOption(${questionNumber})">
                                <i class="fas fa-plus"></i>
                                Thêm phương án
                            </button>
                            
                            <div class="explanation-group">
                                <textarea class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (Nếu có)"></textarea>
                            </div>
                        </div>
                    </div>
                `;
            }



            function deleteQuestion(questionNumber) {
                const questionElement = document.getElementById(`question-${questionNumber}`);
                questionElement.remove();
                // Show empty state if no questions left
                const questionsList = document.getElementById('questionsList');
                if (questionsList.children.length === 0) {
                    questionsList.innerHTML = `
                        <div class="empty-questions">
                            <div class="empty-icon">
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <p>Chưa có câu hỏi nào được thêm</p>
                        </div>
                    `;
                }
            }

            function removeOption(button) {
                const optionElement = button.closest('.answer-option');
                optionElement.remove();
            }

            function addOption(questionNumber) {
                const answerOptions = document.querySelector(`#question-${questionNumber} .answer-options`);
                const optionCount = answerOptions.children.length + 1;
                const newOption = document.createElement('div');
                newOption.className = 'answer-option';
                newOption.innerHTML = `
                    <input type="checkbox" class="correct-answer-checkbox" id="correct-${questionNumber}-${optionCount}">
                    <label for="correct-${questionNumber}-${optionCount}" class="correct-answer-label">
                        <i class="fas fa-check"></i>
                    </label>
                    <input type="text" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                    <button class="remove-option-btn" onclick="removeOption(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                `;
                answerOptions.appendChild(newOption);
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function (event) {
                const dropdown = document.getElementById('questionDropdown');
                const dropdownToggle = document.querySelector('.dropdown-toggle');
                if (!dropdown.contains(event.target) && !dropdownToggle.contains(event.target)) {
                    dropdown.classList.remove('show');
                }
            });
        </script>
    </body>
</html>
