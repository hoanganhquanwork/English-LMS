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
                    <span class="badge bg-secondary">${report.status}</span>
                </p>
            </div>
        </div>

        <form method="post" action="<%=ctx%>/admin/report-update">
            <input type="hidden" name="reportId" value="${report.reportId}"/>

            <div class="mb-3">
                <label class="form-label">Cập nhật trạng thái</label>
                <select class="form-select" name="status" required>
                    <option value="pending" ${report.status=="pending"?"selected":""}>Chờ xử lý</option>
                    <option value="in_progress" ${report.status=="in_progress"?"selected":""}>Đang xử lý</option>
                    <option value="resolved" ${report.status=="resolved"?"selected":""}>Đã xử lý</option>
                    <option value="rejected" ${report.status=="rejected"?"selected":""}>Từ chối</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Ghi chú cho người dùng</label>
                <textarea name="adminNote" class="form-control" rows="4">${report.adminNote}</textarea>
            </div>

            <button class="btn btn-primary">
                <i class="bi bi-save me-1"></i> Lưu thay đổi
            </button>
            <a href="<%=ctx%>/admin/report-list" class="btn btn-secondary">Quay lại danh sách</a>
        </form>

    </body>
</html>
