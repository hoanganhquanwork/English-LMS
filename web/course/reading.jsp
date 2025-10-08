<%-- 
    Document   : reading
    Created on : Oct 8, 2025, 12:14:29 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .reading-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 40px 20px;
                line-height: 1.8;
                color: #2d2f31;
            }

            .reading-container h1 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 1.2rem;
                color: #000;
            }

            .reading-container p {
                font-size: 1.05rem;
                margin-bottom: 1rem;
            }

            .reading-actions {
                margin-top: 2rem;
                display: flex;
                justify-content: start;
            }

            .btn-complete {
                background-color: #0d6efd;
                color: #fff;
                font-weight: 500;
                padding: 10px 24px;
                border-radius: 6px;
                border: none;
            }

            .btn-complete:hover {
                background-color: #0b5ed7;
            }
        </style>
    </head>
    <body>
        <div class="reading-container">
            <!-- Tiêu đề bài học -->
            <h1>${lesson.title}</h1>

            <!-- Nội dung đọc (textContent trong DB) -->
            <div class="reading-body">
                ${lesson.textContent}
            </div>

            <!-- Nút hành động -->
            <div class="reading-actions">
                <form method="post" action="${pageContext.request.contextPath}/progress">
                    <input type="hidden" name="itemId" value="${selectedItem.moduleItemId}">
                    <button type="submit" class="btn-complete">Mark as completed</button>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
