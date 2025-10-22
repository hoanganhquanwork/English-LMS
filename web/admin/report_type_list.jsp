<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <title>Quản lý loại báo lỗi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
        <%@ include file="admin_sidebar.jsp" %>
    </head>
    <body>
        <div class="main-content">
            <h4 class="fw-bold mb-4">Quản lý loại báo lỗi</h4>

            <form action="<%=ctx%>/AdminReportTypeList" method="get" class="row g-2 mb-3">
                <div class="col-md-2">
                    <select name="size" class="form-select">
                        <option value="10" ${size == 10 ? 'selected' : ''}>10 kết quả/trang</option>
                        <option value="20" ${size == 20 ? 'selected' : ''}>20 kết quả/trang</option>
                        <option value="30" ${size == 30 ? 'selected' : ''}>30 kết quả/trang</option>
                        <option value="50" ${size == 50 ? 'selected' : ''}>50 kết quả/trang</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="role" class="form-select">
                        <option value="">-- Vai trò --</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r}" ${param.role == r ? 'selected' : ''}>${r}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="status" class="form-select">
                        <option value="">-- Trạng thái --</option>
                        <option value="1" ${param.status=='1'?'selected':''}>Đang hoạt động</option>
                        <option value="0" ${param.status=='0'?'selected':''}>Ngưng hoạt động</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="text" class="form-control" name="keyword"
                           placeholder="Từ khóa (tên loại lỗi)"
                           value="${fn:escapeXml(param.keyword)}"/>
                </div>
                <div class="col-md-1 d-flex gap-2">
                    <button class="btn btn-filter w-100" type="submit" title="Lọc">
                        <i class="bi bi-funnel"></i>
                    </button>
                </div>
                <div class="col-md-1 d-flex gap-2">
                    <a href="<%=ctx%>/AdminReportTypeList" class="btn btn-outline-secondary w-100" title="Xóa bộ lọc">
                        <i class="bi bi-x-circle"></i>
                    </a>
                </div>
            </form>


            <!-- Nút thêm mới -->
            <div class="mb-3 text-end">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#editTypeModal"
                        onclick="clearForm()">
                    <i class="bi bi-plus-circle"></i> Thêm lỗi thường gặp
                </button>
            </div>

            <!-- Bảng -->
            <div class="card card-panel">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Tên loại lỗi</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${reportTypes}">
                                    <tr>
                                        <td class="fw-semibold">${t.name}</td>
                                        <td><span class="badge role-badge">${t.role}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${t.active}">
                                                    <span class="badge bg-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Ngưng hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-outline-primary me-1"
                                                    data-bs-toggle="modal" data-bs-target="#editTypeModal"
                                                    onclick="fillForm(${t.typeId}, '${fn:escapeXml(t.name)}', '${t.role}', ${t.active})">
                                                <i class="bi bi-pencil-square"></i> Sửa
                                            </button>

                                            <c:choose>
                                                <c:when test="${t.active}">
                                                    <a href="<%=ctx%>/AdminReportTypeStatus?id=${t.typeId}&action=deactivate"
                                                       class="btn btn-sm btn-outline-warning"
                                                       onclick="return confirm('Bạn muốn vô hiệu hóa loại lỗi này?');">
                                                        <i class="bi bi-pause-circle"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="<%=ctx%>/AdminReportTypeStatus?id=${t.typeId}&action=activate"
                                                       class="btn btn-sm btn-outline-success"
                                                       onclick="return confirm('Bạn muốn kích hoạt loại lỗi này?');">
                                                        <i class="bi bi-play-circle"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty reportTypes}">
                                    <tr><td colspan="4" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <div class="small text-muted">Trang ${page} / ${totalPages}</div>
                                <nav>
                                    <ul class="pagination pagination-sm mb-0">
                                        <c:url var="baseUrl" value="/AdminReportTypeList">
                                            <c:param name="role" value="${param.role}"/>
                                            <c:param name="status" value="${param.status}"/>
                                            <c:param name="keyword" value="${param.keyword}"/>
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
            <div class="modal fade" id="editTypeModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post" action="<%=ctx%>/AdminReportTypeEdit">
                            <div class="modal-header">
                                <h5 class="modal-title">Thêm / Chỉnh sửa loại báo lỗi</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="typeId" id="typeId">
                                <div class="mb-3">
                                    <label class="form-label">Tên loại lỗi</label>
                                    <input class="form-control" name="name" id="typeName" required/>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Vai trò áp dụng</label>
                                    <select class="form-select" name="role" id="typeRole" required>
                                        <option value="">-- Chọn vai trò --</option>
                                        <c:forEach var="r" items="${roles}">
                                            <option value="${r}">${r}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeActive" name="isActive" value="1" checked>
                                    <label class="form-check-label" for="typeActive">Kích hoạt</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-save me-1"></i>Lưu
                                </button>
                                <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                           function fillForm(id, name, role, active) {
                                                               document.getElementById('typeId').value = id;
                                                               document.getElementById('typeName').value = name;
                                                               document.getElementById('typeRole').value = role;
                                                               document.getElementById('typeActive').checked = active;
                                                           }

                                                           function clearForm() {
                                                               document.getElementById('typeId').value = '';
                                                               document.getElementById('typeName').value = '';
                                                               document.getElementById('typeRole').value = '';
                                                               document.getElementById('typeActive').checked = true;
                                                           }
        </script>
    </body>
</html>
