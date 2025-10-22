<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết khóa học - Manager Dashboard</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-detail.css?v=322' />">
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
                            <form method="post" action="coursedetail">
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
                            <form method="post" action="coursedetail">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <button class="btn btn-success"><i class="fa fa-check"></i> Duyệt lại</button>
                            </form>
                        </c:when>

                        <c:when test="${course.status eq 'publish'}">
                            <form method="post" action="coursedetail">
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

                    <form method="post" action="coursedetail" class="inline-form">
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
                                                                </c:if>
                                                                <c:if test="${not empty i.textContent}">
                                                                <div class="text-content">${i.textContent}</div>
                                                            </c:if>
                                                            <p><i class="fa fa-clock"></i> Thời lượng: ${i.durationSec} giây</p>

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
                                                                                <p><a href="${q.mediaUrl}" target="_blank"><i class="fa fa-link"></i> Tệp / hình ảnh liên quan</a></p>
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
                                                            <p>Số lần làm: ${i.attemptsAllowed}</p>
                                                            <p>Tỉ lệ qua: ${i.quizPassingPct}%</p>
                                                            <p>Số câu chọn ngẫu nhiên: ${i.pickCount}</p>
                                                            <c:forEach var="quiz" items="${quizzes}">
                                                                <c:if test="${quiz.quizId == i.itemId}">
                                                                    <div class="quiz-bank">
                                                                        <h5>Ngân hàng câu hỏi:</h5>
                                                                        <c:forEach var="q" items="${quiz.bank}">
                                                                            <div class="question-item">
                                                                                <strong>Q${q.questionId}:</strong> ${q.content}
                                                                                <c:if test="${not empty q.mediaUrl}">
                                                                                    <p><a href="${q.mediaUrl}" target="_blank"><i class="fa fa-link"></i> Tệp / hình ảnh liên quan</a></p>
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
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>

                                                        <c:if test="${i.itemType eq 'assignment'}">
                                                            <div class="assignment-detail">
                                                                <p><strong>Hình thức nộp:</strong> ${i.submissionType}</p>
                                                                <p><strong>Điểm tối đa:</strong> ${i.maxScore}</p>
                                                                <p><strong>Tỉ lệ qua:</strong> ${i.assignmentPassingPct}%</p>
                                                                <c:if test="${not empty i.assignmentInstructions}">
                                                                    <div class="text-content"><h5>Hướng dẫn:</h5>${i.assignmentInstructions}</div>
                                                                </c:if>
                                                                <c:if test="${not empty i.assignmentContent}">
                                                                    <div class="text-content"><h5>Nội dung bài tập:</h5>${i.assignmentContent}</div>
                                                                </c:if>
                                                                <c:if test="${not empty i.rubric}">
                                                                    <div class="text-content"><h5>Rubric chấm điểm:</h5>${i.rubric}</div>
                                                                </c:if>
                                                                <c:if test="${not empty i.assignmentWorks}">
                                                                    <div class="assignment-work">
                                                                        <h5>Danh sách bài nộp mẫu:</h5>
                                                                        <ul>
                                                                            <c:forEach var="w" items="${i.assignmentWorks}">
                                                                                <li>${w.title} (${w.submissionType}) - Điểm tối đa ${w.maxScore}</li>
                                                                                </c:forEach>
                                                                        </ul>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </c:if>

                                                        <c:if test="${i.itemType eq 'discussion'}">
                                                            <p>${i.discussionDescription}</p>
                                                            <c:if test="${not empty i.discussionPosts}">
                                                                <div class="discussion-section">
                                                                    <h5>Danh sách bài viết:</h5>
                                                                    <c:forEach var="p" items="${i.discussionPosts}">
                                                                        <div class="post">
                                                                            <p><strong>${p.fullName}</strong> (${p.role})</p>
                                                                            <p>${p.content}</p>
                                                                            <p class="muted">${p.createdAt}</p>
                                                                            <c:if test="${not empty p.comments}">
                                                                                <div class="comments">
                                                                                    <h6><i class="fa fa-reply"></i> Bình luận:</h6>
                                                                                    <c:forEach var="cmt" items="${p.comments}">
                                                                                        <div class="comment">
                                                                                            <p><strong>${cmt.fullName}</strong> (${cmt.role})</p>
                                                                                            <p>${cmt.content}</p>
                                                                                            <p class="muted">${cmt.createdAt}</p>
                                                                                        </div>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:if>
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
                <form method="post" action="coursedetail">
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

        <div id="imageModal" class="modal" style="display:none;">
            <div class="modal-content image-viewer">
                <span class="close-btn" onclick="closeImageModal()">&times;</span>
                <div id="imageContainer" class="image-gallery"></div>
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

            function openImageModal(mediaUrls) {
                const modal = document.getElementById("imageModal");
                const container = document.getElementById("imageContainer");
                container.innerHTML = "";
                const urls = mediaUrls.split(",");
                urls.forEach(u => {
                    const url = u.trim();
                    if (url.match(/\.(jpg|jpeg|png|gif)$/i)) {
                        const img = document.createElement("img");
                        img.src = url;
                        img.className = "modal-image";
                        container.appendChild(img);
                    } else {
                        const link = document.createElement("a");
                        link.href = url;
                        link.target = "_blank";
                        link.textContent = url.split("/").pop();
                        container.appendChild(link);
                    }
                });
                modal.style.display = "flex";
            }
            function closeImageModal() {
                document.getElementById("imageModal").style.display = "none";
            }

            function toggleItem(header) {
                const detail = header.nextElementSibling;
                const icon = header.querySelector(".fa-chevron-down, .fa-chevron-up");
                const isOpen = detail.style.display === "block";
                header.parentElement.parentElement.querySelectorAll(".item-detail").forEach(el => {
                    el.style.display = "none";
                });
                header.parentElement.parentElement.querySelectorAll(".item-header i.fa-chevron-up").forEach(el => {
                    el.classList.replace("fa-chevron-up", "fa-chevron-down");
                });
                if (isOpen) {
                    detail.style.display = "none";
                    icon.classList.replace("fa-chevron-up", "fa-chevron-down");
                } else {
                    detail.style.display = "block";
                    icon.classList.replace("fa-chevron-down", "fa-chevron-up");
                }
            }
        </script>

    </body>
</html>