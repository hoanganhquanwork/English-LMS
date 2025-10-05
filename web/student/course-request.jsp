<%-- 
    Document   : course-request
    Created on : Oct 5, 2025, 5:17:19 PM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gửi yêu cầu nhập học</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body{
                background: #f8fafc;
            }
            .page-container{
                max-width: 1200px;
            }
            .card{
                border: 0;
                border-radius: 14px;
                box-shadow: 0px 8x 28px rgba(2,6,23,.06);
            }
            .card-header{
                border-bottom: 0;
                background: transparent;
            }
            .sticky-filters{
                position: sticky;
                top: 0;
                z-index: 10;
                background: #ffffff !important;
                border-bottom: 1px solid #eee;
                border-radius: 14px 14px 0 0;
            }
            .status-badge {
                text-transform: capitalize;
                font-weight: 600;
                letter-spacing: .2px;
            }
            .status-saved    {
                background:#e2e8f0;
                color:#0f172a;
            }
            .status-pending  {
                background:#fff3cd;
                color:#7a5a00;
            }
            .status-approved {
                background:#d1fae5;
                color:#065f46;
            }
            .status-rejected {
                background:#fee2e2;
                color:#7f1d1d;
            }
            .status-canceled {
                background:#f1f5f9;
                color:#334155;
            }
            .btn.btn-secondary.w-100:hover {
                background-color: #dc3545 !important;
                border-color: #dc3545 !important;
            }
            #resubmit:hover {
                background-color: #0d6efd !important;
                border-color: #0d6efd !important;
            }
        </style>
    </head>
    <body>
        <header>
            <jsp:include page="../header.jsp"/>
        </header>
        <div class="container py-4 page-container ">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card">
                        <!--Parent request-->
                        <div class="card-header">
                            <h2 class="h6 mb-0">Liên kết tài khoản phụ huynh</h2>
                        </div>
                        <div class="card-body">
                            <div>
                                <form action="${pageContext.request.contextPath}/parentLinkRequest" method="post" class="mb-3" onsubmit="return validateEmail()">
                                    <div class="mb-3">
                                        <label class="form-label">Học sinh</label>
                                        <c:set var="fullName" value="${sessionScope.user.fullName}" />
                                        <input type="text" value="${fullName == null ? sessionScope.user.username : fullName }" class="form-control" disabled>
                                        <input type="hidden" name="studentId" value="${requestScope.studentId}">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email phụ huynh: </label>
                                        <input type="text" id='parentEmail' name="parentEmail" value="${requestScope.requestEmail}" class="form-control" 
                                               placeholder="Nhập email phụ huynh tại đây" 
                                               ${requestScope.requestStatus == 'pending' || requestScope.requestStatus == 'approved' ? 'disabled' : ''}
                                               required>          
                                        <div id="errEmail" class="text-danger small mt-1"></div>
                                        <div class="text-danger small mt-1">${requestScope.messageRequest}</div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${requestScope.requestStatus == 'pending'}">
                                            <button type="submit" name="requestType" value="cancel" class="btn btn-secondary w-100">Yêu cầu liên kết đang được xử lý, hủy yêu cầu</button>
                                        </c:when>
                                        <c:when test="${requestScope.requestStatus == 'canceled'}">
                                            <button id="resubmit" type="submit" name="requestType" value="link" class="btn btn-danger w-100">Yêu cầu liên kết đã bị hủy, gửi lại</button>
                                        </c:when>
                                        <c:when test="${requestScope.requestStatus == 'rejected'}">
                                            <button id="resubmit" type="submit" name="requestType" value="link" class="btn btn-danger w-100">Yêu cầu liên kết bị từ chối, gửi lại</button>
                                        </c:when>
                                        <c:when test="${requestScope.requestStatus == 'approved'}">
                                            <button type="submit" name="requestType" value="unlink" class="btn btn-danger w-100">Hủy liên kết</button>
                                        </c:when>
                                        <c:when test="${sessionScope.student.parentId == null}">
                                            <button type="submit" name="requestType" value="link" class="btn btn-primary w-100">Tài khoản chưa liên kết, gửi yêu cầu liên kết</button>
                                        </c:when>
                                    </c:choose>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Course request-->
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header sticky-filters">
                            <form class="row g-2 align-items-end" action="" method="">
                                <input type="hidden" name="page">
                                <!--Status-->
                                <div class="col-md-4">
                                    <label class="form-label">Lọc theo trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="" ${empty status ? 'selected': ''}>Tất cả</option>
                                        <option value="saved" ${status == 'saved' ? 'selected': ''}>Tạm lưu</option>
                                        <option value="pending" ${status == 'pending' ? 'selected': ''}>Đang chờ</option>
                                        <option value="approved" ${status == 'approved' ? 'selected': ''}>Được duyệt</option>
                                        <option value="rejected" ${status == 'rejected' ? 'selected': ''}>Từ chối</option>
                                        <option value="canceled" ${status == 'canceled' ? 'selected': ''}>Hủy bỏ</option>
                                    </select>
                                </div>
                                <!--Sort-->
                                <div class="col-md-2">
                                    <label class="form-label">Sắp xếp</label>
                                    <select name="sort" class="form-select">
                                        <option value="asc" ${sort=='asc'?'selected':''}>A → Z</option>
                                        <option value="desc" ${sort=='desc'?'selected':''}>Z → A</option>
                                    </select>
                                </div>
                                <!--Keyword-->
                                <div class="col-md-4">
                                    <label class="form-label" >Nhập tên từ khóa</label>
                                    <input type="text" name="keyword" value="" class="form-control" placeholder="VD: Ielts">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-outline-primary">Áp dụng</button>
                                </div>
                            </form>
                        </div>
                        <!--Card body-->
                        <div class="card-body">
                            <div>
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Khóa học</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty rows}">
                                            <tr><td colspan="3" class="text-center text-muted">Không có dữ liệu</td></tr>
                                        </c:if>
                                        <c:forEach var="c" items="${requestScope.courses}">
                                            <tr>
                                                <td><c:out value="${c.courseTitle}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.status=='saved'}"><span class="badge status-badge status-saved">Tạm lưu</span></c:when>
                                                        <c:when test="${c.status=='pending'}"><span class="badge status-badge status-pending">Đang đợi</span></c:when>
                                                        <c:when test="${c.status=='approved'}"><span class="badge status-badge status-approved">Được duyệt</span></c:when>
                                                        <c:when test="${c.status=='rejected'}"><span class="badge status-badge status-rejected">Từ chối</span></c:when>
                                                        <c:when test="${c.status=='canceled'}"><span class="badge status-badge status-canceled">Hủy bỏ</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.status=='saved'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/course-requests" style="display:inline;">
                                                                <input type="hidden" name="requestId" value="${c.requestId}">
                                                                <input type="hidden" name="requestStatus" value="">
                                                                <button class="btn btn-sm btn-success">Gửi request</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${c.status=='pending'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/course-requests" style="display:inline;" onsubmit="return confirm('Bạn chắc muốn hủy yêu cầu này?');">
                                                                <input type="hidden" name="requestId" value="${c.requestId}">
                                                                <input type="hidden" name="requestStatus" value="">
                                                                <button class="btn btn-sm btn-outline-danger">Cancel</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${c.status=='rejected' || c.status=='canceled'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/course-requests" style="display:inline;">
                                                                <input type="hidden" name="requestId" value="${c.requestId}">
                                                                <input type="hidden" name="requestStatus" value="">
                                                                <button class="btn btn-sm btn-primary">Gửi lại</button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${totalPages > 1}">
                                <form action="${pageContext.request.contextPath}/" method="get"
                                      class="d-flex justify-content-center gap-1 mt-4" style="margin-top:12px;">
                                    <input type="hidden" name="status"  value="${param.status}">
                                    <input type="hidden" name="sort"    value="${param.sort}">
                                    <input type="hidden" name="keyword" value="${param.keyword}">

                                    <c:if test="${page > 1}">
                                        <button type="submit" name="page" value="${page-1}" class="btn btn-outline-secondary btn-sm">«</button>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <button type="submit" name="page" value="${i}"
                                                class="btn btn-sm ${i==page ? 'btn-primary' : 'btn-outline-secondary'}">${i}</button>
                                    </c:forEach>

                                    <c:if test="${page < totalPages}">
                                        <button type="submit" name="page" value="${page+1}" class="btn btn-outline-secondary btn-sm">»</button>
                                    </c:if>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <footer>
            <jsp:include page="../footer.jsp"/>
        </footer>
    </body>
</html>
<script>
    function validateEmail() {
        document.getElementById("errEmail").innerText = "";

        let email = document.getElementById("parentEmail").value;

        let valid = true;
        let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            document.getElementById("errEmail").innerText = "Email không hợp lệ";
            valid = false;
        }
        return valid;
    }
</script>
