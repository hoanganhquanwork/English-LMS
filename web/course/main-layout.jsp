<%-- 
    Document   : main-layout
    Created on : Oct 8, 2025, 12:00:26 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course Viewer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                padding-top: 64px;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header-course.jsp" />

        <div class="layout">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!-- Content -->
<!--            <main class="flex-fill p-4">
                <c:choose>
                    <c:when test="${selectedItem.itemType == 'lesson' && lesson.contentType == 'video'}">
                        <jsp:include page="video.jsp"/>
                    </c:when>
                    <c:when test="${selectedItem.itemType == 'lesson' && lesson.contentType == 'reading'}">
                        <jsp:include page="reading.jsp"/>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">Nội dung chưa được hỗ trợ.</div>
                    </c:otherwise>
                </c:choose>
            </main>-->
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
