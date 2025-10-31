<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("role");
    String headerPath = "";
    String cssPath = "";
    String bodyClass = "";
    String wrapperStart = "";
    String wrapperEnd = "";

    
    if ("Manager".equals(role)) {
        headerPath = "../views-manager/includes-manager/sidebar-manager.jsp";
        cssPath = ctx + "/css/manager-style.css?v=63";
        
    } else if ("Instructor".equals(role)) {
        headerPath = "../teacher/sidebar.jsp";
        cssPath = ctx + "/css/sidebar.css";
    } else {
        headerPath = "../header.jsp";
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gửi báo lỗi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
        <%
            if (!cssPath.isEmpty()) {
        %>
        <link rel="stylesheet" href="<%= cssPath %>">
        <%
            }
        %>
    </head>

    <body class="<%= bodyClass %>">
        <!-- Header động -->
        <jsp:include page="<%= headerPath %>" />

        <%= wrapperStart %>

        <div class="container mt-4" style="max-width: 760px;">
            <h3 class="fw-bold text-primary mb-3">Gửi báo lỗi / Yêu cầu hỗ trợ</h3>

            <c:if test="${not empty sessionScope.flash}">
                <div class="alert alert-info">${sessionScope.flash}</div>
                <c:remove var="flash" scope="session"/>
            </c:if>

            <form action="createReport" method="post" class="border rounded p-3 bg-white">
                <input type="hidden" name="action" value="create"/>

                <div class="mb-3">
                    <label class="form-label">Loại lỗi</label>
                    <select name="typeId" class="form-select" required>
                        <option value="">-- Chọn loại lỗi --</option>
                        <c:forEach var="t" items="${reportTypes}">
                            <option value="${t.typeId}">${t.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mô tả chi tiết</label>
                    <textarea name="description" rows="5" class="form-control" required></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trang gặp lỗi (nếu có)</label>
                    <input name="pageUrl" class="form-control" placeholder="/student/dashboard"/>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-primary fw-semibold">Gửi báo lỗi</button>            
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
            </form>
        </div>

        <%= wrapperEnd %>
    </body>
</html>
