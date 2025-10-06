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
                box-shadow: 0px 8px 28px rgba(2,6,23,.06);
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
                <div class="col-lg-3">
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
                <div class="col-lg-9">
                    <div class="card">
                        <div class="card-header sticky-filters">
                            <form class="row g-2 align-items-end" action="${pageContext.request.contextPath}/courseRequest" method="get">
                                <input type="hidden" name="page" value="">
                                <!--Status-->
                                <div class="col-md-2">
                                    <label class="form-label">Lọc theo trạng thái</label>
                                    <select name="status" class="form-select">
                                        <c:set var="status" value="${requestScope.status}" />
                                        <option value="" ${empty status ? 'selected': ''}>Tất cả</option>
                                        <option value="saved" ${status == 'saved' ? 'selected': ''}>Tạm lưu</option>
                                        <option value="pending" ${status == 'pending' ? 'selected': ''}>Đang chờ</option>
                                        <option value="canceled" ${status == 'canceled' ? 'selected': ''}>Hủy bỏ</option>
                                        <option value="approved" ${status == 'approved' ? 'selected': ''}>Đã duyệt</option>
                                        <option value="rejected" ${status == 'rejected' ? 'selected': ''}>Từ chối</option>
                                    </select>
                                </div>
                                <!--Sort-->
                                <div class="col-md-4">
                                    <label class="form-label">Sắp xếp</label>
                                    <select name="sort" class="form-select">
                                        <c:set var="sort" value="${requestScope.sort}" />
                                        <option value="asc" ${sort=='asc'?'selected':''}>A → Z</option>
                                        <option value="desc" ${sort=='desc'?'selected':''}>Z → A</option>
                                        <option value="created" ${sort=='created'?'selected':''}>Ngày tạo yêu cầu</option>
                                        <option value="decided" ${sort=='decided'?'selected':''}>Ngày xử lý</option>
                                    </select>
                                </div>
                                <!--Keyword-->
                                <div class="col-md-4">
                                    <label class="form-label" >Nhập tên từ khóa</label>
                                    <input type="text" name="keyword" value="${requestScope.keyword}" class="form-control" placeholder="VD: Ielts">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-outline-primary">Áp dụng</button>
                                </div>
                                <div class="text-danger small mt-1">${requestScope.errorMessage}</div>
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
                                            <th>Ghi chú</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty requestScope.courses}">
                                            <tr><td colspan="4" class="text-center text-muted">Không có dữ liệu</td></tr>
                                        </c:if>
                                        <c:forEach var="c" items="${requestScope.courses}">
                                            <tr>
                                                <td><c:out value="${c.course.title}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.status=='saved'}"><span class="badge rounded-pill text-bg-secondary">Tạm lưu</span></c:when>
                                                        <c:when test="${c.status=='pending'}"><span class="badge rounded-pill text-bg-warning">Đang chờ</span></c:when>
                                                        <c:when test="${c.status=='approved'}"><span class="badge rounded-pill text-bg-success">Được duyệt</span></c:when>
                                                        <c:when test="${c.status=='rejected'}"><span class="badge rounded-pill text-bg-danger">Từ chối</span></c:when>
                                                        <c:when test="${c.status=='canceled'}"><span class="badge rounded-pill text-bg-primary">Hủy bỏ</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td><c:out value="${c.note}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.status=='pending'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/courseRequest" style="display:inline;" onsubmit="return cancelWithNote(this);">
                                                                <input type="hidden" name="requestId" value="${c.requestId}">
                                                                <input type="hidden" name="requestAction" value="cancel">
                                                                <input type="hidden" name="note" value="">

                                                                <input type="hidden" name="status"  value="${status}">
                                                                <input type="hidden" name="sort"    value="${sort}">
                                                                <input type="hidden" name="keyword" value="${keyword}">
                                                                <input type="hidden" name="page"    value="${page}">

                                                                <button class="btn btn-sm btn-outline-danger">Hủy yêu cầu</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${c.status=='rejected' || c.status=='canceled' || c.status=='saved'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/courseRequest" style="display:inline;">
                                                                <input type="hidden" name="requestId" value="${c.requestId}">
                                                                <input type="hidden" name="requestAction" value="resend">
                                                                <input type="hidden" name="status"  value="${status}">
                                                                <input type="hidden" name="sort"    value="${sort}">
                                                                <input type="hidden" name="keyword" value="${keyword}">
                                                                <input type="hidden" name="page"    value="${page}">
                                                                <c:if test="${sessionScope.student.parentId !=null}">
                                                                    <button class="btn btn-sm btn-primary">Gửi yêu cầu</button>
                                                                </c:if>
                                                                <c:if test="${sessionScope.student.parentId ==null}">
                                                                    <button class="btn btn-sm btn-secondary" disabled="">Chưa liên kết</button>
                                                                </c:if>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${c.status=='approved'}">
                                                            <form method="post" action="" style="display:inline;">

                                                                <button class="btn btn-sm btn-success">Xem chi tiết</button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${requestScope.totalPages > 1}">
                                <form action="${pageContext.request.contextPath}/courseRequest" method="get"
                                      class="d-flex justify-content-center gap-1 mt-4" style="margin-top:12px;">
                                    <input type="hidden" name="status"  value="${param.status}">
                                    <input type="hidden" name="sort"    value="${param.sort}">
                                    <input type="hidden" name="keyword" value="${param.keyword}">

                                    <c:if test="${requestScope.page > 1}">
                                        <button type="submit" name="page" value="${requestScope.page-1}" class="btn btn-outline-secondary btn-sm">«</button>
                                    </c:if>

                                    <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                                        <button type="submit" name="page" value="${i}"
                                                class="btn btn-sm ${i==requestScope.page ? 'btn-primary' : 'btn-outline-secondary'}">${i}</button>
                                    </c:forEach>

                                    <c:if test="${requestScope.page < requestScope.totalPages}">
                                        <button type="submit" name="page" value="${requestScope.page+1}" class="btn btn-outline-secondary btn-sm">»</button>
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

    function cancelWithNote(form) {
        if (!confirm('Bạn chắc muốn hủy yêu cầu này chứ?')) {
            return false;
        }

        var reason = prompt('Nhập lý do muốn hủy ?');
        if (reason !== null) {
            form.querySelector('input[name ="note"]').value = reason.trim();
        }
        return true;
    }
</script>
