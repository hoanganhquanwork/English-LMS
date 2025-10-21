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
        <title>Danh sách báo lỗi đã gửi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container mt-5">
            <h3 class="fw-bold text-primary mb-4"><i class="bi bi-bug me-2"></i>Danh sách báo lỗi của bạn</h3>

            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Loại lỗi</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th>Phản hồi từ Admin</th>
                                    <th>Ngày gửi</th>
                                    <th>Ngày cập nhật</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reports}">
                                    <tr>
                                        <td class="fw-semibold">${r.typeName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fn:length(r.description) > 2000}">
                                                    ${fn:escapeXml(fn:substring(r.description, 0, 2000))}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:escapeXml(r.description)}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'pending'}"><span class="badge bg-warning text-dark">Đang chờ</span></c:when>
                                                <c:when test="${r.status == 'in_progress'}"><span class="badge bg-info text-dark">Đang xử lý</span></c:when>
                                                <c:when test="${r.status == 'resolved'}"><span class="badge bg-success">Đã xử lý</span></c:when>
                                                <c:when test="${r.status == 'rejected'}"><span class="badge bg-danger">Bị từ chối</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">${r.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:choose>
                                                <c:when test="${fn:length(r.description) > 2000}">
                                                    ${fn:escapeXml(fn:substring(r.adminNote, 0, 2000))}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:escapeXml(r.adminNote)}
                                                </c:otherwise>
                                            </c:choose></td>
                                        <td>
                                            <fmt:parseDate value="${r.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="cdt"/>
                                            <fmt:formatDate value="${cdt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${r.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="upt"/>
                                            <fmt:formatDate value="${upt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty reports}">
                                    <tr><td colspan="5" class="text-center text-muted py-4">Chưa có báo lỗi nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="small text-muted">Trang ${page} / ${totalPages}</div>
                            <nav>
                                <ul class="pagination pagination-sm mb-0">
                                    <c:url var="baseUrl" value="/reportList"/>
                                    <li class="page-item ${page==1?'disabled':''}">
                                        <a class="page-link" href="${baseUrl}?page=${page-1}&size=${size}">Trước</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p==page?'active':''}">
                                            <a class="page-link" href="${baseUrl}?page=${p}&size=${size}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${page==totalPages?'disabled':''}">
                                        <a class="page-link" href="${baseUrl}?page=${page+1}&size=${size}">Sau</a>
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
