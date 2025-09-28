<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Courses | Teacher | LinguaTrack LMS</title>
        <link rel="stylesheet" href="css/styles.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    </head>
    <body>
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
                                        data-status="${h.status}">
                                        <td><div style="width:48px; height:64px; background:#eee; border-radius:6px;"></div></td>
                                        <td><a href="manageModule?courseId=${h.courseId}" style="text-decoration: none; color: black;"><strong>${h.title}</strong></a>
                                            <div class="muted">Mã: ${h.courseId}
                                            </div>
                                        </td>
                                        <td style="text-align:center;">${h.language}</td>
                                        <td style="text-align:center;">${h.level}</td>
                                        <td>
                                            <span style="display:inline-block; padding:4px 8px; background:#e8f5e9; color:#2e7d32; border-radius:999px; text-transform:capitalize;">
                                                ${h.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display:flex; gap:8px;">
                                                <a class="btn-icon edit-btn" title="Sửa" onclick="editCourse(this)">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="deleteCourse?courseId=${h.courseId}" 
                                                   class="btn-icon" 
                                                   title="Xóa" 
                                                   onclick="return confirm('Bạn có chắc muốn xóa khóa học này không?');">
                                                    <i class="fas fa-trash"></i>
                                                </a>
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
                    <form id="courseForm" action="addCourse" method="post" >
                        <input type="hidden" id="courseId" name="courseId">
                 

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

        <link rel="stylesheet" href="css/courses.css" />
        <script src="js/courses.js"></script>
    </body>
</html>



