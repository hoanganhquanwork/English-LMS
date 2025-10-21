<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
  String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <title>Quản lý Báo lỗi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
        <%@ include file="admin_sidebar.jsp" %>
    </head>
    <body>
        <div class="main-content">
            <h4 class="fw-bold mb-3"><i class="bi bi-bug me-2"></i>Quản lý báo lỗi</h4>

            <div class="card card-panel">
                <div class="card-body">
                    <form action="<%=ctx%>/admin/report-list" method="get" class="row g-2 mb-3">
                        <c:choose>
                            <c:when test="${not empty param.role or not empty param.typeId or not empty param.status}">
                                <div class="col-md-2">
                                    <select name="size" class="form-select">
                                        <option value="10">Phân trang</option>
                                        <option value="20" ${size=='20'?'selected':''}>20/trang</option>
                                        <option value="30" ${size=='30'?'selected':''}>30/trang</option>
                                        <option value="50" ${size=='50'?'selected':''}>50/trang</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select name="role" class="form-select">
                                        <option value="">Tất cả vai trò</option>
                                        <c:forEach var="r" items="${availableRoles}">
                                            <option value="${r}" ${param.role==r?'selected':''}>${r}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select name="typeId" class="form-select">
                                        <option value="">Tất cả loại lỗi</option>
                                        <c:forEach var="t" items="${availableTypes}">
                                            <option value="${t.typeId}" ${param.typeId==t.typeId?'selected':''}>
                                                ${t.role} - ${t.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select name="status" class="form-select">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="pending" ${param.status=='pending'?'selected':''}>Chờ xử lý</option>
                                        <option value="in_progress" ${param.status=='in_progress'?'selected':''}>Đang xử lý</option>
                                        <option value="resolved" ${param.status=='resolved'?'selected':''}>Đã xử lý</option>
                                        <option value="rejected" ${param.status=='rejected'?'selected':''}>Từ chối</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-filter w-100" type="submit">
                                        <i class="bi bi-funnel me-1"></i>Lọc
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <a href="<%=ctx%>/admin/report-list" class="btn btn-outline-secondary w-100">
                                        <i class="bi bi-x-circle me-1"></i> Xóa bộ lọc
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-md-2">
                                    <select name="size" class="form-select">
                                        <option value="10">Phân trang</option>
                                        <option value="20" ${size=='20'?'selected':''}>20/trang</option>
                                        <option value="30" ${size=='30'?'selected':''}>30/trang</option>
                                        <option value="50" ${size=='50'?'selected':''}>50/trang</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select name="role" class="form-select">
                                        <option value="">Tất cả vai trò</option>
                                        <c:forEach var="r" items="${availableRoles}">
                                            <option value="${r}" ${param.role==r?'selected':''}>${r}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select name="typeId" class="form-select">
                                        <option value="">Tất cả loại lỗi</option>
                                        <c:forEach var="t" items="${availableTypes}">
                                            <option value="${t.typeId}" ${param.typeId==t.typeId?'selected':''}>
                                                ${t.role} - ${t.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select name="status" class="form-select">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="pending" ${param.status=='pending'?'selected':''}>Chờ xử lý</option>
                                        <option value="in_progress" ${param.status=='in_progress'?'selected':''}>Đang xử lý</option>
                                        <option value="resolved" ${param.status=='resolved'?'selected':''}>Đã xử lý</option>
                                        <option value="rejected" ${param.status=='rejected'?'selected':''}>Từ chối</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-filter w-100" type="submit">
                                        <i class="bi bi-funnel me-1"></i>Lọc
                                    </button>
                                </div>

                            </c:otherwise>
                        </c:choose>
                    </form>


                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Người gửi</th>
                                    <th>Vai trò</th>
                                    <th>Loại lỗi</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày gửi</th>
                                    <th>Ngày cập nhật</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reports}">
                                    <tr>
                                        <td class="fw-semibold">${r.reporterName}</td>
                                        <td><span class="badge role-badge">${r.reporterRole}</span></td>
                                        <td>${r.typeName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fn:length(r.description) > 70}">
                                                    ${fn:escapeXml(fn:substring(r.description, 0, 70))}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:escapeXml(r.description)}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status=='pending'}"><span class="badge bg-warning text-dark">Chờ xử lý</span></c:when>
                                                <c:when test="${r.status=='in_progress'}"><span class="badge bg-info text-dark">Đang xử lý</span></c:when>
                                                <c:when test="${r.status=='resolved'}"><span class="badge bg-success">Đã xử lý</span></c:when>
                                                <c:when test="${r.status=='rejected'}"><span class="badge bg-danger">Từ chối</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${r.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="cdt"/>
                                            <fmt:formatDate value="${cdt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${r.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="upt"/>
                                            <fmt:formatDate value="${upt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td class="text-end">
                                            <a href="<%=ctx%>/admin/report-detail?id=${r.reportId}"
                                               class="btn btn-sm btn-outline-primary"
                                               target="_blank"
                                               rel="noopener noreferrer">
                                                <i class="bi bi-eye"></i> Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty reports}">
                                    <tr><td colspan="6" class="text-center text-muted py-4">Không có báo lỗi nào</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages>1}">
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <div class="small text-muted">Trang ${page}/${totalPages}</div>
                            <nav>
                                <ul class="pagination pagination-sm mb-0">
                                    <c:url var="baseUrl" value="/admin/report-list">
                                        <c:param name="role" value="${param.role}"/>
                                        <c:param name="typeId" value="${param.typeId}"/>
                                        <c:param name="size" value="${size}"/>
                                    </c:url>
                                    <li class="page-item ${page==1?'disabled':''}">
                                        <a class="page-link" href="${baseUrl}&page=${page-1}">Trước</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p==page?'active':''}">
                                            <a class="page-link" href="${baseUrl}&page=${p}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${page==totalPages?'disabled':''}">
                                        <a class="page-link" href="${baseUrl}&page=${page+1}">Sau</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>
