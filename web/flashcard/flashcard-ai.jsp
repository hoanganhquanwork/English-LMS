<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo Flashcard bằng Gemini AI</title>
        <link rel="stylesheet" href="<c:url value='/css/manager-style.css?v=2'/>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            .ai-container {
                max-width: 800px;
                margin: 40px auto;
                background: #fff;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }
            .ai-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }
            .ai-header h2 {
                color: var(--brand, #4f46e5);
                text-align: center;
                flex: 1;
            }
            .btn-home {
                text-decoration: none;
                background-color: var(--brand, #4f46e5);
                color: #fff;
                padding: 8px 14px;
                border-radius: 6px;
                font-size: 0.9rem;
                transition: 0.2s;
            }
            .btn-home:hover {
                background-color: var(--brand-dark, #3730a3);
            }
            .ai-form input, .ai-form textarea {
                width: 100%;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 10px;
                font-size: 1rem;
                margin-bottom: 16px;
            }
            .ai-form button {
                display: block;
                width: 100%;
                background-color: var(--brand, #4f46e5);
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 16px;
                font-size: 1rem;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .ai-form button:hover {
                background-color: var(--brand-dark, #3730a3);
            }
            .alert {
                margin-top: 16px;
                padding: 12px;
                border-radius: 6px;
            }
            .alert.success {
                background-color: #dcfce7;
                color: #166534;
                border: 1px solid #16a34a;
            }
            .alert.error {
                background-color: #fee2e2;
                color: #991b1b;
                border: 1px solid #ef4444;
            }
            .generated-section {
                margin-top: 30px;
            }
            .generated-section ul {
                list-style: none;
                padding-left: 0;
            }
            .generated-section li {
                background: #f9fafb;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 10px 14px;
                margin-bottom: 10px;
            }
            .ai-actions {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                gap: 14px;
            }
            .btn-nav {
                text-decoration: none;
                background-color: var(--brand, #4f46e5);
                color: #fff;
                padding: 8px 14px;
                border-radius: 6px;
                font-size: 0.95rem;
                transition: 0.2s;
            }
            .btn-nav:hover {
                background-color: var(--brand-dark, #3730a3);
            }
        </style>
    </head>

    <body>
        <main class="main-content">
            <div class="ai-container">

                <div class="ai-header">
                    <a href="<c:url value='/dashboard'/>" class="btn-home"><i class="fa fa-home"></i></a>
                    <h2> Tạo Flashcard bằng AI</h2>
                </div>
                <form action="${pageContext.request.contextPath}/flashcard-ai" method="post" class="ai-form">
                    <input type="text" name="set_title" placeholder="Nhập tên bộ flashcard (VD: English Tenses)" required>
                    <textarea name="prompt" rows="6"
                              placeholder="Nhập chủ đề hoặc nội dung để AI tạo flashcards..." required></textarea>
                    <button type="submit">Tạo Flashcard bằng AI</button>
                </form>
                <c:if test="${not empty message}">
                    <div class="alert success">${message}</div>

                    <div class="ai-actions">
                        <a href="<c:url value='/dashboard?action=listSets'/>" class="btn-nav"> Quay lại danh sách Set</a>
                        <c:if test="${not empty setId}">
                            <a href="<c:url value='/dashboard?action=viewSet&setId=${setId}'/>" class="btn-nav">
                                 Xem bộ vừa tạo
                            </a>
                        </c:if>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert error">${error}</div>
                </c:if>

                <c:if test="${not empty generatedCards}">
                    <div class="generated-section">
                        <h3>Danh sách Flashcard được AI tạo:</h3>
                        <ul>
                            <c:forEach var="f" items="${generatedCards}">
                                <li><b>${f.frontText}</b> → ${f.backText}</li>
                                    </c:forEach>
                        </ul>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>