<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem Câu hỏi - Module ${module.title}</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>

            .main-content {
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

            /* Questions Section Styling */
            .questions-section {
                margin-top: 20px;
                background: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .questions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 16px;
                border-bottom: 1px solid #eee;
            }

            .questions-title {
                font-size: 18px;
                font-weight: 600;
                color: #3498db;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .questions-title i {
                color: #3498db;
            }

            .collapse-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                background: #f8f9fa;
                border: 1px solid #ddd;
                border-radius: 6px;
                color: #6c757d;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .collapse-btn:hover {
                background: #e9ecef;
                border-color: #adb5bd;
            }

            .questions-content-area {
                min-height: 200px;
                max-height: 600px;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 20px;
                background: #fafafa;
                transition: all 0.3s ease;
                overflow-y: auto;
                overflow-x: hidden;
            }

            .questions-content-area.collapsed {
                max-height: 0;
                opacity: 0;
                margin: 0;
                padding: 0;
                overflow: hidden;
            }

            .questions-content-area.expanded {
                max-height: 600px;
                opacity: 1;
                overflow-y: auto;
            }

            /* Custom scrollbar for questions area */
            .questions-content-area::-webkit-scrollbar {
                width: 8px;
            }

            .questions-content-area::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            .questions-content-area::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 4px;
            }

            .questions-content-area::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }

            .question-form {
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 12px;
                margin-bottom: 20px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .question-header {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px 20px;
                background: #f8f9fa;
                border-bottom: 1px solid #e9ecef;
                flex-wrap: wrap;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .question-header-actions {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-left: auto;
            }

            .question-header:hover {
                background: #e9ecef;
            }

            .question-number {
                background: #3498db;
                color: white;
                padding: 6px 12px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 14px;
            }

            .question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #2c3e50;
                font-size: 14px;
                font-weight: 500;
            }

            .question-type i {
                color: #27ae60;
                font-size: 16px;
            }

            .question-toggle-btn {
                background: #6c757d;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 10px;
                cursor: pointer;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 12px;
                margin-left: auto;
            }

            .question-toggle-btn:hover {
                background: #5a6268;
            }

            .question-toggle-btn.collapsed {
                background: #28a745;
            }

            .question-toggle-btn.collapsed:hover {
                background: #218838;
            }

            .edit-question-btn {
                background: #f39c12;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: 8px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .edit-question-btn:hover {
                background: #e67e22;
            }

            .question-header .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: 8px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .question-header .delete-question-btn:hover {
                background: #c0392b;
            }

            .question-content {
                padding: 20px;
                transition: all 0.3s ease;
                overflow: hidden;
            }

            .question-content.collapsed {
                max-height: 0;
                padding: 0 20px;
                opacity: 0;
            }

            .question-content.expanded {
                max-height: 1000px;
                opacity: 1;
            }

            .question-text {
                font-size: 16px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 16px;
                line-height: 1.5;
            }

            .answer-options {
                margin-bottom: 16px;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 12px;
                padding: 12px 16px;
                border-radius: 8px;
                transition: background-color 0.3s;
                background: #f8f9fa;
                border-left: 4px solid #dee2e6;
            }

            .answer-option:hover {
                background: #e9ecef;
            }

            .answer-option.correct {
                background: #d4edda;
                border-left-color: #28a745;
            }

            .answer-option.incorrect {
                background: #f8d7da;
                border-left-color: #dc3545;
            }

            .correct-answer-label {
                width: 24px;
                height: 24px;
                border: 2px solid #ddd;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s;
                background: white;
            }

            .correct-answer-label.correct {
                background: #28a745;
                border-color: #28a745;
                color: white;
            }

            .correct-answer-label.incorrect {
                background: #dc3545;
                border-color: #dc3545;
                color: white;
            }

            .answer-input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background: white;
            }

            .explanation-group {
                margin-top: 16px;
            }

            .explanation-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: #e3f2fd;
                border-color: #bbdefb;
                color: #1565c0;
                font-style: italic;
            }

            .explanation-input::placeholder {
                color: #90caf9;
            }

            .empty-questions {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px;
                text-align: center;
                color: #6c757d;
            }

            .empty-questions i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #bdc3c7;
            }

            .empty-questions p {
                margin: 0;
                font-size: 16px;
            }

            .actions {
                display: flex;
                gap: 12px;
                margin-top: 20px;
                justify-content: flex-end;
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

            .btn-primary {
                background: #007bff;
                color: white;
            }

            .btn-primary:hover {
                background: #0056b3;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
            }

            /* Edit mode styles */
            .question-form.editing {
                border: 2px solid #f39c12;
                box-shadow: 0 4px 12px rgba(243, 156, 18, 0.2);
            }

            .question-form.editing .question-header {
                background: #fef9e7;
                border-bottom-color: #f39c12;
            }

            .btn-save {
                background: #27ae60 !important;
                color: white !important;
            }

            .btn-save:hover {
                background: #229954 !important;
            }

            .remove-option-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 4px 8px;
                cursor: pointer;
                font-size: 12px;
                transition: background-color 0.3s;
            }

            .remove-option-btn:hover {
                background: #c0392b;
            }

            .add-option-btn {
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                cursor: pointer;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: background-color 0.3s;
                margin-bottom: 16px;
            }

            .add-option-btn:hover {
                background: #229954;
            }

            .question-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 16px;
                line-height: 1.5;
                resize: vertical;
                min-height: 60px;
            }

            .correct-answer-checkbox {
                display: none;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .questions-section {
                    padding: 16px;
                    margin-top: 20px;
                }

                .questions-header {
                    flex-direction: column;
                    gap: 12px;
                    align-items: flex-start;
                }

                .question-content {
                    padding: 16px;
                }

                .question-text {
                    font-size: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div id="page" data-courseid="${param.courseId}"></div>
        <div class="container" style="max-width: 1500px;">
            <a class="back-link" href="questions.jsp?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Xem Câu hỏi - Module: ${module.title}</h2>
            </div>
            
            <!-- Main Content -->
            <div class="main-content" style="height: auto; min-height: 700px; max-width: 1200px; margin: 0 auto;">
                    <!-- Dữ liệu mẫu để test giao diện -->
                    <c:set var="questionMap" value="${questionMap}" scope="request" />
                    <c:if test="${empty questionMap}">
                       
                    </c:if>
                    
                    <c:choose>
                        <c:when test="${not empty questionMap}">
                            <div class="questions-section">
                                <div class="questions-header">
                                    <h3 class="questions-title">
                                        <i class="fas fa-question-circle"></i>
                                        Câu hỏi của module (${questionMap.size()} câu)
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
                                                    <a href="deleteQuestion?courseId=${param.courseId}&moduleId=${param.moduleId}&questionId=${entry.key.questionId}"
                                                       class="delete-question-btn"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?'); event.stopPropagation();">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="question-content expanded" id="question-${status.index + 1}">
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
                                    </c:forEach>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="questions-section">
                                <div class="questions-header">
                                    <h3 class="questions-title">
                                        <i class="fas fa-question-circle"></i>
                                        Câu hỏi của module
                                    </h3>
                                </div>
                                <div class="questions-content-area expanded">
                                    <div class="empty-questions">
                                        <i class="fas fa-question-circle"></i>
                                        <p>Module này chưa có câu hỏi nào</p>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="actions">
                        <a href="add-questions.jsp?courseId=${param.courseId}&moduleId=${param.moduleId}" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Thêm câu hỏi mới
                        </a>
                        <a href="questions.jsp?courseId=${param.courseId}" class="btn btn-secondary">
                            <i class="fas fa-list"></i> Xem tất cả modules
                        </a>
                    </div>
            </div>
        </div>

        <script>
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

            // Toggle individual question content
            function toggleQuestionContent(questionId) {
                const content = document.getElementById(questionId);
                const toggle = document.getElementById('toggle-' + questionId.split('-')[1]);

                if (content.classList.contains('expanded')) {
                    content.classList.remove('expanded');
                    content.classList.add('collapsed');
                    toggle.classList.add('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-down"></i> Mở rộng';
                } else {
                    content.classList.remove('collapsed');
                    content.classList.add('expanded');
                    toggle.classList.remove('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-up"></i> Thu gọn';
                }
            }

            // Edit question functionality
            function editQuestion(questionId) {
                const qForm = document.querySelector('[data-question-id="' + questionId + '"]');
                const editBtn = qForm.querySelector('.edit-question-btn');

                if (!qForm) {
                    alert("Không tìm thấy câu hỏi này!");
                    return;
                }

                // Nếu đang ở chế độ chỉnh sửa => lưu thay đổi
                if (qForm.classList.contains('editing')) {
                    saveQuestion(qForm, questionId);
                } else {
                    // Bật chế độ chỉnh sửa
                    enableEdit(qForm, editBtn);
                }
            }

            function enableEdit(qForm, editBtn) {
                qForm.classList.add('editing');
                editBtn.innerHTML = '<i class="fas fa-save"></i> Lưu';
                editBtn.classList.add('btn-save');
                makeQuestionEditable(qForm);
            }

            function saveQuestion(qForm, questionId) {
                const questionTextInput = qForm.querySelector('.question-input');
                const explanationInput = qForm.querySelector('.explanation-input');

                if (!questionTextInput) {
                    alert("Không tìm thấy ô nhập câu hỏi!");
                    return;
                }

                // Tạo form để submit dữ liệu
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'updateQuestion';
                
                // Thêm các input hidden
                const courseId = document.getElementById('page').dataset.courseid;
                addHiddenInput(form, 'courseId', courseId);
                addHiddenInput(form, 'moduleId', '${param.moduleId}');
                addHiddenInput(form, 'questionId', questionId);
                addHiddenInput(form, 'questionText', questionTextInput.value);
                addHiddenInput(form, 'explanation', explanationInput ? explanationInput.value : "");

                // Thêm các phương án trả lời
                qForm.querySelectorAll('.answer-input').forEach((input, i) => {
                    if (input.value.trim()) {
                        addHiddenInput(form, 'optionContent_' + (i + 1), input.value);
                    }
                });

                // Thêm đáp án đúng
                qForm.querySelectorAll('.correct-answer-checkbox:checked').forEach(cb => {
                    addHiddenInput(form, 'correct', cb.value);
                });

                // Submit form
                document.body.appendChild(form);
                form.submit();
            }

            function addHiddenInput(form, name, value) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }

            function makeQuestionEditable(questionForm) {
                
                convertQuestionToTextarea(questionForm);

                
                makeOptionsEditable(questionForm);

               
                makeExplanationEditable(questionForm);

                
                addOptionButton(questionForm);
            }

            function convertQuestionToTextarea(questionForm) {
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
            }

            function makeOptionsEditable(questionForm) {
                const answerOptions = questionForm.querySelectorAll('.answer-option');
                answerOptions.forEach((option, index) => {
                    const input = option.querySelector('.answer-input');
                    if (input) {
                        input.removeAttribute('readonly');
                        input.name = 'editOptionContent_' + (index + 1);
                    }

                    // Thêm checkbox chọn đáp án đúng
                    if (!option.querySelector('.correct-answer-checkbox')) {
                        addCorrectAnswerCheckbox(option, index, questionForm);
                    }

                    // Thêm nút xóa phương án
                    if (!option.querySelector('.remove-option-btn')) {
                        addRemoveButton(option);
                    }
                });
            }

            function addCorrectAnswerCheckbox(option, index, questionForm) {
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

                // Đánh dấu đáp án đúng ban đầu
                if (option.classList.contains('correct')) {
                    checkbox.checked = true;
                    label.classList.add('correct');
                }

                // Xử lý sự kiện click
                label.onclick = function () {
                    toggleCorrectAnswer(checkbox, label, questionForm);
                };

                const input = option.querySelector('.answer-input');
                option.insertBefore(checkbox, input);
                option.insertBefore(label, input);
            }

            function toggleCorrectAnswer(checkbox, label, questionForm) {
                // Bỏ chọn tất cả các đáp án khác
                questionForm.querySelectorAll('.correct-answer-checkbox').forEach(cb => {
                    if (cb !== checkbox) {
                        cb.checked = false;
                        cb.nextElementSibling.classList.remove('correct');
                    }
                });

                // Toggle đáp án hiện tại
                checkbox.checked = !checkbox.checked;
                if (checkbox.checked) {
                    label.classList.add('correct');
                } else {
                    label.classList.remove('correct');
                }
            }

            function addRemoveButton(option) {
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-option-btn';
                removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
                removeBtn.onclick = function () {
                    removeOption(removeBtn);
                };
                option.appendChild(removeBtn);
            }

            function makeExplanationEditable(questionForm) {
                const explanationTextarea = questionForm.querySelector('.explanation-input');
                if (explanationTextarea) {
                    explanationTextarea.removeAttribute('readonly');
                    explanationTextarea.name = 'editExplanation';
                }
            }

            function addOptionButton(questionForm) {
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

            function addOptionToEdit(questionForm) {
                const answerOptionsContainer = questionForm.querySelector('.answer-options');
                const currentCount = answerOptionsContainer.querySelectorAll('.answer-option').length;
                const newIndex = currentCount + 1;

                const optionDiv = document.createElement('div');
                optionDiv.className = 'answer-option';

                // Tạo checkbox
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.name = 'correct';
                checkbox.value = newIndex;
                checkbox.id = 'edit-correct-' + newIndex;
                checkbox.className = 'correct-answer-checkbox';

                // Tạo label
                const label = document.createElement('label');
                label.htmlFor = 'edit-correct-' + newIndex;
                label.className = 'correct-answer-label';
                label.innerHTML = '<i class="fas fa-check"></i>';
                label.onclick = function () {
                    toggleCorrectAnswer(checkbox, label, questionForm);
                };

                // Tạo input text
                const input = document.createElement('input');
                input.type = 'text';
                input.name = 'editOptionContent_' + newIndex;
                input.className = 'answer-input';
                input.placeholder = 'Nhập phương án. Ví dụ: Việt Nam';

                // Tạo nút xóa
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-option-btn';
                removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
                removeBtn.onclick = function () {
                    removeOption(removeBtn);
                };

                // Thêm các phần tử vào div
                optionDiv.appendChild(checkbox);
                optionDiv.appendChild(label);
                optionDiv.appendChild(input);
                optionDiv.appendChild(removeBtn);

                answerOptionsContainer.insertBefore(optionDiv, answerOptionsContainer.querySelector('.add-option-btn'));
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

            function removeOption(button) {
                var optionDiv = button.closest(".answer-option");
                if (optionDiv)
                    optionDiv.remove();
            }
        </script>
    </body>
</html>
