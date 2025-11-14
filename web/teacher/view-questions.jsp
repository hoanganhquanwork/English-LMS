<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

            /* Modal Animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal.show {
                display: flex !important;
                align-items: center;
                justify-content: center;
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
          <c:set var="canEdit" value="${sessionScope.currentCourse.status == 'draft' || sessionScope.currentCourse.status == 'rejected'}" />
        <div id="page" data-courseid="${param.courseId}"></div>
        <div class="container" style="max-width: 1500px;">
            <a class="back-link" href="ManageQuestionServlet?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Xem Câu hỏi - Module: ${module.title}</h2>
            </div>

            <!-- Main Content -->
            <div class="main-content" style="height: auto; min-height: 700px; max-width: 1200px; margin: 0 auto;">
                <!-- Questions Table -->
                <div class="table-container" style="margin-top: 20px;">
                    <h3 style="margin-bottom: 20px; color: #2c3e50;">Danh sách câu hỏi module</h3>
                    <table class="questions-table" style="width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <thead>
                            <tr style="background: #f8f9fa;">
                                <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">ID</th>
                                <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Nội dung câu hỏi</th>
                                <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Chủ đề</th>
                                <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Loại</th>
                                <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty questionMap}">
                                    <c:forEach var="entry" items="${questionMap}">
                                        <tr style="border-bottom: 1px solid #e9ecef;">
                                            <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">${entry.key.questionId}</td>
                                            <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                <div style="max-width: 400px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; line-height: 1.4;" title="${entry.key.content}">
                                                    ${fn:substring(entry.key.content, 0, 60)}...
                                                </div>
                                            </td>
                                            <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                <c:choose>
                                                    <c:when test="${entry.key.topicId != null}">
                                                        <c:forEach var="topic" items="${topics}">
                                                            <c:if test="${topic.topicId == entry.key.topicId}">
                                                                ${topic.name}
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>Không có</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                <c:choose>
                                                    <c:when test="${entry.key.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                    <c:when test="${entry.key.type == 'text'}">Tự luận</c:when>
                                                    <c:otherwise>${entry.key.type}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                <div style="display: flex; gap: 8px;">
                                                    <a href="#" 
                                                       style="padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: #3498db; color: white;"
                                                       data-id="${entry.key.questionId}"
                                                       data-content="${fn:escapeXml(entry.key.content)}"
                                                       data-type="${entry.key.type}"
                                                       data-explanation="${fn:escapeXml(entry.key.explanation)}"
                                                       data-file="${entry.key.mediaUrl}"
                                                       data-topic="<c:choose><c:when test='${entry.key.topicId != null}'><c:forEach var='topic' items='${topics}'><c:if test='${topic.topicId == entry.key.topicId}'>${topic.name}</c:if></c:forEach></c:when><c:otherwise>Không có</c:otherwise></c:choose>"
                                                                       data-status="active"
                                                       <c:if test="${entry.key.type == 'mcq_single'}">
                                                           data-options="<c:forEach var='opt' items='${entry.value}' varStatus='loop'>${fn:escapeXml(opt.content)}|${opt.correct ? 'true' : 'false'}${!loop.last ? ',' : ''}</c:forEach>"
                                                       </c:if>
                                                       <c:if test="${entry.key.type == 'text'}">
                                                           data-answer="${entry.value}"
                                                       </c:if>
                                                       onclick="openViewQuestion(this)">
                                                        <i class="fas fa-eye"></i> Xem
                                                    </a>
                                                     <c:if test="${canEdit}">
                                                        <a href="deleteQuestionFromModule?courseId=${param.courseId}&moduleId=${param.moduleId}&questionId=${entry.key.questionId}"
                                                           style="padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: #e74c3c; color: white;"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?');">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                     </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 40px; color: #6c757d; font-style: italic;">
                                            <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 16px; color: #dee2e6;"></i>
                                            <p>Module này chưa có câu hỏi nào</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>


            </div>
        </div>

        <!-- View Question Modal -->
        <div id="viewQuestionModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); animation: fadeIn 0.3s ease;">
            <div class="modal-content" style="background: white; border-radius: 12px; padding: 30px; max-width: 800px; width: 90%; max-height: 90vh; overflow-y: auto; box-shadow: 0 10px 30px rgba(0,0,0,0.3); animation: slideInUp 0.3s ease; margin: auto; margin-top: 5%;">
                <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #e9ecef;">
                    <h2 class="modal-title" style="font-size: 24px; font-weight: 600; color: #2c3e50; margin: 0;">
                        <i class="fas fa-eye" style="color: #3498db; margin-right: 10px;"></i>
                        Xem chi tiết câu hỏi
                    </h2>
                    <button class="close-btn" onclick="closeViewModal()" style="background: none; border: none; font-size: 24px; color: #6c757d; cursor: pointer; padding: 5px; border-radius: 4px; transition: all 0.3s;">&times;</button>
                </div>
                <div class="modal-body" style="margin-bottom: 25px;">
                    <div class="question-details">
                        <div class="question-info" style="margin-bottom: 20px;">
                            <div class="info-row" style="display: flex; margin-bottom: 10px;">
                                <label style="font-weight: 600; color: #2c3e50; width: 120px;">ID:</label>
                                <span id="viewQuestionId" style="color: #6c757d;"></span>
                            </div>
                            <div class="info-row" style="display: flex; margin-bottom: 10px;">
                                <label style="font-weight: 600; color: #2c3e50; width: 120px;">Loại:</label>
                                <span id="viewQuestionType" style="color: #6c757d;"></span>
                            </div>
                            <div class="info-row" style="display: flex; margin-bottom: 10px;">
                                <label style="font-weight: 600; color: #2c3e50; width: 120px;">Module:</label>
                                <span id="viewQuestionTopic" style="color: #6c757d;"></span>
                            </div>
                            <div class="info-row" style="display: flex; margin-bottom: 10px;">
                                <label style="font-weight: 600; color: #2c3e50; width: 120px;">Trạng thái:</label>
                                <span id="viewQuestionStatus" style="color: #6c757d;"></span>
                            </div>
                        </div>

                        <div class="question-content-section" style="margin-bottom: 20px;">
                            <label style="font-weight: 600; color: #2c3e50; margin-bottom: 10px; display: block;">Nội dung câu hỏi:</label>
                            <div id="viewQuestionContent" style="background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #3498db; font-size: 16px; line-height: 1.6; color: #2c3e50;"></div>
                        </div>

                        <div id="viewMcqOptions" style="margin-bottom: 20px; display: none;">
                            <label style="font-weight: 600; color: #2c3e50; margin-bottom: 10px; display: block;">Các phương án trả lời:</label>
                            <div id="viewAnswerOptions" style="background: #f8f9fa; padding: 15px; border-radius: 8px;"></div>
                        </div>

                        <div id="viewTextAnswer" style="margin-bottom: 20px; display: none;">
                            <label style="font-weight: 600; color: #2c3e50; margin-bottom: 10px; display: block;">Đáp án đúng:</label>
                            <div id="viewCorrectAnswer" style="background: #d4edda; padding: 15px; border-radius: 8px; border-left: 4px solid #28a745; font-size: 16px; line-height: 1.6; color: #155724;"></div>
                        </div>

                        <div id="viewFileSection" style="margin-bottom: 20px; display: none;">
                            <label style="font-weight: 600; color: #2c3e50; margin-bottom: 10px; display: block;">File đính kèm:</label>
                            <div id="viewFileContent" style="background: #f8f9fa; padding: 15px; border-radius: 8px;"></div>
                        </div>

                        <div id="viewExplanation" style="margin-bottom: 20px;">
                            <label style="font-weight: 600; color: #2c3e50; margin-bottom: 10px; display: block;">Giải thích:</label>
                            <div id="viewQuestionExplanation" style="background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #6c757d; font-size: 16px; line-height: 1.6; color: #2c3e50;"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e9ecef;">
                    <button type="button" class="btn-cancel" onclick="closeViewModal()" style="background: #6c757d; color: white; border: none; border-radius: 6px; padding: 10px 20px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.3s;">Đóng</button>
                </div>
            </div>
        </div>

        <script>
            // View Question Modal Functions
            function openViewQuestion(button) {
                const id = button.getAttribute("data-id");
                const content = button.getAttribute("data-content") || "";
                const type = button.getAttribute("data-type") || "";
                const explanation = button.getAttribute("data-explanation") || "";
                const fileUrl = button.getAttribute("data-file") || "";
                const topicName = button.getAttribute("data-topic") || "Không có";
                const status = button.getAttribute("data-status") || "";
                const optionsStr = button.getAttribute("data-options") || "";
                const answerText = button.getAttribute("data-answer") || "";

                // Set basic info
                document.getElementById("viewQuestionId").textContent = id;
                document.getElementById("viewQuestionType").textContent = type === 'mcq_single' ? 'Trắc nghiệm' : 'Tự luận';
                document.getElementById("viewQuestionTopic").textContent = topicName;
                document.getElementById("viewQuestionStatus").textContent = status === 'active' ? 'Hoạt động' : status;
                document.getElementById("viewQuestionContent").textContent = content;
                document.getElementById("viewQuestionExplanation").textContent = explanation || "Không có giải thích";

                // Handle MCQ options
                const mcqOptions = document.getElementById("viewMcqOptions");
                const textAnswer = document.getElementById("viewTextAnswer");
                const optionsContainer = document.getElementById("viewAnswerOptions");

                if (type === "mcq_single") {
                    mcqOptions.style.display = "block";
                    textAnswer.style.display = "none";

                    optionsContainer.innerHTML = "";
                    if (optionsStr.trim() !== "") {
                        const pairs = optionsStr.split(",");
                        pairs.forEach(function (p, index) {
                            const parts = p.split("|");
                            const optText = parts[0];
                            const isCorrect = parts[1] === "true";

                            const optionDiv = document.createElement("div");
                            optionDiv.style.cssText = "display: flex; align-items: center; gap: 10px; margin-bottom: 10px; padding: 10px; background: white; border-radius: 6px; border: 1px solid #e9ecef;";

                            const radio = document.createElement("input");
                            radio.type = "radio";
                            radio.checked = isCorrect;
                            radio.disabled = true;
                            radio.style.marginRight = "8px";

                            const label = document.createElement("span");
                            label.textContent = optText;
                            label.style.cssText = isCorrect ? "color: #28a745; font-weight: 600;" : "color: #6c757d;";

                            if (isCorrect) {
                                const checkIcon = document.createElement("i");
                                checkIcon.className = "fas fa-check";
                                checkIcon.style.cssText = "color: #28a745; margin-left: 8px;";
                                label.appendChild(checkIcon);
                            }

                            optionDiv.appendChild(radio);
                            optionDiv.appendChild(label);
                            optionsContainer.appendChild(optionDiv);
                        });
                    }
                } else if (type === "text") {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "block";
                    document.getElementById("viewCorrectAnswer").textContent = answerText;
                } else {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "none";
                }

                // Handle file display
                const fileSection = document.getElementById("viewFileSection");
                const fileContent = document.getElementById("viewFileContent");

                if (fileUrl && fileUrl.trim() !== "") {
                    fileSection.style.display = "block";
                    const ext = fileUrl.split('.').pop().toLowerCase();

                    let fileHtml = "";
                    if (["jpg", "jpeg", "png", "gif", "webp"].includes(ext)) {
                        fileHtml = '<img src="' + fileUrl + '" style="max-width:100%; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">';
                    } else if (["mp3", "wav", "m4a", "aac"].includes(ext)) {
                        fileHtml = '<audio controls style="width:100%;"><source src="' + fileUrl + '" type="audio/mpeg">Trình duyệt của bạn không hỗ trợ phát âm thanh.</audio>';
                    } else {
                        fileHtml = '<p style="color: #6c757d; font-style: italic;">Không thể hiển thị loại file này.</p>';
                    }
                    fileContent.innerHTML = fileHtml;
                } else {
                    fileSection.style.display = "none";
                }

                // Show modal
                const modal = document.getElementById("viewQuestionModal");
                modal.style.display = "flex";
                modal.classList.add("show");
            }

            function closeViewModal() {
                const modal = document.getElementById("viewQuestionModal");
                modal.style.display = "none";
                modal.classList.remove("show");
            }

            // Close modal when clicking outside
            window.addEventListener('click', function (event) {
                const modal = document.getElementById('viewQuestionModal');
                if (event.target === modal) {
                    closeViewModal();
                }
            });
        </script>
    </body>
</html>
