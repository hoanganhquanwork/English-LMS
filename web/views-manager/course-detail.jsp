<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết khóa học - Manager Dashboard</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-style.css' />">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <%@include file="includes-manager/header-manager.jsp" %>

        <main class="main-content">
            <div class="container">
                <div style="margin-bottom: 24px;">
                    <a href="coursemanager" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>

                <div style="display: grid; grid-template-columns: 300px 1fr; gap: 32px; margin-bottom: 32px;">
                    <div>
                        <img src="${course.thumbnail != null ? course.thumbnail : '/views-manager/icon/default.png'}" alt="Course Thumbnail" 
                             style="width: 100%; border-radius: var(--radius); border: 1px solid var(--border);">
                    </div>
                    <div>
                        <h1 style="font-size: 32px; font-weight: 700; color: var(--text); margin-bottom: 16px;">
                            ${course.title}
                        </h1>
                        <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 16px;">
                            <span class="status-badge pending">${course.status}</span>
                            <span style="color: var(--muted);">
                                <i class="fas fa-calendar"></i> Gửi lên: ${course.createdAt}
                            </span>
                        </div>


                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding: 16px; background: var(--bg); border-radius: var(--radius);">
                            <img src="${course.createdBy.user.profilePicture != null ? course.createdBy.user.profilePicture : '/assets/icon/default.png'}"  alt="Teacher" style="width: 50px; height: 50px; border-radius: 50%;">
                            <div>
                                <strong>${course.createdBy.user.fullName}</strong>
                                <br>
                                <small style="color: var(--muted);">${course.createdBy.user.email}</small>
                            </div>
                        </div>

                        <div style="display: flex; gap: 12px;">
                            <form method="post" action="coursemanager" style="display:inline;">
                                <input type="hidden" name="courseIds" value="${course.courseId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Duyệt khóa học </button>
                            </form>

                            <form method="post" action="coursemanager" style="display:inline;">
                                <input type="hidden" name="courseIds" value="${course.courseId}">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i> Từ chối </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 32px;">
                    <div>
                        <div class="stat-card" style="margin-bottom: 24px;">
                            <h2 style="margin-bottom: 16px; color: var(--text);">Mô tả khóa học</h2>
                            <p style="line-height: 1.6; color: var(--text);">
                                ${course.description != null ? course.description : "Chưa có"}
                            </p>
                        </div>

                        <div class="stat-card">
                            <h2 style="margin-bottom: 16px; color: var(--text);">Chương trình học</h2>
                            <div style="display: flex; flex-direction: column; gap: 16px;">
                                <div style="border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden;">
                                    <div style="background: var(--bg); padding: 16px; border-bottom: 1px solid var(--border);">
                                        <h3 style="margin: 0; color: var(--text);">
                                            <i class="fas fa-play-circle"></i>
                                        </h3>
                                        <small style="color: var(--muted);"></small>
                                    </div>
                                    <div style="padding: 16px;">
                                        <div style="display: flex; flex-direction: column; gap: 8px;">
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-video" style="color: var(--muted);"></i>
                                                <span></span>
                                                <small style="color: var(--muted); margin-left: auto;"></small>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-video" style="color: var(--muted);"></i>
                                                <span></span>
                                                <small style="color: var(--muted); margin-left: auto;"></small>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-file-alt" style="color: var(--muted);"></i>
                                                <span></span>
                                                <small style="color: var(--muted); margin-left: auto;"></small>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div style="border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden;">
                                    <div style="background: var(--bg); padding: 16px; border-bottom: 1px solid var(--border);">
                                        <h3 style="margin: 0; color: var(--text);">
                                            <i class="fas fa-play-circle"></i>
                                        </h3>
                                        <small style="color: var(--muted);"></small>
                                    </div>
                                    <div style="padding: 16px;">
                                        <div style="display: flex; flex-direction: column; gap: 8px;">
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-video" style="color: var(--muted);"></i>
                                                <span></span>
                                                <small style="color: var(--muted); margin-left: auto;"></small>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-video" style="color: var(--muted);"></i>
                                                <span></span>
                                                <small style="color: var(--muted); margin-left: auto;"></small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div>

                        <div class="stat-card" style="margin-bottom: 24px;">
                            <h3 style="margin-bottom: 16px; color: var(--text);">Thông tin khóa học</h3>
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Tổng bài học:</span>
                                    <strong></strong>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Thời lượng:</span>
                                    <strong></strong>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Cấp độ:</span>
                                    <strong></strong>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Danh mục:</span>
                                    <strong>${course.category.name}</strong>
                                </div>
                                <div class="stat-card" style="margin-top: 24px;">
                                    <h3 style="margin-bottom: 16px; color: var(--text);">Chỉnh giá khóa học</h3>

                                    <c:if test="${course.status eq 'approved'}">
                                        <form method="post" action="coursemanager" style="display: flex; gap: 12px; align-items: center;">
                                            <input type="hidden" name="action" value="setPrice">
                                            <input type="hidden" name="source" value="detail">
                                            <input type="hidden" name="courseId" value="${course.courseId}">
                                            <input type="number" name="price" step="1000" min="0"
                                                   value="<c:out value='${course.price}'/>"
                                                   style="flex: 1; padding: 8px; border: 1px solid var(--border); border-radius: var(--radius);">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Lưu
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${course.status ne 'approved'}">
                                        <p style="color: var(--muted); font-style: italic;">
                                            Khóa học chưa được duyệt nên chưa thể chỉnh giá.
                                        </p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!--                         Review Notes 
                                                <div class="stat-card">
                                                    <h3 style="margin-bottom: 16px; color: var(--text);">Ghi chú đánh giá</h3>
                                                    <textarea placeholder="Nhập ghi chú đánh giá..." 
                                                              style="width: 100%; height: 120px; padding: 12px; border: 1px solid var(--border); border-radius: var(--radius); resize: vertical; font-family: inherit;"></textarea>
                                                    <button class="btn btn-outline" style="margin-top: 12px; width: 100%;">
                                                        <i class="fas fa-save"></i> Lưu ghi chú
                                                    </button>
                                                </div>-->
                    </div>
                </div>
            </div>
        </main>

        <script>
            function approveCourse() {
                if (confirm('Bạn có chắc muốn duyệt khóa học này?')) {
                    alert('Khóa học đã được duyệt thành công!');
                    // Redirect back to course management
                    window.location.href = 'course-management.html';
                }
            }

            function rejectCourse() {
                const reason = prompt('Nhập lý do từ chối:');
                if (reason && reason.trim()) {
                    alert('Khóa học đã bị từ chối!');
                    window.location.href = 'course-management.html';
                }
            }

            function requestChanges() {
                const changes = prompt('Nhập yêu cầu chỉnh sửa:');
                if (changes && changes.trim()) {
                    alert('Đã gửi yêu cầu chỉnh sửa đến giáo viên!');
                }
            }
        </script>
    </body>
</html>
