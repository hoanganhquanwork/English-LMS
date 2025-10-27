<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chấm Assignment - ${requestScope.assignment.title}</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/teacher-common.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .grading-container {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 30px;
            }

            .grading-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
            }

            .grading-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .grading-subtitle {
                font-size: 16px;
                opacity: 0.9;
            }

            .assignment-info {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .info-item {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .info-label {
                font-size: 14px;
                font-weight: 600;
                color: #495057;
            }

            .info-value {
                font-size: 16px;
                color: #2c3e50;
            }

            .submissions-section {
                padding: 30px;
            }

            .section-title {
                font-size: 20px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .submission-card {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }

            .submission-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .submission-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 15px;
            }

            .student-info {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .student-name {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
            }

            .student-email {
                font-size: 14px;
                color: #6c757d;
            }

            .submission-meta {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 4px;
                font-size: 14px;
                color: #6c757d;
            }

            .submission-content {
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 6px;
                padding: 15px;
                margin-bottom: 15px;
            }

            .content-label {
                font-size: 14px;
                font-weight: 600;
                color: #495057;
                margin-bottom: 8px;
            }

            .content-text {
                color: #2c3e50;
                line-height: 1.6;
                white-space: pre-wrap;
            }

            .content-meta {
                margin-top: 8px;
                font-size: 13px;
                color: #6c757d;
            }

            /* Compact inline header for rubric + submission type */
            .criteria-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
                margin-bottom: 8px;
            }



            .file-attachments {
                margin-top: 15px;
            }

            .file-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 8px 12px;
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 6px;
                margin-bottom: 8px;
            }

            .file-icon {
                color: #007bff;
                font-size: 16px;
            }

            .file-name {
                flex: 1;
                font-size: 14px;
                color: #2c3e50;
            }

            .file-download {
                color: #007bff;
                text-decoration: none;
                font-size: 14px;
            }

            .file-download:hover {
                text-decoration: underline;
            }

            .grading-form {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 8px;
                padding: 20px;
                margin-top: 15px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr; /* Stack score above feedback */
                gap: 16px;
                margin-bottom: 15px;
                justify-items: start; /* place fields to the left */
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
                max-width: 600px; /* keep fields left and not too wide */
                width: 100%;
            }

            .form-group label {
                font-size: 14px;
                font-weight: 600;
                color: #495057;
            }

            .form-group input,
            .form-group textarea {
                padding: 10px 12px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .form-group input:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 180px; /* Larger feedback area */
            }

            .grade-actions {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
                margin-top: 20px;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
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
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
            }

            .graded-badge {
                background: #d4edda;
                color: #155724;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #007bff;
                text-decoration: none;
                font-size: 14px;
                margin-bottom: 20px;
                transition: color 0.3s;
            }

            .back-link:hover {
                color: #0056b3;
                text-decoration: underline;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 48px;
                color: #dee2e6;
                margin-bottom: 16px;
            }

            .empty-state h3 {
                font-size: 18px;
                margin-bottom: 8px;
                color: #495057;
            }

            .empty-state p {
                font-size: 14px;
                margin: 0;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }

                .submission-header {
                    flex-direction: column;
                    gap: 10px;
                }

                .submission-meta {
                    align-items: flex-start;
                }

                .grade-actions {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 20px;">
            <a href="gradeListServlet" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Quay lại danh sách
            </a>

            <div class="grading-container">
                <div class="grading-header">
                    <h1 class="grading-title">
                        <i class="fas fa-graduation-cap"></i>
                        Chấm Assignment
                    </h1>
                    <p class="grading-subtitle">${requestScope.assignment.title}</p>
                </div>

                <div class="assignment-info">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Khóa học</div>
                            <div class="info-value">${assignment.assignmentId.module.course.title}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Module</div>
                            <div class="info-value">${assignment.assignmentId.module.title}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Điểm tối đa</div>
                            <div class="info-value">${requestScope.assignment.maxScore}</div>
                        </div>

                    </div>
                </div>

                <!-- Đề bài: hiển thị thông tin assignment (tham khảo create-assignment.jsp) -->
                <div class="submissions-section" style="padding-top: 0;">
                    <h2 class="section-title">
                        <i class="fas fa-list"></i>
                        Đề bài
                    </h2>



                    <c:if test="${not empty requestScope.assignment.content}">
                        <div class="submission-content">
                            <div class="content-label">Nội dung bài tập</div>
                            <div class="content-text">${requestScope.assignment.content}</div>
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.assignment.submissionType}">
                        <div class="submission-content" >
                            <div class="criteria-header">
<!--                                <div class="content-label">Tiêu chí chấm điểm</div>-->
                                <c:if test="${not empty rubrics}">
                                    <div class="submission-content" style="width: 280%;">
                                        <div class="content-label">Tiêu chí chấm điểm</div>

                                        <table style="width:100%; border-collapse:collapse; margin-top:10px;">
                                            <thead>
                                                <tr style="background:#f8f9fa; border-bottom:2px solid #dee2e6;">
                                                    <th style="text-align:center; padding:8px;">#</th>
                                                    <th style="text-align:left; padding:8px;">Hướng dẫn</th>
                                                    <th style="text-align:center; padding:8px;">Trọng số</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${rubrics}">
                                                    <tr style="border-bottom:1px solid #dee2e6;">
                                                        <td style="text-align:center; padding:8px;">${r.criterionNo}</td>
                                                        <td style="padding:8px;">${r.guidance}</td>
                                                        <td style="text-align:center; padding:8px;">${r.weight}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>

                            <c:if test="${not empty requestScope.assignment.submissionType}">
                                <div class="content-meta">
                                    Loại nộp bài: 
                                    <c:choose>
                                        <c:when test="${requestScope.assignment.submissionType eq 'file'}">File đính kèm</c:when>
                                        <c:when test="${requestScope.assignment.submissionType eq 'text'}">Văn bản trực tuyến</c:when>
                                        <c:when test="${requestScope.assignment.submissionType eq 'both'}">Cả hai</c:when>
                                        <c:otherwise>${requestScope.assignment.submissionType}</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.assignment.attachmentUrl}">
                        <div class="file-attachments">
                            <div class="content-label">Tài liệu đính kèm</div>



                            <!-- Nếu là Word -->
                            <c:if test="${fn:endsWith(requestScope.assignment.attachmentUrl, '.doc') || 
                                          fn:endsWith(requestScope.assignment.attachmentUrl, '.docx')}">
<!--                                  <iframe src="https://view.officeapps.live.com/op/embed.aspx?src=${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}/${requestScope.assignment.attachmentUrl}"
                                          width="100%" height="600px" frameborder="0"></iframe>-->
                                  <div id="docx-preview"
                                       style="background:#fff;border:1px solid #ccc;border-radius:8px;padding:20px;min-height:400px;">
                                      <p><i>Đang tải nội dung file Word...</i></p>
                                  </div>
                                  <script src="https://unpkg.com/mammoth@1.5.1/mammoth.browser.min.js"></script>
                                  <script>
                                      // Đường dẫn đến file Word
                                      const docxUrl = "${pageContext.request.contextPath}/${requestScope.assignment.attachmentUrl}";
                                          fetch(docxUrl)
                                                  .then(response => response.arrayBuffer())
                                                  .then(arrayBuffer => mammoth.convertToHtml({arrayBuffer}))
                                                  .then(result => {
                                                      document.getElementById("docx-preview").innerHTML = result.value;
                                                  })
                                                  .catch(err => {
                                                      console.error("Lỗi đọc file Word:", err);
                                                      document.getElementById("docx-preview").innerHTML =
                                                              "<p style='color:red;'>Không thể hiển thị file Word này. Vui lòng tải xuống để xem.</p>" +
                                                              `<a href='${docxUrl}' class='file-download' target='_blank'><i class='fas fa-download'></i> Tải xuống</a>`;
                                                  });
                                  </script>
                            </c:if>

                            <!-- Link tải xuống -->
                            <div style="margin-top:10px;">
                                <a href="${requestScope.assignment.attachmentUrl}" class="file-download" target="_blank">
                                    <i class="fas fa-download"></i> Tải xuống tệp
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="submissions-section">
                    <h2 class="section-title">
                        <i class="fas fa-file-alt"></i>
                        Bài nộp của học viên
                    </h2>
                </div>

                <div class="submission-card">
                    <div class="submission-header">
                        <!--                                        <div class="student-info">
                                                                    <div class="student-name">${submission.studentName}</div>
                                                                    <div class="student-email">${submission.studentEmail}</div>
                                                                </div>-->
                        <div class="submission-meta">
                            <div>Nộp lúc: ${work.submittedAt}</div>
                            <c:if test="${work.status eq 'passed'}">
                                <span class="graded-badge">Đã chấm</span>
                            </c:if>
                        </div>
                    </div>

                    <c:if test="${not empty work.textAnswer}">
                        <div class="submission-content">
                            <div class="content-label">Nội dung bài làm:</div>
                            <div class="content-text">${work.textAnswer}</div>
                        </div>
                    </c:if>

                    <c:if test="${not empty work.fileUrl}">
                        <div class="file-attachments">
                            <div class="content-label">Tệp đính kèm:</div>


                            <!-- Nếu là Word -->
                            <c:if test="${fn:endsWith(work.fileUrl, '.doc') || fn:endsWith(work.fileUrl, '.docx')}">
<!--                                <iframe src="https://view.officeapps.live.com/op/embed.aspx?src=${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}/${work.fileUrl}"
                                        width="100%" height="600px" frameborder="0"></iframe>-->
                                 <script src="https://unpkg.com/mammoth@1.5.1/mammoth.browser.min.js"></script>
                                  <script>
                                      // Đường dẫn đến file Word
                                      const docxUrl = "${pageContext.request.contextPath}/${work.fileUrl}";
                                          fetch(docxUrl)
                                                  .then(response => response.arrayBuffer())
                                                  .then(arrayBuffer => mammoth.convertToHtml({arrayBuffer}))
                                                  .then(result => {
                                                      document.getElementById("docx-preview").innerHTML = result.value;
                                                  })
                                                  .catch(err => {
                                                      console.error("Lỗi đọc file Word:", err);
                                                      document.getElementById("docx-preview").innerHTML =
                                                              "<p style='color:red;'>Không thể hiển thị file Word này. Vui lòng tải xuống để xem.</p>" +
                                                              `<a href='${docxUrl}' class='file-download' target='_blank'><i class='fas fa-download'></i> Tải xuống</a>`;
                                                  });
                                  </script>
                                </c:if>

                            <!-- Link tải xuống -->
                            <div style="margin-top:10px;">
                                <a href="${work.fileUrl}" class="file-download" target="_blank">
                                    <i class="fas fa-download"></i> Tải xuống
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <!-- Form chấm điểm -->
                    <form action="gradeAssignment" method="post" class="grading-form">
                        <input type="hidden" name="assignmentId" value="${work.assignment.assignmentId.moduleItemId}">
                        <input type="hidden" name="studentId" value="${work.student.userId}">

                        <div class="form-row">
                            <div class="form-group">
                                <label>Điểm số</label>
                                <input type="number" name="score" value="${work.score != null ? work.score : ''}"
                                       min="0" max="${assignment.maxScore}" step="0.1" placeholder="0 - ${assignment.maxScore}">
                            </div>
                            <div class="form-group">
                                <label>Nhận xét</label>
                                <textarea name="feedback" placeholder="Nhập nhận xét...">${work.feedbackText}</textarea>
                            </div>
                        </div>
                        <c:if test="${work.status eq 'submitted'}">
                            <div class="grade-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check"></i> Lưu chấm điểm
                                </button>
                            </div>
                        </c:if>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <script>
        // Form validation
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function (e) {
                const scoreInput = this.querySelector('input[name="score"]');
                const score = parseFloat(scoreInput.value);
                const maxScoreAllowed = parseFloat('${requestScope.assignment.maxScore}');

                if (scoreInput.value.trim() === '') {
                    e.preventDefault();
                    alert('Vui lòng nhập điểm số');
                    scoreInput.focus();
                    return false;
                }

                if (score < 0 || score > maxScoreAllowed) {
                    e.preventDefault();
                    alert('Điểm số phải từ 0 đến ' + maxScoreAllowed);
                    scoreInput.focus();
                    return false;
                }
            });
        });

        // Auto-save functionality (optional)
        let autoSaveTimeout;
        document.querySelectorAll('input[name="score"], textarea[name="feedback"]').forEach(input => {
            input.addEventListener('input', function () {
                clearTimeout(autoSaveTimeout);
                autoSaveTimeout = setTimeout(() => {
                    // Auto-save logic could be implemented here
                    console.log('Auto-saving...');
                }, 2000);
            });
        });
    </script>
</body>
</html>

