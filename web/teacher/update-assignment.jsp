<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật Assignment</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <style>
            .assignment-form {
                background: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 24px;
            }
            
            .assignment-info {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
            }

            .assignment-info h3 {
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

            .form-section {
                margin-bottom: 24px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 8px;
                border-left: 4px solid #3498db;
            }

            .section-title {
                color: #2c3e50;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .section-title i {
                color: #3498db;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
                font-size: 14px;
            }

            .form-group label.required::after {
                content: ' *';
                color: #e74c3c;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s;
                font-family: inherit;
            }

            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            /* TinyMCE Editor Styling */
            .tox-tinymce {
                border-radius: 8px !important;
                border: 1px solid #ddd !important;
            }

            .tox .tox-editor-header {
                border-bottom: 1px solid #e9ecef !important;
            }

            .tox .tox-toolbar__primary {
                background: #f8f9fa !important;
            }

            .tox .tox-tbtn {
                border-radius: 4px !important;
            }

            .tox .tox-tbtn:hover {
                background: #e9ecef !important;
            }

            .form-group input[type="datetime-local"] {
                padding: 12px 16px;
            }

            .form-group input[type="file"] {
                padding: 8px 12px;
                border: 2px dashed #ddd;
                background: #f8f9fa;
                cursor: pointer;
            }

            .form-group input[type="file"]:hover {
                border-color: #3498db;
                background: #f0f8ff;
            }

            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 16px;
            }

            .checkbox-group input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .checkbox-group label {
                margin-bottom: 0;
                cursor: pointer;
                font-weight: 500;
            }

            .conditional-fields {
                margin-left: 26px;
                padding-left: 16px;
                border-left: 2px solid #e9ecef;
                margin-top: 8px;
            }

            .conditional-fields .form-group {
                margin-bottom: 12px;
            }

            .file-upload-area {
                border: 2px dashed #ddd;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                background: #f8f9fa;
                transition: all 0.3s;
                cursor: pointer;
            }

            .file-upload-area:hover {
                border-color: #3498db;
                background: #f0f8ff;
            }

            .file-upload-area.dragover {
                border-color: #3498db;
                background: #e3f2fd;
            }

            .upload-icon {
                font-size: 48px;
                color: #bdc3c7;
                margin-bottom: 12px;
            }

            .upload-text {
                color: #6c757d;
                font-size: 14px;
                margin-bottom: 8px;
            }

            .upload-hint {
                color: #95a5a6;
                font-size: 12px;
            }

            .file-list {
                margin-top: 16px;
            }

            .file-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 8px 12px;
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 6px;
                margin-bottom: 8px;
            }

            .file-info {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .file-info i {
                color: #3498db;
            }

            .file-name {
                font-size: 14px;
                color: #2c3e50;
            }

            .file-size {
                font-size: 12px;
                color: #6c757d;
            }

            .remove-file-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 4px 8px;
                cursor: pointer;
                font-size: 12px;
                transition: background-color 0.3s;
            }

            .remove-file-btn:hover {
                background: #c0392b;
            }

            .grading-section {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
            }

            .grading-section h4 {
                color: #856404;
                margin-bottom: 12px;
                font-size: 16px;
            }

            .grading-options {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            .grading-option {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 12px;
                background: white;
                border: 1px solid #ddd;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .grading-option:hover {
                border-color: #3498db;
                background: #f0f8ff;
            }

            .grading-option input[type="radio"] {
                margin: 0;
            }

            .grading-option.selected {
                border-color: #3498db;
                background: #e3f2fd;
            }

            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 20px;
                padding: 20px 0;
                border-top: 1px solid #eee;
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

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #c82333;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
            }

            .hint {
                font-size: 13px;
                color: #7f8c8d;
                margin-top: 8px;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 16px;
                font-size: 14px;
            }

            .alert-danger {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            .alert-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }

            .alert-info {
                background: #d1ecf1;
                border: 1px solid #bee5eb;
                color: #0c5460;
            }

            .current-assignment {
                background: #e8f4fd;
                border: 1px solid #b3d9ff;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
            }

            .current-assignment h3 {
                color: #2c3e50;
                margin-bottom: 12px;
                font-size: 18px;
            }

            .assignment-details {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
                margin-bottom: 16px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .detail-label {
                font-weight: 600;
                color: #2c3e50;
                font-size: 14px;
            }

            .detail-value {
                color: #6c757d;
                font-size: 14px;
                word-break: break-word;
            }

            .content-preview {
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 6px;
                padding: 12px;
                margin-top: 8px;
                max-height: 200px;
                overflow-y: auto;
            }
            .rubric-table input {
                border: 1px solid #ccc;
                border-radius: 4px;
                padding: 6px;
            }
            .rubric-table th, .rubric-table td {
                border: 1px solid #ddd;
                padding: 8px;
                vertical-align: middle;
            }
            .rubric-table tr:hover {
                background-color: #f9f9f9;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                    gap: 12px;
                }

                .grading-options {
                    grid-template-columns: 1fr;
                }

                .actions {
                    flex-direction: column;
                    align-items: stretch;
                }

                .assignment-details {
                    grid-template-columns: 1fr;
                }
            }
        </style>

        <script src="https://cdn.tiny.cloud/1/808iwiomkwovmb2cvokzivnjb0nka12kkujkdkuf8tpcoxtw/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                tinymce.init({
                    selector: '#description,#content,#gradingCriteria',
                    width: '150%',
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
           <c:set var="canEdit" value="${sessionScope.currentCourse.status == 'draft' || sessionScope.currentCourse.status == 'rejected'}" />
        <div id="page" data-courseid="${param.courseId}"></div>
        <div class="container" style="max-width: 1600px; margin: 0 auto; padding: 0 20px;">
            <a class="back-link" href="manageModule?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2><i class="fas fa-tasks"></i> Cập nhật Assignment</h2>
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
                                   <c:if test="${canEdit}">
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
                                    
                                    <div class="dropdown-item" onclick="createLesson('assignment', '${h.key.moduleId}')">
                                        <i class="fas fa-tasks" style="color: #27ae60;"></i>
                                        Tạo Assignment
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
                                            <c:choose>
                                                <c:when test="${item.moduleItemId == param.assignmentId}">
                                                    <div style="background-color: #e8f4fd; padding: 8px; border-radius: 4px; border-left: 3px solid #3498db;">
                                                        <i class="fas fa-tasks" style="color: #27ae60;"></i>
                                                        Assignment #${item.moduleItemId} (Đang chỉnh sửa)
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="updateAssignment?courseId=${param.courseId}&moduleId=${h.key.moduleId}&assignmentId=${item.moduleItemId}"
                                                       style="text-decoration: none; color: inherit;">
                                                        <i class="fas fa-tasks" style="color: #27ae60;"></i>
                                                        Assignment #${item.moduleItemId}
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:forEach>
                    </div>                
                    <div class="guide-section">
                        <div class="guide-label">HƯỚNG DẪN</div>
                        <div class="guide-icon">
                            <i class="fas fa-tasks" style="color: #27ae60;"></i>
                            <span>ASSIGNMENT</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: auto; min-height: 700px;">
                    <c:if test="${not empty requestScope.assignment}">
                        <!-- Current Assignment Information -->
                        <div class="current-assignment">
                            <h3><i class="fas fa-info-circle"></i> Thông tin Assignment hiện tại</h3>
                            <div class="assignment-details">
                                <div class="detail-item">
                                    <div class="detail-label">Tiêu đề:</div>
                                    <div class="detail-value">${requestScope.assignment.title}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Điểm tối đa:</div>
                                    <div class="detail-value">${requestScope.assignment.maxScore}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Loại nộp bài:</div>
                                    <div class="detail-value">${requestScope.assignment.submissionType}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Điểm đạt (%):</div>
                                    <div class="detail-value">${requestScope.assignment.passingScorePct != null ? requestScope.assignment.passingScorePct : 'Không yêu cầu'}</div>
                                </div>
                            </div>
                            <c:if test="${not empty requestScope.assignment.content}">
                                <div class="detail-item">
                                    <div class="detail-label">Nội dung:</div>
                                    <div class="content-preview">${requestScope.assignment.content}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty requestScope.assignment.instructions}">
                                <div class="detail-item">
                                    <div class="detail-label">Hướng dẫn:</div>
                                    <div class="content-preview">${requestScope.assignment.instructions}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty requestScope.assignment.promptSummary}">
                                <div class="form-group">
                                    <label for="promptSummary">Tóm tắt ngắn gọn</label>
                                    <input id="promptSummary" name="promptSummary" type="text" maxlength="300"
                                           value="${requestScope.assignment.promptSummary}"
                                           placeholder="Ví dụ: Viết đoạn văn 150 từ giới thiệu bản thân bằng tiếng Anh.">
                                    <div class="hint">Tối đa 300 ký tự — mô tả ngắn về nội dung hoặc yêu cầu của bài tập.</div>
                                </div>
                            </c:if>

                        </div>

                        <!-- Update Form -->
                        <form action="updateAssignment" method="post" enctype="multipart/form-data" id="updateForm">
                            <input type="hidden" name="courseId" value="${param.courseId}">
                            <input type="hidden" name="moduleId" value="${param.moduleId}">
                            <input type="hidden" name="assignmentId" value="${param.assignmentId}">

                            <!-- Basic Information Section -->
                            <div class="form-section">
                                <div class="section-title">
                                    <i class="fas fa-edit"></i>
                                    Thông tin cơ bản
                                </div>

                                <div class="form-group">
                                    <label for="title" class="required">Tiêu đề Assignment</label>
                                    <input id="title" name="title" type="text" value="${requestScope.assignment.title}" placeholder="Nhập tiêu đề assignment" required>
                                </div>

                                <div class="form-group">
                                    <label for="description">Hướng dẫn làm bài</label>
                                    <textarea id="description" name="description" placeholder="Hướng dẫn chi tiết về cách làm bài, yêu cầu và lưu ý cho học viên...">${requestScope.assignment.instructions}</textarea>
                                </div>

                                <div class="form-group">
                                    <label for="promptSummary">Tóm tắt ngắn gọn</label>
                                    <input id="promptSummary" name="promptSummary" type="text" maxlength="300"
                                           value="${requestScope.assignment.promptSummary}"
                                           placeholder="Ví dụ: Viết đoạn văn 150 từ giới thiệu bản thân bằng tiếng Anh.">
                                    <div class="hint">Tối đa 300 ký tự — mô tả ngắn về nội dung hoặc yêu cầu của bài tập.</div>
                                </div>

                                <div class="form-row">

                                    <div class="form-group">
                                        <label for="passingScorePct">Điểm đạt (%)</label>
                                        <input id="passingScorePct" name="passingScorePct" type="number" 
                                               value="${requestScope.assignment.passingScorePct != null ? requestScope.assignment.passingScorePct : ''}"
                                               placeholder="Để trống = không yêu cầu" min="0" max="100" step="0.1">
                                    </div>
                                </div>
                            </div>

                            <!-- Assignment Content Section -->
                            <div class="form-section">
                                <div class="section-title">
                                    <i class="fas fa-file-text"></i>
                                    Nội dung Assignment
                                </div>

                                <div class="form-group">
                                    <label for="content" class="required">Nội dung bài tập</label>
                                    <textarea id="content" name="content" placeholder="Nhập nội dung chi tiết của bài tập...">${requestScope.assignment.content}</textarea>
                                </div>
                            </div>

                            <!-- Grading and Submission Section -->
                            <div class="form-section">
                                <div class="section-title">
                                    <i class="fas fa-graduation-cap"></i>
                                    Phương thức chấm điểm và nộp bài
                                </div>

                                <div class="form-group">
                                    <label for="submissionType">Loại nộp bài</label>
                                    <select id="submissionType" name="submissionType">
                                        <option value="file" ${requestScope.assignment.submissionType == 'file' ? 'selected' : ''}>File đính kèm</option>
                                        <option value="text" ${requestScope.assignment.submissionType == 'text' ? 'selected' : ''}>Văn bản trực tuyến</option>
                                        
                                    </select>
                                </div>

                                <div class="form-section">
                                    <div class="section-title">
                                        <i class="fas fa-scale-balanced"></i>
                                        Tiêu chí chấm điểm (Rubric)
                                    </div>

                                    <table id="rubricTable" class="rubric-table" style="width:100%; border-collapse:collapse; background:white;">
                                        <thead style="background:#e3f2fd;">
                                            <tr>
                                                <th style="padding:8px; border:1px solid #ddd;">#</th>
                                                <th style="padding:8px; border:1px solid #ddd;">Trọng số</th>
                                                <th style="padding:8px; border:1px solid #ddd;">Hướng dẫn chấm điểm</th>
                                                    <c:if test="${canEdit}">
                                                    <th style="padding:8px; border:1px solid #ddd;">Hành động</th>
                                                </c:if>
                                            </tr>
                                        </thead>
                                        <tbody id="rubricBody">
                                            <c:forEach var="r" items="${rubricList}">
                                                <tr>
                                                    <td><input type="number" name="criterion_no" value="${r.criterionNo}" class="criterion-no" min="1" required style="width:60px;"></td>
                                                    <td><input type="number" name="weight" value="${r.weight}" class="criterion-weight" step="0.01" min="0" max="1" required style="width:80px;"></td>
                                                    <td><input type="text" name="guidance" value="${r.guidance}" class="criterion-guidance" required style="width:100%;"></td>
                                                         <c:if test="${canEdit}">
                                                        <td><button type="button" class="btn btn-danger" onclick="removeCriterion(this)">Xóa</button></td>
                                                    </c:if>

                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <div style="margin-top:10px;">
                                         <c:if test="${canEdit}">
                                            <button type="button" class="btn btn-success" onclick="addCriterion()">
                                                <i class="fas fa-plus"></i> Thêm tiêu chí
                                            </button>
                                         </c:if>
                                    </div>

                                    <div class="hint">
                                        <i class="fas fa-info-circle"></i> Tổng tất cả trọng số phải bằng <strong>1.0</strong>.
                                    </div>
                                </div>

                                <div class="checkbox-group">
                                    <input type="checkbox" id="aiGrading" name="aiGrading" value="true" ${requestScope.assignment.aiGradeAllowed ? 'checked' : ''}>
                                    <label for="aiGrading">Cho phép AI chấm bài tự động</label>
                                </div>
                                <div class="hint">
                                    <i class="fas fa-info-circle"></i>
                                    Khi bật tính năng này, hệ thống sẽ sử dụng AI để chấm điểm tự động dựa trên tiêu chí chấm điểm đã cung cấp.
                                </div>
                            </div>

                            <!-- File Upload Section -->
                            <div class="form-section">
                                <div class="section-title">
                                    <i class="fas fa-paperclip"></i>
                                    Tài liệu đính kèm
                                </div>

                                <c:if test="${not empty requestScope.assignment.attachmentUrl}">
                                    <div class="info-item">
                                        <i class="fas fa-file"></i>
                                        <span>Tài liệu hiện tại: <a href="${requestScope.assignment.attachmentUrl}" target="_blank">Xem tài liệu</a></span>
                                    </div>
                                </c:if>

                                <div class="file-upload-area" id="fileUploadArea">
                                    <div class="upload-icon">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div class="upload-text">Kéo thả file vào đây hoặc click để chọn</div>
                                    <div class="upload-hint">Hỗ trợ: PDF, DOC, DOCX, TXT, JPG, PNG (Tối đa 10MB)</div>
                                    <input type="file" id="attachments" name="attachments" multiple style="display: none;">
                                </div>

                                <div class="file-list" id="fileList"></div>
                            </div>

                            <!-- Error/Success Messages -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>

                            <!-- Action Buttons -->
                            <div class="actions">
                                <a class="btn btn-secondary" href="manageModule?courseId=${param.courseId}">
                                    <i class="fas fa-times"></i>
                                    Hủy bỏ
                                </a>
                               <c:if test="${canEdit}">
                                    <a href="deleteAssignment?courseId=${param.courseId}&moduleId=${param.moduleId}&assignmentId=${param.assignmentId}"
                                       class="btn btn-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa assignment này không? Hành động này không thể hoàn tác!');">
                                        <i class="fas fa-trash"></i>
                                        Xóa Assignment
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        Cập nhật Assignment
                                    </button>
                               </c:if>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${empty requestScope.assignment}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            Không tìm thấy assignment với ID: ${param.assignmentId}
                        </div>
                    </c:if>
                </main>
            </div>
        </div>

        <script>
            // Toggle dropdown functionality
            function toggleDropdown(dropdownId) {
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu.id !== dropdownId) {
                        menu.classList.remove('show');
                    }
                });
                const dropdown = document.getElementById(dropdownId);
                dropdown.classList.toggle('show');
            }

            // Create lesson navigation
            function createLesson(type, moduleId) {
                var courseId = document.getElementById('page').dataset.courseid || '';
                var url = '';

                if (type === 'video') {
                    url = "ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'reading') {
                    url = "createReadingLesson?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'discussion') {
                    url = "createDiscussion?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'assignment') {
                    url = "createAssignment?courseId=" + courseId + "&moduleId=" + moduleId;
                }

                if (url) {
                    window.location.href = url;
                }
            }

            // File upload functionality
            const fileUploadArea = document.getElementById('fileUploadArea');
            const fileInput = document.getElementById('attachments');
            const fileList = document.getElementById('fileList');
            let uploadedFiles = [];

            if (fileUploadArea && fileInput && fileList) {
                fileUploadArea.addEventListener('click', () => fileInput.click());
                fileUploadArea.addEventListener('dragover', handleDragOver);
                fileUploadArea.addEventListener('dragleave', handleDragLeave);
                fileUploadArea.addEventListener('drop', handleDrop);
                fileInput.addEventListener('change', handleFileSelect);
            }

            function handleDragOver(e) {
                e.preventDefault();
                fileUploadArea.classList.add('dragover');
            }

            function handleDragLeave(e) {
                e.preventDefault();
                fileUploadArea.classList.remove('dragover');
            }

            function handleDrop(e) {
                e.preventDefault();
                fileUploadArea.classList.remove('dragover');
                const files = Array.from(e.dataTransfer.files);
                handleFiles(files);
            }

            function handleFileSelect(e) {
                const files = Array.from(e.target.files);
                handleFiles(files);
            }

            function handleFiles(files) {
                files.forEach(file => {
                    if (validateFile(file)) {
                        uploadedFiles.push(file);
                        displayFile(file);
                    }
                });
            }

            function validateFile(file) {
                const maxSize = 10 * 1024 * 1024; // 10MB
                const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain', 'image/jpeg', 'image/png', 'audio/mpeg', 'audio/wav',
                    'audio/mp4', // .m4a
                    'audio/x-m4a']       // định dạng m4a phổ biến khác];

                if (file.size > maxSize) {
                    alert('File ' + file.name + ' quá lớn. Kích thước tối đa là 10MB.');
                    return false;
                }

                if (!allowedTypes.includes(file.type)) {
                    alert('File ' + file.name + ' không được hỗ trợ. Chỉ chấp nhận: PDF, DOC, DOCX, TXT, JPG, PNG.');
                    return false;
                }

                return true;
            }

            function displayFile(file) {
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                fileItem.innerHTML =
                        '<div class="file-info">' +
                        '<i class="fas fa-file"></i>' +
                        '<span class="file-name">' + file.name + '</span>' +
                        '<span class="file-size">(' + formatFileSize(file.size) + ')</span>' +
                        '</div>' +
                        '<button type="button" class="remove-file-btn" onclick="removeFile(\'' + file.name + '\')">' +
                        '<i class="fas fa-times"></i>' +
                        '</button>';
                fileList.appendChild(fileItem);
            }

            function removeFile(fileName) {
                uploadedFiles = uploadedFiles.filter(file => file.name !== fileName);
                updateFileList();
            }

            function updateFileList() {
                fileList.innerHTML = '';
                uploadedFiles.forEach(file => displayFile(file));
            }

            function formatFileSize(bytes) {
                if (bytes === 0)
                    return '0 Bytes';
                const k = 1024;
                const sizes = ['Bytes', 'KB', 'MB', 'GB'];
                const i = Math.floor(Math.log(bytes) / Math.log(k));
                return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
            }

            // Form validation
            document.getElementById('updateForm').addEventListener('submit', function (e) {
                const title = document.getElementById('title').value.trim();

                const content = document.getElementById('content').value.trim();

                if (!title) {
                    e.preventDefault();
                    alert('Vui lòng nhập tiêu đề assignment');
                    document.getElementById('title').focus();
                    return false;
                }



                if (!content) {
                    e.preventDefault();
                    alert('Vui lòng nhập nội dung assignment');
                    document.getElementById('content').focus();
                    return false;
                }

                // Sync TinyMCE content before submit
                tinymce.triggerSave();
            });

            // Close dropdowns when clicking outside
            document.addEventListener('click', function (event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

            function addCriterion() {
                const tbody = document.getElementById("rubricBody");
                const newRow = document.createElement("tr");
                newRow.innerHTML = `
        <td><input type="number" name="criterion_no" class="criterion-no" min="1" required style="width:60px;"></td>
        <td><input type="number" name="weight" class="criterion-weight" step="0.01" min="0" max="1" required style="width:80px;"></td>
        <td><input type="text" name="guidance" class="criterion-guidance" required style="width:100%;"></td>
        <td><button type="button" class="btn btn-danger" onclick="removeCriterion(this)">Xóa</button></td>
    `;
                tbody.appendChild(newRow);
            }

            function removeCriterion(btn) {
                const row = btn.closest("tr");
                row.remove();
                checkTotalWeight();
            }

            function checkTotalWeight() {
                let total = 0;
                document.querySelectorAll(".criterion-weight").forEach(input => {
                    const val = parseFloat(input.value);
                    if (!isNaN(val))
                        total += val;
                });
                if (Math.abs(total - 1) > 0.0001) {
                    document.querySelector(".hint").innerHTML =
                            `<i class="fas fa-exclamation-triangle" style="color:#e74c3c;"></i>
            Tổng trọng số hiện tại: <strong>${total.toFixed(2)}</strong> ⚠️ (Phải = 1.0)`;
                } else {
                    document.querySelector(".hint").innerHTML =
                            `<i class="fas fa-check-circle" style="color:#28a745;"></i>
            Tổng trọng số hợp lệ: <strong>1.0</strong>`;
                }
            }

// Kiểm tra tổng trọng số trước khi submit form
            document.getElementById("updateForm").addEventListener("submit", function (e) {
                let total = 0;
                document.querySelectorAll(".criterion-weight").forEach(input => {
                    const val = parseFloat(input.value);
                    if (!isNaN(val))
                        total += val;
                });
                if (Math.abs(total - 1) > 0.0001) {
                    e.preventDefault();
                    alert("Tổng trọng số của các tiêu chí phải bằng 1.0");
                }
            });
        </script>
    </body>
</html>



