<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Courses | Teacher | LinguaTrack LMS</title>
        <link rel="stylesheet" href="css/styles.css" />
        <link rel="stylesheet" href="css/courses.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    </head>
    <body  data-rejected-id="${rejectedCourseId}" 
           data-reason="${fn:escapeXml(rejectionReason)}">
        <header class="header">
            <div class="container navbar">
                <a class="brand" href="../index.html"><div class="logo"></div><span>LinguaTrack</span></a>
                <button class="hamburger btn ghost">☰</button>
            </div>
        </header>

        <main class="container admin-layout">
            <jsp:include page="sidebar.jsp" />

            <section>
                <div class="page-title" style="display:flex; align-items:center; justify-content:space-between; gap:12px;">
                    <h2>Courses</h2>
                    <button class="btn" onclick="openCreateCourseModal()">Tạo khóa học</button>
                </div>

                <div class="card panel" style="padding:16px;">
                    <div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:12px;">
                        <div style="display:flex; gap:12px; align-items:center;">
                            <form method="get" action="manage">
                                <input class="input" type="text" name="keyword" value="${keyword}" placeholder="Tìm kiếm khóa học..." style="max-width:360px;"  onchange="this.form.submit()"/>
                                <select class="input" name="status" style="max-width:220px;" onchange="this.form.submit()">
                                    <option value="all" ${status=="all" ? "selected" : ""}>Tất cả trạng thái</option>
                                    <option value="draft" ${status=="draft" ? "selected" : ""}>Draft</option>
                                    <option value="submitted" ${status=="submitted" ? "selected" : ""}>Submitted</option>
                                    <option value="approved" ${status=="approved" ? "selected" : ""}>Approved</option>
                                    <option value="rejected" ${status=="rejected" ? "selected" : ""}>Rejected</option>
                                </select>
                            </form>
                        </div>

                    </div>

                    <div style="overflow:auto;">
                        <table class="table" style="width:100%; min-width:920px;">
                            <thead>
                                <tr>
                                    <th>Hình</th>
                                    <th style="text-align:left;">Tên khóa</th>
                                    <th>Ngôn ngữ</th>
                                    <th>Cấp độ</th>
                                    <th>Trạng thái</th>
                                    <th style="width:140px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${requestScope.courseList}">
                                    <tr data-id="${h.courseId}"
                                        data-title="${h.title}"
                                        data-language="${h.language}"
                                        data-level="${h.level}"
                                        data-category="${h.category.categoryId}"
                                        data-price="${h.price}"
                                        data-description="${h.description}"
                                        data-status="${h.status}"
                                        data-thumbnail="${h.thumbnail}">
                                        <td style="text-align:center;">
                                            <c:choose>
                                                <c:when test="${not empty h.thumbnail}">
                                                    <img src="${pageContext.request.contextPath}/${h.thumbnail}" 
                                                         alt="${h.title}" 
                                                         style="width:48px; height:64px; object-fit:cover; border-radius:6px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width:48px; height:64px; background:#eee;
                                                         border-radius:6px; display:flex;
                                                         align-items:center; justify-content:center; color:#888;">
                                                        <i class="fa fa-image"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><a href="manageModule?courseId=${h.courseId}" style="text-decoration: none; color: black;"><strong>${h.title}</strong></a>
                                            <div class="muted">Mã: ${h.courseId}
                                            </div>
                                        </td>
                                        <td style="text-align:center;">${h.language}</td>
                                        <td style="text-align:center;">${h.level}</td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(h.status)}">
                                                ${h.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <c:if test="${h.status == 'draft'}">
                                                    <a href="submitCourse?courseId=${h.courseId}" 
                                                       class="btn-icon" 
                                                       title="Submit khóa học" 
                                                       onclick="return confirm('Bạn có chắc muốn submit khóa học này để phê duyệt không?');">
                                                        <i class="fas fa-paper-plane"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${h.status == 'rejected'}">
                                                    <a href="submitCourse?courseId=${h.courseId}" 
                                                       class="btn-icon" 
                                                       title="Submit lại khóa học" 
                                                       onclick="return confirm('Bạn có chắc muốn submit lại khóa học này để phê duyệt không?');">
                                                        <i class="fas fa-redo"></i>
                                                    </a>
                                                    <a href="getRejectionReason?courseId=${h.courseId}"
                                                       class="btn-icon"
                                                       title="Xem lí do từ chối">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${h.status == 'draft' || h.status == 'rejected' }">
                                                    <a class="btn-icon edit-btn" title="Sửa" onclick="editCourse(this)">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="deleteCourse?courseId=${h.courseId}" 
                                                       class="btn-icon" 
                                                       title="Xóa" 
                                                       onclick="return confirm('Bạn có chắc muốn xóa khóa học này không?');">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr> 
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>

        <footer class="footer">
            <div class="container bottom">© 2025 LinguaTrack</div>
        </footer>

        <!-- Modal khóa học (dùng chung cho tạo mới và sửa) -->
        <div id="courseModal" class="modal" style="display: none;">
            <div class="modal-content">

                <div class="modal-header">
                    <h3 id="modalTitle">Tạo khóa học mới</h3>
                    <span class="close" onclick="closeCourseModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="courseForm" action="addCourse" method="post" enctype="multipart/form-data">
                        <input type="hidden" id="courseId" name="courseId">

                        <div class="form-group">
                            <label for="courseThumbnail">Ảnh khóa học *</label>
                            <div style="margin-bottom:8px;">
                                <img id="previewThumbnail" src="" 
                                     alt="Xem trước ảnh" 
                                     style="width:120px; height:80px; object-fit:cover; border-radius:6px; display:none; border:1px solid #ccc;">
                            </div>
                            <input type="file" id="courseThumbnail" name="thumbnail" accept="image/*" class="input" required>
                            <input type="hidden" id="oldThumbnail" name="oldThumbnail">
                        </div>
                        <div class="form-group">
                            <label for="courseTitle">Tên khóa học *</label>
                            <input type="text" id="courseTitle" name="title" class="input" required 
                                   placeholder="Nhập tên khóa học">
                        </div>

                        <div class="form-group">
                            <label for="courseLanguage">Ngôn ngữ *</label>
                            <select id="courseLanguage" name="language" class="input" required>
                                <option value="">Chọn ngôn ngữ</option>
                                <option value="English">English</option>
                                <option value="Vietnamese">Vietnamese</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="courseLevel">Cấp độ *</label>
                            <select id="courseLevel" name="level" class="input" required>
                                <option value="">Chọn cấp độ</option>
                                <option value="Beginner">Beginner (Mới bắt đầu)</option>
                                <option value="Elementary">Elementary (Cơ bản)</option>
                                <option value="Intermediate">Intermediate (Trung cấp)</option>
                                <option value="Advanced">Advanced (Nâng cao)</option>
                                <option value="Expert">Expert (Chuyên gia)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="courseCategory">Danh mục *</label>
                            <select id="courseCategory" name="category" class="input" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="h" items="${requestScope.cateList}">
                                    <option value="${h.categoryId}">${h.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="courseDescription">Mô tả khóa học</label>
                            <textarea id="courseDescription" name="description" class="input" rows="4" 
                                      placeholder="Nhập mô tả khóa học"></textarea>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn secondary" onclick="closeCourseModal()">Hủy</button>
                            <button type="submit" class="btn" id="submitBtn">Tạo khóa học</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal hiển thị lí do từ chối -->
        <div id="rejectionModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="rejectionModalTitle">Lí do từ chối khóa học</h3>
                    <span class="close" onclick="closeRejectionModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="rejection-info">
                        <div class="course-info">
                            <h4 id="rejectedCourseTitle"></h4>
                            <p><strong>Mã khóa học:</strong> <span id="rejectedCourseId"></span></p>
                        </div>
                        <div class="rejection-reason">
                            <h4>Lí do từ chối:</h4>
                            <div id="rejectionReasonContent" class="rejection-content">
                                <!-- Nội dung lí do từ chối sẽ được load từ server -->
                            </div>
                        </div>
                        <div class="rejection-actions">
                            <button type="button" class="btn secondary" onclick="closeRejectionModal()">Đóng</button>
                            <button type="button" class="btn" onclick="resubmitCourse()">Submit lại</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <c:if test="${not empty rejectionReason}">
            <script>
                window.addEventListener("DOMContentLoaded", function () {
                    const body = document.body;
                    const courseId = body.dataset.rejectedId;
                    const reason = body.dataset.reason;

                    if (reason && reason.trim() !== "") {
                        const title = "Khóa học " + courseId;
                        showRejectionModal(courseId, title, reason);
                    }
                });
            </script>
        </c:if>

        <link rel="stylesheet" href="css/courses.css" />
        <script src="js/courses.js"></script>
        <script>
                let currentRejectedCourseId = null;

                function showRejectionModal(courseId, courseTitle, reason) {
                    currentRejectedCourseId = courseId;
                    document.getElementById('rejectedCourseTitle').textContent = courseTitle;
                    document.getElementById('rejectedCourseId').textContent = courseId;

                    const reasonBox = document.getElementById('rejectionReasonContent');
                    if (reason && reason.trim() !== "") {
                        reasonBox.innerHTML = "<p>" + reason + "</p>";
                    } else {
                        reasonBox.innerHTML = "<p class='text-muted'>Không có thông tin chi tiết về lý do từ chối.</p>";
                    }

                    document.getElementById('rejectionModal').style.display = 'flex';
                }

                function closeRejectionModal() {
                    document.getElementById('rejectionModal').style.display = 'none';
                    currentRejectedCourseId = null;
                }

                function resubmitCourse() {
                    if (currentRejectedCourseId) {
                        if (confirm('Bạn có chắc muốn submit lại khóa học này để phê duyệt không?')) {
                            window.location.href = 'submitCourse?courseId=' + currentRejectedCourseId;
                        }
                    }
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    const rejectionModal = document.getElementById('rejectionModal');
                    if (event.target === rejectionModal) {
                        closeRejectionModal();
                    }
                };
        </script>
    </body>
</html>



