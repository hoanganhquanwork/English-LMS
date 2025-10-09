<%-- 
    Document   : lessonSuccess
    Created on : Oct 5, 2025, 4:45:01 PM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bài học đã tạo thành công</title>
</head>
<body>
    <h2>Bài học video đã được tạo thành công!</h2>

    <c:if test="${not empty lesson}">
        <p><strong>Tiêu đề:</strong> ${lesson.title}</p>
        <p><strong>Loại:</strong> ${lesson.contentType}</p>
        <p><strong>Thời lượng:</strong> ${lesson.durationSec} giây</p>
        <div>
            <iframe width="560" height="315" 
                    src="${lesson.videoUrl}" 
                    frameborder="0" allowfullscreen></iframe>
        </div>
    </c:if>

    <a href="module.jsp?courseId=${param.courseId}">Quay lại danh sách module</a>
</body>
</html>
