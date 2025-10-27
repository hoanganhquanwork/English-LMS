<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <title>Chi tiết báo lỗi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
        <%@ include file="admin_sidebar.jsp" %>
    </head>

    <body class="p-4 main-content">
        <h3 class="mb-4">Chi tiết báo lỗi #${report.reportId}</h3>

        <div class="card mb-3">
            <div class="card-body">
                <p><strong>Người gửi:</strong> ${report.reporterName} (${report.reporterEmail})</p>
                <p><strong>Vai trò:</strong> ${report.reporterRole}</p>
                <p><strong>Loại lỗi:</strong> ${report.typeName}</p>
                <p><strong>Trang xảy ra lỗi:</strong> 
                    <a href="${report.pageUrl}" target="_blank">${report.pageUrl}</a>
                </p>
                <p><strong>Nội dung mô tả:</strong></p>
                <pre class="border rounded bg-light p-3">${report.description}</pre>
                <p><strong>Thời gian gửi:</strong> ${report.createdAt}</p>
                <p><strong>Trạng thái hiện tại:</strong> 
                    <c:choose>
                        <c:when test="${report.status == 'pending'}">
                            <span class="badge bg-warning text-dark">Chờ xử lý</span>
                        </c:when>
                        <c:when test="${report.status == 'in_progress'}">
                            <span class="badge bg-info text-dark">Đang xử lý</span>
                        </c:when>
                        <c:when test="${report.status == 'resolved'}">
                            <span class="badge bg-success">Đã xử lý</span>
                        </c:when>
                        <c:when test="${report.status == 'rejected'}">
                            <span class="badge bg-danger">Từ chối</span>
                        </c:when>
                    </c:choose>
                </p>
            </div>
        </div>

        <form method="post" action="<%=ctx%>/admin/report-update">
            <input type="hidden" name="reportId" value="${report.reportId}"/>

            <div class="mb-3">
                <label class="form-label">Ghi chú cho người dùng</label>
                <textarea name="adminNote" class="form-control" rows="4">${report.adminNote}</textarea>
            </div>

            <div class="d-flex gap-2">
                <c:choose>
                    <c:when test="${report.status == 'pending'}">
                        <button name="status" value="in_progress" class="btn btn-success">
                            <i class="bi bi-check-circle"></i> Chấp nhận & Xử lý
                        </button>
                        <button name="status" value="rejected" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i> Từ chối
                        </button>
                    </c:when>

                    <c:when test="${report.status == 'in_progress'}">
                        <button name="status" value="resolved" class="btn btn-primary">
                            <i class="bi bi-check2-all"></i> Đánh dấu đã xử lý
                        </button>
                        <button name="status" value="rejected" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i> Không thể xử lý
                        </button>
                    </c:when>

                    <c:when test="${report.status == 'resolved'}">
                        <div class="alert alert-success mb-0">
                            Báo lỗi này đã được xử lý xong.
                        </div>
                    </c:when>

                    <c:when test="${report.status == 'rejected'}">
                        <div class="alert alert-secondary mb-0">
                            Báo lỗi này đã bị từ chối.
                        </div>
                    </c:when>
                </c:choose>

                <a href="<%=ctx%>/admin/report-list" class="btn btn-outline-secondary ms-auto">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </form>
    </body>
</html>
