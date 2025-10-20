<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết khóa học - Manager Dashboard</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-detail.css?v=27' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>

    <body class="dashboard">
        <jsp:include page="includes-manager/sidebar-manager.jsp" />

        <main class="main-content">
            <div class="container course-container">

                <a href="coursemanager" class="back-btn"><i class="fa fa-arrow-left"></i> Quay lại danh sách</a>
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success">${sessionScope.message}</div>
                    <c:remove var="message" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger">${sessionScope.errorMessage}</div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="course-detail-header">
                    <div class="course-info">
                        <h1 class="course-title">${course.title}</h1>
                        <p class="course-desc">
                            <c:out value="${empty course.description ? 'Chưa có mô tả.' : course.description}" />
                        </p>
                        <p class="muted"><i class="fa fa-calendar"></i> Ngày tạo: 
                            <c:out value="${empty createdDate ? 'Không xác định' : createdDate}" />
                        </p>
                    </div>

                    <div class="course-meta">
                        <p><strong>Trạng thái:</strong>
                            <span class="status-badge ${course.status}">
                                <c:out value="${empty course.status ? 'unknown' : course.status}" />
                            </span>
                        </p>
                        <p><strong>Giá:</strong>
                            <c:choose>
                                <c:when test="${course.price != null}">
                                    <fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" />
                                </c:when>
                                <c:otherwise>Chưa đặt</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
                <div class="action-buttons">
                    <c:choose>
                        <c:when test="${course.status eq 'submitted'}">
                            <form method="post" action="<c:url value='/coursedetail'/>">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <button class="btn btn-success"><i class="fa fa-check"></i> Duyệt</button>
                            </form>
                            <button class="btn btn-danger" onclick="openRejectModal(${course.courseId})">
                                <i class="fa fa-times"></i> Từ chối
                            </button>
                        </c:when>

                        <c:when test="${course.status eq 'approved'}">
                            <button class="btn btn-danger" onclick="openRejectModal(${course.courseId})">
                                <i class="fa fa-times"></i> Từ chối lại
                            </button>
                            <button class="btn btn-primary" onclick="openScheduleModal(${course.courseId})">
                                <i class="fa fa-upload"></i> Đặt lịch đăng
                            </button>
                        </c:when>

                        <c:when test="${course.status eq 'rejected'}">
                            <form method="post" action="<c:url value='/coursedetail'/>">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <button class="btn btn-success"><i class="fa fa-check"></i> Duyệt lại</button>
                            </form>
                        </c:when>

                        <c:when test="${course.status eq 'publish'}">
                            <form method="post" action="<c:url value='/coursedetail'/>">
                                <input type="hidden" name="action" value="unpublish">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <button class="btn btn-warning"><i class="fa fa-download"></i> Gỡ đăng</button>
                            </form>
                        </c:when>

                        <c:when test="${course.status eq 'unpublish'}">
                            <button class="btn btn-primary" onclick="openScheduleModal(${course.courseId})">
                                <i class="fa fa-upload"></i> Đăng lại
                            </button>
                        </c:when>
                    </c:choose>
                    <form method="post" action="<c:url value='/coursedetail'/>" class="inline-form">
                        <input type="hidden" name="action" value="updatePrice">
                        <input type="hidden" name="courseId" value="${course.courseId}">
                        <input type="number" name="price" value="${course.price != null ? course.price : 0}" min="0" step="1000" class="price-inline-input">
                        <button class="price-inline-btn" title="Cập nhật giá"><i class="fa fa-save"></i></button>
                    </form>
                </div>
                        
                <section class="course-stats">
                    <h3>Tổng quan khóa học</h3>
                    <ul>
                        <li>Modules: ${stats.moduleCount != null ? stats.moduleCount : 0}</li>
                        <li>Bài học: ${stats.lessonCount != null ? stats.lessonCount : 0}</li>
                        <li>Tổng nội dung: 
                            ${(stats.lessonCount != null ? stats.lessonCount : 0) 
                              + (stats.quizCount != null ? stats.quizCount : 0) 
                              + (stats.assignmentCount != null ? stats.assignmentCount : 0) 
                              + (stats.discussionCount != null ? stats.discussionCount : 0)}
                        </li>
                        <li>Quiz: ${stats.quizCount != null ? stats.quizCount : 0}</li>
                        <li>Assignment: ${stats.assignmentCount != null ? stats.assignmentCount : 0}</li>
                        <li>Discussion: ${stats.discussionCount != null ? stats.discussionCount : 0}</li>
                    </ul>
                </section>
                    
                <section class="course-instructor">
                    <h3>Giảng viên phụ trách</h3>
                    <c:choose>
                        <c:when test="${not empty instructor and not empty instructor.fullName}">
                            <div class="instructor-card">
                                <p><strong>Họ tên:</strong> ${instructor.fullName}</p>
                                <p><strong>Email:</strong> ${instructor.email}</p>
                                <p><strong>Chuyên môn:</strong> 
                                    <c:out value="${empty instructor.expertise ? 'Không có thông tin' : instructor.expertise}" />
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="empty">Chưa có thông tin giảng viên cho khóa học này.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
                    
                <section class="course-outline">
                    <h3>Chương trình học</h3>
                    <c:choose>
                        <c:when test="${empty modules}">
                            <div class="empty">Khóa học này chưa có module nào.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="m" items="${modules}">
                                <div class="module">
                                    <div class="module-header" onclick="toggleModule(this)">
                                        <span>Chương ${m['orderIndex']}: ${m['title']}</span>
                                        <i class="fa fa-chevron-down"></i>
                                    </div>

                                    <div class="module-lessons">
                                        <c:set var="hasItem" value="false" />
                                        <c:forEach var="i" items="${items}">
                                            <c:if test="${i['moduleId'] == m['moduleId']}">
                                                <c:set var="hasItem" value="true" />

                                                <div class="lesson">
                                                    <div class="lesson-title">
                                                        <c:choose>
                                                            <c:when test="${i['itemType'] == 'lesson'}">
                                                                <i class="fa fa-play-circle"></i> ${i['lessonTitle']}
                                                            </c:when>
                                                            <c:when test="${i['itemType'] == 'quiz'}">
                                                                <i class="fa fa-question-circle"></i> ${i['quizTitle']}
                                                            </c:when>
                                                            <c:when test="${i['itemType'] == 'assignment'}">
                                                                <i class="fa fa-tasks"></i> ${i['assignmentTitle']}
                                                            </c:when>
                                                            <c:when test="${i['itemType'] == 'discussion'}">
                                                                <i class="fa fa-comments"></i> ${i['discussionTitle']}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fa fa-file"></i> ${i['itemType']}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <c:choose>

                                                        <c:when test="${i['contentType'] == 'video'}">
                                                            <div class="video-container">
                                                                <iframe src="https://www.youtube.com/embed/${i['videoUrl']}" allowfullscreen></iframe>
                                                                <p class="video-duration muted">
                                                                    ⏱ Thời lượng: ${i['durationSec'] != null ? i['durationSec'] : 0} giây
                                                                </p>
                                                            </div>
                                                        </c:when>

                                                        <c:when test="${i['contentType'] == 'reading'}">
                                                            <div class="reading-box">
                                                                <h4><i class="fa fa-book-open"></i> Reading Lesson</h4>
                                                                <div class="reading-content">
                                                                    <c:out value="${fn:replace(i['textContent'], '
                                                                                    ', '<br/>')}" escapeXml="false" />
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        
                                                        <c:when test="${i['itemType'] == 'quiz'}">
                                                            <div class="quiz-box">
                                                                <h4><i class="fa fa-question-circle"></i> Quiz: 
                                                                    <c:out value="${empty i['quizTitle'] ? 'Chưa đặt tiêu đề' : i['quizTitle']}" />
                                                                </h4>
                                                                <p><strong>Số câu hỏi:</strong> ${empty i['pickCount'] ? 0 : i['pickCount']}</p>
                                                                <p><strong>Điểm đạt:</strong> ${empty i['passingScorePct'] ? 0 : i['passingScorePct']}%</p>
                                                                <p><strong>Lượt làm lại:</strong> ${empty i['attemptsAllowed'] ? 0 : i['attemptsAllowed']}</p>

                                                                <c:if test="${not empty i['quizQuestions']}">
                                                                    <div class="quiz-questions">
                                                                        <h5>Câu hỏi trong Quiz</h5>
                                                                        <c:forEach var="qq" items="${i['quizQuestions']}">
                                                                            <div class="question-item">
                                                                                <p><strong>Q${qq['questionId']}:</strong> 
                                                                                    <c:out value="${empty qq['content'] ? 'Không có nội dung' : qq['content']}" />
                                                                                </p>

                                                                                <c:if test="${not empty qq['options']}">
                                                                                    <ul>
                                                                                        <c:forEach var="opt" items="${qq['options']}">
                                                                                            <li class="${opt['isCorrect'] ? 'correct' : 'wrong'}">
                                                                                                <c:out value="${empty opt['text'] ? '(Không có nội dung)' : opt['text']}" />
                                                                                            </li>
                                                                                        </c:forEach>
                                                                                    </ul>
                                                                                </c:if>

                                                                                <c:if test="${not empty qq['explanation']}">
                                                                                    <p class="explanation">
                                                                                        <strong>Giải thích:</strong> ${qq['explanation']}
                                                                                    </p>
                                                                                </c:if>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:if>

                                                                <c:if test="${empty i['quizQuestions']}">
                                                                    <p class="empty">Chưa có câu hỏi nào trong quiz này.</p>
                                                                </c:if>
                                                            </div>
                                                        </c:when>

                                                        <c:when test="${i['itemType'] == 'assignment'}">
                                                            <div class="assignment-box">
                                                                <h4><i class="fa fa-tasks" ></i> 
                                                                    <c:out value="${empty i['assignmentTitle'] ? 'Không có tiêu đề' : i['assignmentTitle']}" />
                                                                </h4>
                                                                <p><strong>Hình thức nộp:</strong> ${empty i['submissionType'] ? 'Chưa có' : i['submissionType']}</p>
                                                                <p><strong>Điểm tối đa:</strong> ${empty i['maxScore'] ? 0 : i['maxScore']}</p>
                                                                <p><strong>Điểm đạt:</strong> ${empty i['passingScorePct'] ? 0 : i['passingScorePct']}%</p>

                                                                <c:choose>
                                                                    <c:when test="${not empty i['assignmentQuestions']}">
                                                                        <div class="assignment-questions">
                                                                            <h5>Nội dung yêu cầu</h5>
                                                                            <c:forEach var="aq" items="${i['assignmentQuestions']}">
                                                                                <div class="question-item">
                                                                                    <p><strong>• 
                                                                                            <c:out value="${empty aq['questionTitle'] ? 'Không có tiêu đề' : aq['questionTitle']}" />
                                                                                        </strong></p>
                                                                                    <p><c:out value="${empty aq['description'] ? 'Không có mô tả' : aq['description']}" /></p>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="empty">Chưa có nội dung bài tập nào.</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:when>

                                                        <c:when test="${i['itemType'] == 'discussion'}">
                                                            <div class="discussion-box">
                                                                <h4><i class="fa fa-comments"></i> Discussion:
                                                                    Thảo luận: <c:out value="${empty i['discussionTitle'] ? 'Không có tiêu đề' : i['discussionTitle']}" />
                                                                </h4>
                                                                <p class="muted">Tạo lúc: 
                                                                    <c:out value="${empty i['createdAt'] ? 'Không xác định' : i['createdAt']}" />
                                                                </p>

                                                                <c:choose>
                                                                    <c:when test="${not empty i['discussionPosts']}">
                                                                        <div class="discussion-posts">
                                                                            <h5>Bình luận</h5>
                                                                            <c:forEach var="p" items="${i['discussionPosts']}">
                                                                                <div class="discussion-post">
                                                                                    <p><strong>${p['author'] != null ? p['author'] : 'Ẩn danh'}:</strong> 
                                                                                        <c:out value="${empty p['content'] ? '(Không có nội dung)' : p['content']}" />
                                                                                    </p>
                                                                                    <p class="muted">${empty p['createdAt'] ? '' : p['createdAt']}</p>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="empty">Chưa có bình luận nào trong chủ đề này.</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${!hasItem}">
                                            <p class="empty">Chưa có nội dung trong chương này.</p>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </section>
                <section class="course-questions">
                    <h3>Ngân hàng câu hỏi</h3>

                    <c:choose>
                        <c:when test="${empty questions}">
                            <p class="empty">Chưa có câu hỏi nào trong khóa học này.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="q" items="${questions}">
                                <div class="question-card">
                                    <p><strong>Q${q['questionId']}:</strong> ${q['content']}</p>

                                    <c:if test="${not empty q['mediaUrl']}">
                                        <img src="${q['mediaUrl']}" 
                                             alt="Media" 
                                             style="max-width:300px; border-radius:8px; margin-top:8px;">
                                    </c:if>

                                    <p class="meta muted">
                                        <i>Loại:</i> ${q['type']} — 
                                        <c:out value="${q['moduleTitle']}" />
                                        <c:if test="${not empty q['lessonTitle']}">
                                            / <c:out value="${q['lessonTitle']}" />
                                        </c:if>
                                    </p>

                                    <c:if test="${not empty q['explanation']}">
                                        <div class="explanation-box">
                                            <strong>Giải thích:</strong>
                                            <c:out value="${q['explanation']}" />
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </section> 
            </div>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fa fa-check-circle me-2"></i>${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fa fa-triangle-exclamation me-2"></i>${errorMessage}
                </div>
            </c:if>
        </main>
        <div id="rejectModal" class="modal">
            <div class="modal-content">
                <h3>Nhập lý do từ chối</h3>
                <form method="post" action="<c:url value='/coursedetail'/>">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="courseId" id="rejectCourseId">
                    <textarea name="rejectReason" required placeholder="Nhập lý do..."></textarea>
                    <div class="modal-buttons">
                        <button type="submit" class="btn btn-danger">Gửi</button>
                        <button type="button" class="btn btn-secondary" onclick="closeRejectModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
        <div id="scheduleModal" class="modal">
            <div class="modal-content">
                <h3>Chọn ngày xuất bản</h3>
                <form method="post" action="<c:url value='/coursedetail'/>">
                    <input type="hidden" name="action" value="publish">
                    <input type="hidden" name="courseId" id="scheduleCourseId">
                    <div class="form-group">
                        <label for="publishDate">Ngày đăng:</label>
                        <input type="date" name="publishDate" id="publishDate" required>
                    </div>
                    <div class="modal-buttons">
                        <button type="submit" class="btn btn-primary">Lưu lịch</button>
                        <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleModule(header) {
                const content = header.nextElementSibling;
                const icon = header.querySelector("i");
                const isOpen = content.style.display === "block";
                document.querySelectorAll('.module-lessons').forEach(el => el.style.display = "none");
                document.querySelectorAll('.module-header i').forEach(i => i.classList.replace("fa-chevron-up", "fa-chevron-down"));
                if (!isOpen) {
                    content.style.display = "block";
                    icon.classList.replace("fa-chevron-down", "fa-chevron-up");
                }
            }

            function openRejectModal(id) {
                document.getElementById('rejectModal').style.display = 'flex';
                document.getElementById('rejectCourseId').value = id;
            }

            function closeRejectModal() {
                document.getElementById('rejectModal').style.display = 'none';
            }

            function openScheduleModal(id) {
                document.getElementById('scheduleModal').style.display = 'flex';
                document.getElementById('scheduleCourseId').value = id;
            }

            function closeScheduleModal() {
                document.getElementById('scheduleModal').style.display = 'none';
            }
        </script>
    </body>
</html>
