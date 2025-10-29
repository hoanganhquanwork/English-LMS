<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết khóa học - Manager Dashboard</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-detail.css?v=3433' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>
    <body class="dashboard">
        <jsp:include page="includes-manager/sidebar-manager.jsp" />

        <main class="main-content">
            <div class="container course-container">
                <div style="display: flex; gap: 1rem; margin-bottom: 3rem;">
                    <a href="coursemanager" class="back-btn">
                        <i class="fa fa-arrow-left"></i> Quay lại danh sách quản lí
                    </a>
                    <a href="coursepublish" class="back-btn">
                        <i class="fa fa-arrow-left"></i> Quay lại danh sách đăng khóa học
                    </a>
                </div>
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success">${sessionScope.message}</div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger">${sessionScope.errorMessage}</div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <div class="course-detail-header">
                    <div class="course-info">
                        <h1 class="course-title">${course.title}</h1>
                        <p class="course-desc">
                            <c:out value="${empty course.description ? 'Chưa có mô tả.' : course.description}" />
                        </p>
                        <p class="muted">
                            <i class="fa fa-calendar"></i> Ngày tạo:
                            <c:out value="${empty createdDate ? 'Không xác định' : createdDate}" />
                        </p>
                    </div>

                    <div class="course-meta">
                        <p>
                            <strong>Trạng thái:</strong>
                            <span class="status-badge ${course.status}">
                                <c:out value="${empty course.status ? 'unknown' : course.status}" />
                            </span>
                        </p>
                        <p>
                            <strong>Giá:</strong>
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
                            <form method="post" action="coursedetail">
                                <input type="hidden" name="action" value="approve" />
                                <input type="hidden" name="courseId" value="${course.courseId}" />
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
                            <form method="post" action="coursedetail">
                                <input type="hidden" name="action" value="approve" />
                                <input type="hidden" name="courseId" value="${course.courseId}" />
                                <button class="btn btn-success"><i class="fa fa-check"></i> Duyệt lại</button>
                            </form>
                        </c:when>

                        <c:when test="${course.status eq 'publish'}">
                            <form method="post" action="coursedetail">
                                <input type="hidden" name="action" value="unpublish" />
                                <input type="hidden" name="courseId" value="${course.courseId}" />
                                <button class="btn btn-warning"><i class="fa fa-download"></i> Gỡ đăng</button>
                            </form>
                        </c:when>

                        <c:when test="${course.status eq 'unpublish'}">
                            <button class="btn btn-primary" onclick="openScheduleModal(${course.courseId})">
                                <i class="fa fa-upload"></i> Đăng lại
                            </button>
                        </c:when>
                    </c:choose>

                    <form method="post" action="coursedetail" class="inline-form">
                        <input type="hidden" name="action" value="updatePrice" />
                        <input type="hidden" name="courseId" value="${course.courseId}" />
                        <input type="number" name="price" 
                               value="${course.price != null ? course.price : 0}" 
                               min="0" step="1000" class="price-inline-input" required/>
                        <button class="price-inline-btn" title="Cập nhật giá">
                            <i class="fa fa-save"></i>
                        </button>
                    </form>
                </div>

                <div class="course-overview">
                    <section class="course-stats">
                        <h3>Tổng quan khóa học</h3>
                        <ul>
                            <li>Modules: ${stats.moduleCount != null ? stats.moduleCount : 0}</li>
                            <li>Bài học: ${stats.lessonCount != null ? stats.lessonCount : 0}</li>
                            <li>Quiz: ${stats.quizCount != null ? stats.quizCount : 0}</li>
                            <li>Assignment: ${stats.assignmentCount != null ? stats.assignmentCount : 0}</li>
                            <li>Discussion: ${stats.discussionCount != null ? stats.discussionCount : 0}</li>
                            <li><strong>Tổng nội dung:</strong>
                                ${(stats.lessonCount != null ? stats.lessonCount : 0)
                                  + (stats.quizCount != null ? stats.quizCount : 0)
                                  + (stats.assignmentCount != null ? stats.assignmentCount : 0)
                                  + (stats.discussionCount != null ? stats.discussionCount : 0)}
                            </li>
                        </ul>
                    </section>

                    <section class="course-instructor">
                        <h3>Giảng viên phụ trách</h3>
                        <c:choose>
                            <c:when test="${not empty instructor and not empty instructor.user}">
                                <div class="instructor-card">
                                    <p><strong>Họ tên:</strong> ${instructor.user.fullName}</p>
                                    <p><strong>Email:</strong> ${instructor.user.email}</p>
                                    <p><strong>Chuyên môn:</strong> ${empty instructor.expertise ? 'Chưa cập nhật' : instructor.expertise}</p>
                                    <p><strong>Giới thiệu:</strong> ${empty instructor.bio ? 'Không có mô tả' : instructor.bio}</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="empty">Chưa có thông tin giảng viên.</p>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>

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
                                        <span>Chương ${m.orderIndex}: ${m.title}</span>
                                        <i class="fa fa-chevron-down"></i>
                                    </div>

                                    <div class="module-lessons">
                                        <c:forEach var="i" items="${items}">
                                            <c:if test="${i.moduleId == m.moduleId}">
                                                <div class="lesson-block">
                                                    <div class="item-header" onclick="toggleItem(this)">
                                                        <h4 class="item-title">
                                                            <c:choose>
                                                                <c:when test="${i.itemType eq 'lesson'}">
                                                                    <i class="fa fa-play-circle"></i> ${i.lessonTitle}
                                                                </c:when>
                                                                <c:when test="${i.itemType eq 'quiz'}">
                                                                    <i class="fa fa-question-circle"></i> ${i.quizTitle}
                                                                </c:when>
                                                                <c:when test="${i.itemType eq 'assignment'}">
                                                                    <i class="fa fa-tasks"></i> ${i.assignmentTitle}
                                                                </c:when>
                                                                <c:when test="${i.itemType eq 'discussion'}">
                                                                    <i class="fa fa-comments"></i> ${i.discussionTitle}
                                                                </c:when>
                                                            </c:choose>
                                                        </h4>
                                                        <i class="fa fa-chevron-down toggle-icon"></i>
                                                    </div>

                                                    <div class="item-detail" style="display:none;">
                                                        <c:if test="${i.itemType eq 'lesson'}">
                                                            <p><strong>Loại nội dung:</strong> ${i.contentType}</p>
                                                            <c:if test="${not empty i.videoUrl}">
                                                                <iframe width="560" height="315" src="${i.videoUrl}" frameborder="0" allowfullscreen></iframe>
                                                                <p><i class="fa fa-clock"></i> Thời lượng: ${i.durationSec} giây</p>
                                                            </c:if>
                                                            <c:if test="${not empty i.textContent}">
                                                                <div class="text-content">${i.textContent}</div>
                                                            </c:if>


                                                            <c:set var="hasQuestion" value="false" />
                                                            <c:forEach var="q" items="${questions}">
                                                                <c:if test="${q.lessonId == i.itemId}">
                                                                    <c:if test="${not hasQuestion}">
                                                                        <c:set var="hasQuestion" value="true" />
                                                                        <div class="lesson-questions">
                                                                            <h5>Các câu hỏi trong bài học:</h5>
                                                                        </c:if>

                                                                        <div class="question-item">
                                                                            <strong>Q${q.questionId}:</strong> ${q.content}

                                                                            <c:if test="${not empty q.mediaUrl}">
                                                                                <c:set var="fixedUrl" value="${fn:replace(q.mediaUrl, 'watch?v=', 'embed/')}" />
                                                                                <div class="q-media">
                                                                                    <c:choose>
                                                                                        <c:when test="${fn:contains(fixedUrl, 'youtube.com/embed')}">
                                                                                            <div class="youtube-container">
                                                                                                <iframe class="youtube-embed"
                                                                                                        src="${fixedUrl}"
                                                                                                        frameborder="0"
                                                                                                        allowfullscreen
                                                                                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture">
                                                                                                </iframe>
                                                                                            </div>
                                                                                        </c:when>
                                                                                        <c:when test="${fn:endsWith(q.mediaUrl, '.jpg') or fn:endsWith(q.mediaUrl, '.jpeg') or fn:endsWith(q.mediaUrl, '.png') or fn:endsWith(q.mediaUrl, '.gif')}">
                                                                                            <img src="${q.mediaUrl}" alt="Hình minh họa" class="media-img" />
                                                                                        </c:when>
                                                                                        <c:when test="${fn:endsWith(q.mediaUrl, '.mp4') or fn:endsWith(q.mediaUrl, '.webm') or fn:endsWith(q.mediaUrl, '.mov')}">
                                                                                            <video controls class="media-video">
                                                                                                <source src="${q.mediaUrl}" type="video/mp4" />
                                                                                            </video>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <a href="${q.mediaUrl}" target="_blank">${q.mediaUrl}</a>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                            </c:if>

                                                                            <c:if test="${not empty q.options}">
                                                                                <div class="option-list">
                                                                                    <h6>Các lựa chọn:</h6>
                                                                                    <c:forEach var="opt" items="${q.options}">
                                                                                        <div class="option ${opt.isCorrect ? 'correct' : ''}">
                                                                                            <i class="fa ${opt.isCorrect ? 'fa-check-circle text-success' : 'fa-circle'}"></i>
                                                                                            ${opt.content}
                                                                                        </div>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </c:if>

                                                                            <c:if test="${not empty q.answers}">
                                                                                <div class="answer-list">
                                                                                    <h6>Đáp án mẫu:</h6>
                                                                                    <ul>
                                                                                        <c:forEach var="ans" items="${q.answers}">
                                                                                            <li>${ans.answerText}</li>
                                                                                            </c:forEach>
                                                                                    </ul>
                                                                                </div>
                                                                            </c:if>

                                                                            <c:if test="${not empty q.explanation}">
                                                                                <div class="muted"><em>Giải thích:</em> ${q.explanation}</div>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:if test="${hasQuestion}">
                                                                </div>
                                                            </c:if>
                                                        </c:if>

                                                        <c:if test="${i.itemType eq 'quiz'}">
                                                            <p><strong>Giới hạn thời gian:</strong>
                                                                <c:choose>
                                                                    <c:when test="${i.timeLimitMin != null}">
                                                                        ${i.timeLimitMin} phút
                                                                    </c:when>
                                                                    <c:otherwise>Không giới hạn</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                            <p>Tỉ lệ qua: ${i.quizPassingPct}%</p>
                                                            <p>Số câu chọn ngẫu nhiên: ${i.pickCount}</p>
                                                        </c:if>

                                                        <c:if test="${i.itemType eq 'assignment'}">
                                                            <div class="assignment-detail">
                                                                <p><strong>Hình thức nộp:</strong> ${i.submissionType}</p>
                                                                <p><strong>Điểm tối đa:</strong> 100</p>
                                                                <p><strong>Tỉ lệ qua:</strong> ${i.assignmentPassingPct}%</p>
                                                                <c:if test="${not empty i.assignmentInstructions}">
                                                                    <c:if test="${not empty i.attachmentUrl}">
                                                                        <p>Tệp đính kèm:
                                                                            <a href="${i.attachmentUrl}" target="_blank" class="btn btn-outline">Xem / Tải tệp Word</a>
                                                                        </p>
                                                                    </c:if>
                                                                    <div class="text-content"><h5>Hướng dẫn:</h5>${i.assignmentInstructions}</div>
                                                                </c:if>
                                                                <c:if test="${not empty i.assignmentContent}">
                                                                    <div class="text-content"><h5>Nội dung bài tập:</h5>${i.assignmentContent}</div>
                                                                </c:if>
                                                            </div>
                                                        </c:if>

                                                        <c:if test="${i.itemType eq 'discussion'}">
                                                            <p>${i.discussionDescription}</p>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </main>

        <div id="rejectModal" class="modal">
            <div class="modal-content">
                <h3>Nhập lý do từ chối</h3>
                <form method="post" action="coursedetail">
                    <input type="hidden" name="action" value="reject" />
                    <input type="hidden" name="courseId" id="rejectCourseId" />
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
                <form method="post" action="coursedetail">
                    <input type="hidden" name="action" value="publish" />
                    <input type="hidden" name="courseId" id="scheduleCourseId" />
                    <div class="form-group">
                        <label for="publishDate">Ngày đăng:</label>
                        <input type="date" name="publishDate" id="publishDate" required />
                    </div>
                    <div class="modal-buttons">
                        <button type="submit" class="btn btn-primary">Lưu lịch</button>
                        <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleModule(h) {
                const c = h.nextElementSibling;
                const i = h.querySelector("i");
                const open = c.style.display === "block";
                document.querySelectorAll('.module-lessons').forEach(e => e.style.display = "none");
                document.querySelectorAll('.module-header i').forEach(e => e.classList.replace("fa-chevron-up", "fa-chevron-down"));
                if (!open) {
                    c.style.display = "block";
                    i.classList.replace("fa-chevron-down", "fa-chevron-up");
                }
            }

            function toggleItem(h) {
                const d = h.nextElementSibling;
                const i = h.querySelector(".fa-chevron-down, .fa-chevron-up");
                const open = d.style.display === "block";
                h.parentElement.parentElement.querySelectorAll(".item-detail").forEach(e => e.style.display = "none");
                h.parentElement.parentElement.querySelectorAll(".item-header i.fa-chevron-up").forEach(e => e.classList.replace("fa-chevron-up", "fa-chevron-down"));
                d.style.display = open ? "none" : "block";
                i.classList.replace(open ? "fa-chevron-up" : "fa-chevron-down", open ? "fa-chevron-down" : "fa-chevron-up");
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