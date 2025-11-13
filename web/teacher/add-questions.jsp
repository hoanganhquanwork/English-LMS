
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

            .pagination-container {
                display: flex;
                justify-content: center;
                margin: 20px 0;
            }

            .pagination-form {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .pagination-btn {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: #fff;
                color: #333;
                text-decoration: none;
                cursor: pointer;
                border-radius: 4px;
                font-size: 14px;
            }

            .pagination-btn:hover {
                background: #f5f5f5;
            }

            .pagination-btn.active {
                background: #007bff;
                color: #fff;
                border-color: #007bff;
            }

            .pagination-info {
                margin-left: 10px;
                color: #666;
                font-size: 14px;
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
                            <div class="form-section">
                                <div class="form-group">
                                    <label for="questionBank">Module cần thêm</label>
                                    <select id="questionBank" name="moduleId" class="form-select" required>
                                        <option value="">-- Chọn module --</option>
                                        <c:forEach var="m" items="${moduleList}">
                                            <option value="${m.moduleId}">${m.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                        </form>

                        <!-- Filter Section -->
                        <div class="filter-section" style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-top: 30px; margin-bottom: 20px;">
                            <form method="GET" action="addQuestion">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <div class="filter-row" style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                    <div class="filter-group" style="display: flex; flex-direction: column; gap: 5px;">
                                        <label class="filter-label" style="font-weight: 500; color: #2c3e50; font-size: 14px;">Lọc theo chủ đề:</label>
                                        <select name="topicFilter" class="filter-select" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; min-width: 200px;">
                                            <option value="">Tất cả chủ đề</option>
                                            <c:forEach var="topic" items="${topics}">
                                                <option value="${topic.topicId}" ${selectedTopic == topic.topicId ? 'selected' : ''}>
                                                    ${topic.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <button type="submit" class="filter-button" style="padding: 8px 16px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; transition: background 0.3s;">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Questions Table -->
                        <div class="table-container" style="margin-top: 30px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                <h3 style="margin: 0; color: #2c3e50;">Danh sách câu hỏi</h3>
                                <div style="display: flex; gap: 15px; align-items: center;">
                                    <button type="button" id="addToModuleBtn" onclick="addSelectedToModule()" 
                                            style="padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.3s; display: flex; align-items: center; gap: 8px;"
                                            disabled>
                                        <i class="fas fa-plus"></i> Thêm vào module
                                    </button>
                                </div>
                            </div>
                            <table class="questions-table" style="width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <thead>
                                    <tr style="background: #f8f9fa;">
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">
                                            <input type="checkbox" id="selectAllQuestions" onchange="toggleAllQuestions()" style="width: 18px; height: 18px; cursor: pointer; accent-color: #007bff;">
                                        </th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">ID</th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Nội dung câu hỏi</th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Chủ đề</th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Loại</th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Trạng thái</th>
                                        <th style="padding: 16px; text-align: left; font-weight: 600; color: #2c3e50; border-bottom: 2px solid #e9ecef;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty approvedQuestionMap}">
                                            <c:forEach var="entry" items="${approvedQuestionMap}">
                                                <tr style="border-bottom: 1px solid #e9ecef;">
                                                    <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                        <input type="checkbox" class="question-checkbox" value="${entry.key.questionId}" onchange="updateAddButton()" style="width: 18px; height: 18px; cursor: pointer; accent-color: #007bff;">
                                                    </td>
                                                    <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">${entry.key.questionId}</td>
                                                    <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                        <div style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; line-height: 1.4;" title="${entry.key.content}">
                                                            ${fn:substring(entry.key.content, 0, 50)}...
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
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                        <span style="padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 500; background: #d4edda; color: #155724;">Đã duyệt</span>
                                                    </td>
                                                    <td style="padding: 12px 16px; vertical-align: middle; font-size: 14px;">
                                                        <a href="#" 
                                                           style="padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: #3498db; color: white;"
                                                           data-id="${entry.key.questionId}"
                                                           data-content="${fn:escapeXml(entry.key.content)}"
                                                           data-type="${entry.key.type}"
                                                           data-explanation="${fn:escapeXml(entry.key.explanation)}"
                                                           data-file="${entry.key.mediaUrl}"
                                                           data-topic="<c:forEach var='topic' items='${topics}'><c:if test='${topic.topicId == entry.key.topicId}'>${topic.name}</c:if></c:forEach>"
                                                           data-status="${entry.key.status}"
                                                           <c:if test="${entry.key.type == 'mcq_single'}">
                                                               data-options="<c:forEach var='opt' items='${entry.value}' varStatus='loop'>${fn:escapeXml(opt.content)}|${opt.correct ? 'true' : 'false'}${!loop.last ? ',' : ''}</c:forEach>"
                                                           </c:if>
                                                           <c:if test="${entry.key.type == 'text'}">
                                                               data-answer="${entry.value}"
                                                           </c:if>
                                                           onclick="openViewQuestion(this)">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" style="text-align: center; padding: 40px; color: #6c757d; font-style: italic;">
                                                    <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 16px; color: #dee2e6;"></i>
                                                    <p>Chưa có câu hỏi nào được tạo</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                          <c:if test="${requestScope.totalPages > 1}">
                        <div class="pagination-container">
                            <form action="${pageContext.request.contextPath}/addQuestion" method="get" class="pagination-form">
                              
                                <input type="hidden" name="courseId" value="${param.courseId}">
                                <input type="hidden" name="topicFilter" value="${param.topicFilter}">
                                

                                <c:if test="${requestScope.page > 1}">
                                    <button type="submit" name="page" value="${requestScope.page-1}" class="pagination-btn pagination-nav">«</button>
                                </c:if>

                                <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                                    <button type="submit" name="page" value="${i}"
                                            class="pagination-btn ${i==requestScope.page ? 'active' : ''}">${i}</button>
                                </c:forEach>

                                <c:if test="${requestScope.page < requestScope.totalPages}">
                                    <button type="submit" name="page" value="${requestScope.page+1}" class="pagination-btn pagination-nav">»</button>
                                </c:if>

                                <span class="pagination-info">Trang ${requestScope.page} / ${requestScope.totalPages}</span>
                            </form>
                        </div>
                    </c:if>

                    </div>
                </main>
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
                                <label style="font-weight: 600; color: #2c3e50; width: 120px;">Chủ đề:</label>
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
        <form id="addToModuleForm" action="addQuestionsToModule" method="POST" style="display:none;">
            <input type="hidden" name="courseId" value="${course.courseId}">
            <input type="hidden" name="moduleId" id="selectedModuleId">
            <input type="hidden" name="questionIds" id="selectedQuestionIds">
        </form>

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
                document.getElementById("viewQuestionStatus").textContent = status === 'approved' ? 'Đã duyệt' : status;
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

            // Checkbox functionality
            function toggleAllQuestions() {
                const selectAll = document.getElementById('selectAllQuestions');
                const checkboxes = document.querySelectorAll('.question-checkbox');

                checkboxes.forEach(checkbox => {
                    checkbox.checked = selectAll.checked;
                });

                updateAddButton();
            }

            function updateAddButton() {
                const checkboxes = document.querySelectorAll('.question-checkbox:checked');
                const addButton = document.getElementById('addToModuleBtn');
                const selectAll = document.getElementById('selectAllQuestions');

                if (checkboxes.length > 0) {
                    addButton.disabled = false;
                    addButton.style.background = '#28a745';
                    addButton.style.cursor = 'pointer';
                } else {
                    addButton.disabled = true;
                    addButton.style.background = '#6c757d';
                    addButton.style.cursor = 'not-allowed';
                }

                // Update select all checkbox state
                const totalCheckboxes = document.querySelectorAll('.question-checkbox');
                if (checkboxes.length === 0) {
                    selectAll.checked = false;
                    selectAll.indeterminate = false;
                } else if (checkboxes.length === totalCheckboxes.length) {
                    selectAll.checked = true;
                    selectAll.indeterminate = false;
                } else {
                    selectAll.checked = false;
                    selectAll.indeterminate = true;
                }
            }

            function addSelectedToModule() {
                const selectedQuestions = getSelectedQuestions();

                if (selectedQuestions.length === 0) {
                    alert('Vui lòng chọn ít nhất một câu hỏi!');
                    return;
                }

                const moduleId = document.getElementById('questionBank').value;
                if (!moduleId) {
                    alert('Vui lòng chọn module trước khi thêm câu hỏi!');
                    return;
                }

                if (confirm(`Bạn có chắc chắn muốn thêm ${selectedQuestions.length} câu hỏi vào module này?`)) {
                    // Gán giá trị vào form có sẵn
                    document.getElementById('selectedModuleId').value = moduleId;
                    document.getElementById('selectedQuestionIds').value = selectedQuestions.join(',');

                    // Gửi form
                    document.getElementById('addToModuleForm').submit();
                }
            }

            function getSelectedQuestions() {
                const checkboxes = document.querySelectorAll('.question-checkbox:checked');
                return Array.from(checkboxes).map(cb => cb.value);
            }

        </script>
    </body>
</html>
