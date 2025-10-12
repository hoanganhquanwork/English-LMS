<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật bài học dạng video</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link rel="stylesheet" href="css/teacher-video.css">
        <link rel="stylesheet" href="css/teacher-questions.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
       
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
                <main class="main-content" style="height: 800px">
                    <div class="lesson-header">
                        <div class="lesson-title">
                            <a href="module.jsp?courseId=${param.courseId}" class="back-arrow">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            <h1>Cập nhật bài học dạng video</h1>
                        </div>
                        <div class="lesson-actions">
                            <a href="deleteLesson?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}" 
                               class="action-btn delete-lesson-btn"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này không?')">
                                <i class="fas fa-trash"></i>
                                Xóa bài học
                            </a>
                        </div>
                    </div>

                    <form action="updateLesson" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

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

                            <!-- Action Buttons -->


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
                    <c:if test="${not empty questionMap}">
                        <div class="questions-section" style="margin-top: 100px;">
                            <div class="questions-header">
                                <h3 class="questions-title">
                                    <i class="fas fa-question-circle"></i>
                                    Câu hỏi của bài học
                                </h3>
                                <button class="collapse-btn" onclick="toggleQuestionsCollapse()">
                                    <i class="fas fa-chevron-up"></i>
                                    Thu gọn
                                </button>
                            </div>
                            <div class="questions-content-area expanded" id="questionsContent">
                                <c:forEach var="entry" items="${questionMap}" varStatus="status">
                                    <div class="question-form" data-question-id="${entry.key.questionId}">
                                        <div class="question-header" onclick="toggleQuestionContent('question-${status.index + 1}')">
                                            <div class="question-number">Câu ${status.index + 1}</div>
                                            <div class="question-type">
                                                <i class="fas fa-check-circle"></i>
                                                Trắc nghiệm
                                            </div>
                                            <div class="question-header-actions">
                                                <button class="question-toggle-btn" id="toggle-${status.index + 1}" onclick="event.stopPropagation(); toggleQuestionContent('question-${status.index + 1}')">
                                                    <i class="fas fa-chevron-up"></i>
                                                    Thu gọn
                                                </button>
                                                <button class="edit-question-btn" onclick="event.stopPropagation(); editQuestion('${entry.key.questionId}')">
                                                    <i class="fas fa-edit"></i>
                                                    Chỉnh sửa
                                                </button>
                                                <a href="deleteQuestion?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}&questionId=${entry.key.questionId}"
                                                   class="delete-question-btn"
                                                   style="text-decoration: none;"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?'); event.stopPropagation();">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </a>
                                            </div>
                                        </div>
                                        <div class="question-content expanded" id="question-${status.index + 1}" >
                                            <div class="question-text">${entry.key.content}</div>
                                            <div class="answer-options">
                                                <c:forEach var="opt" items="${entry.value}">
                                                    <div class="answer-option ${opt.correct ? 'correct' : 'incorrect'}">
                                                        <div class="correct-answer-label ${opt.correct ? 'correct' : 'incorrect'}">
                                                            <i class="fas ${opt.correct ? 'fa-check' : 'fa-times'}"></i>
                                                        </div>
                                                        <input type="text" class="answer-input" value="${opt.content}" readonly>
                                                    </div>
                                                </c:forEach>
                                            </div>

                                            <div class="explanation-group">
                                                <textarea class="explanation-input" readonly>${entry.key.explanation}</textarea>
                                            </div>

                                        </div>
                                    </div>
                                    <form id="updateForm-${entry.key.questionId}" action="updateQuestion" method="post" style="display:none;">
                                        <input type="hidden" name="courseId" value="${param.courseId}">
                                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">
                                        <input type="hidden" name="questionId" value="${entry.key.questionId}">
                                    </form>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <form action="addQuestion" class="add-questions-page" style="margin-top: 60px;" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

                        <div class="questions-section">
                            <div class="questions-header">
                                <h3 class="questions-title">
                                    <i class="fas fa-plus-circle"></i>
                                    Thêm câu hỏi mới
                                </h3>
                            </div>
                            <div class="questions-content-area expanded">
                                <div id="questionsList">
                                    <div class="empty-questions">
                                        <i class="fas fa-question-circle"></i>
                                        <p>Chưa có câu hỏi nào được thêm</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="actions" style="margin-top: 20px; display: flex; gap: 12px; justify-content: flex-end;">
                            <button type="button" class="btn btn-primary" onclick="addQuestion('mcq_single')">
                                <i class="fas fa-plus"></i> Thêm câu hỏi
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Lưu câu hỏi
                            </button>
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


            function editQuestion(questionId) {
                const qForm = document.querySelector('[data-question-id="' + questionId + '"]');
                const form = document.getElementById('updateForm-' + questionId);
                const editBtn = qForm.querySelector('.edit-question-btn');

                if (!qForm) {
                    alert("Không tìm thấy câu hỏi này trong DOM!");
                    return;
                }

                // Nếu đang ở chế độ chỉnh sửa => bấm lại để lưu
                if (qForm.classList.contains('editing')) {
                    const questionTextInput = qForm.querySelector('.question-input');
                    const explanationInput = qForm.querySelector('.explanation-input');

                    if (!questionTextInput) {
                        alert("Không tìm thấy ô nhập câu hỏi — hãy bấm 'Chỉnh sửa' trước khi lưu!");
                        return;
                    }

                    const questionText = questionTextInput.value;
                    const explanation = explanationInput ? explanationInput.value : "";

                    qForm.querySelectorAll('.answer-input').forEach((input, i) => {
                        const hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = 'optionContent_' + (i + 1);
                        hidden.value = input.value;
                        form.appendChild(hidden);
                    });
                    qForm.querySelectorAll('.correct-answer-checkbox:checked').forEach(cb => {
                        const hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = 'correct';
                        hidden.value = cb.value;
                        form.appendChild(hidden);
                    });

                    form.appendChild(Object.assign(document.createElement('input'), {
                        type: 'hidden',
                        name: 'questionText',
                        value: questionText
                    }));
                    form.appendChild(Object.assign(document.createElement('input'), {
                        type: 'hidden',
                        name: 'explanation',
                        value: explanation
                    }));

                    form.submit();
                }
                // Nếu chưa ở chế độ chỉnh sửa => bật chỉnh sửa
                else {
                    qForm.classList.add('editing');
                    editBtn.innerHTML = '<i class="fas fa-save"></i> Lưu';
                    editBtn.classList.add('btn-save');
                    makeQuestionEditable(qForm);
                }
            }


            function makeQuestionEditable(questionForm) {
                const questionText = questionForm.querySelector('.question-text');
                if (questionText) {
                    const textarea = document.createElement('textarea');
                    textarea.className = 'question-input';
                    textarea.value = questionText.textContent;
                    textarea.name = 'editQuestionText';
                    textarea.placeholder = 'Nhập nội dung câu hỏi...';
                    textarea.required = true;
                    questionText.parentNode.replaceChild(textarea, questionText);
                }

                const answerOptions = questionForm.querySelectorAll('.answer-option');
                answerOptions.forEach(function (option, index) {
                    const input = option.querySelector('.answer-input');
                    if (input) {
                        input.removeAttribute('readonly');
                        input.name = 'editOptionContent_' + (index + 1);
                    }

                    // Add checkbox for correct answer selection if not exists
                    if (!option.querySelector('.correct-answer-checkbox')) {
                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.name = 'correct';
                        checkbox.value = (index + 1);
                        checkbox.id = 'edit-correct-' + (index + 1);
                        checkbox.className = 'correct-answer-checkbox';

                        const label = document.createElement('label');
                        label.htmlFor = 'edit-correct-' + (index + 1);
                        label.className = 'correct-answer-label';
                        label.innerHTML = '<i class="fas fa-check"></i>';

                        // Check if this option was originally correct
                        if (option.classList.contains('correct')) {
                            checkbox.checked = true;
                            label.classList.add('correct');
                        }

                        // Add click handler for label
                        label.onclick = function () {
                            // Uncheck all other options
                            const allCheckboxes = questionForm.querySelectorAll('.correct-answer-checkbox');
                            allCheckboxes.forEach(function (cb) {
                                if (cb !== checkbox) {
                                    cb.checked = false;
                                    cb.nextElementSibling.classList.remove('correct');
                                }
                            });

                            // Toggle current option
                            if (checkbox.checked) {
                                label.classList.add('correct');
                            } else {
                                label.classList.remove('correct');
                            }
                        };

                        option.insertBefore(checkbox, input);
                        option.insertBefore(label, input);
                    }

                    if (!option.querySelector('.remove-option-btn')) {
                        const removeBtn = document.createElement('button');
                        removeBtn.type = 'button';
                        removeBtn.className = 'remove-option-btn';
                        removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
                        removeBtn.onclick = function () {
                            removeOption(removeBtn);
                        };
                        option.appendChild(removeBtn);
                    }
                });

                const explanationTextarea = questionForm.querySelector('.explanation-input');
                if (explanationTextarea) {
                    explanationTextarea.removeAttribute('readonly');
                    explanationTextarea.name = 'editExplanation';
                }

                const answerOptionsContainer = questionForm.querySelector('.answer-options');
                if (answerOptionsContainer && !answerOptionsContainer.querySelector('.add-option-btn')) {
                    const addOptionBtn = document.createElement('button');
                    addOptionBtn.type = 'button';
                    addOptionBtn.className = 'add-option-btn';
                    addOptionBtn.innerHTML = '<i class="fas fa-plus"></i> Thêm phương án';
                    addOptionBtn.onclick = function () {
                        addOptionToEdit(questionForm);
                    };
                    answerOptionsContainer.appendChild(addOptionBtn);
                }
            }

            function makeQuestionReadonly(questionForm) {
                const questionTextarea = questionForm.querySelector('.question-input');
                if (questionTextarea) {
                    const questionText = document.createElement('div');
                    questionText.className = 'question-text';
                    questionText.textContent = questionTextarea.value;
                    questionTextarea.parentNode.replaceChild(questionText, questionTextarea);
                }

                const answerOptions = questionForm.querySelectorAll('.answer-option');
                answerOptions.forEach(function (option) {
                    const input = option.querySelector('.answer-input');
                    if (input) {
                        input.setAttribute('readonly', 'readonly');
                    }

                    // Remove checkbox and label for correct answer selection
                    const checkbox = option.querySelector('.correct-answer-checkbox');
                    const label = option.querySelector('.correct-answer-label');
                    if (checkbox)
                        checkbox.remove();
                    if (label)
                        label.remove();

                    const removeBtn = option.querySelector('.remove-option-btn');
                    if (removeBtn)
                        removeBtn.remove();
                });

                const explanationTextarea = questionForm.querySelector('.explanation-input');
                if (explanationTextarea) {
                    explanationTextarea.setAttribute('readonly', 'readonly');
                }

                const addOptionBtn = questionForm.querySelector('.add-option-btn');
                if (addOptionBtn)
                    addOptionBtn.remove();
            }

            function addOptionToEdit(questionForm) {
                const answerOptionsContainer = questionForm.querySelector('.answer-options');
                const currentCount = answerOptionsContainer.querySelectorAll('.answer-option').length;
                const newIndex = currentCount + 1;

                const optionDiv = document.createElement('div');
                optionDiv.className = 'answer-option';
                optionDiv.innerHTML =
                        '<input type="checkbox" name="correct" value="' + newIndex + '" ' +
                        'id="edit-correct-' + newIndex + '" class="correct-answer-checkbox">' +
                        '<label for="edit-correct-' + newIndex + '" class="correct-answer-label" onclick="toggleCorrectAnswer(this)">' +
                        '<i class="fas fa-check"></i></label>' +
                        '<input type="text" name="editOptionContent_' + newIndex + '" class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">' +
                        '<button type="button" class="remove-option-btn" onclick="removeOption(this)">' +
                        '<i class="fas fa-trash"></i></button>';

                answerOptionsContainer.insertBefore(optionDiv, answerOptionsContainer.querySelector('.add-option-btn'));
            }

            // Function to toggle correct answer selection
            function toggleCorrectAnswer(clickedLabel) {
                const checkbox = clickedLabel.previousElementSibling;
                const questionForm = clickedLabel.closest('.question-form');

                // Uncheck all other options in this question
                const allCheckboxes = questionForm.querySelectorAll('.correct-answer-checkbox');
                allCheckboxes.forEach(function (cb) {
                    if (cb !== checkbox) {
                        cb.checked = false;
                        cb.nextElementSibling.classList.remove('correct');
                    }
                });

                // Toggle current option
                checkbox.checked = !checkbox.checked;
                if (checkbox.checked) {
                    clickedLabel.classList.add('correct');
                } else {
                    clickedLabel.classList.remove('correct');
                }
            }

        </script>
    </body>
</html>
