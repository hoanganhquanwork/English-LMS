<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Xem Flashcard Set</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-styles.css?v=22" />
    </head>

    <body>
        <div class="header-left">
            <a href="dashboard?action=listSets" class="nav-btn" title="Về trang chính">
                <i class="fa fa-home"></i>
            </a>
        </div>

        <div class="container">
            <div class="create-content">
                <div class="create-header">
                    <h1 class="create-title">${set.title}</h1>
                    <p class="create-subtitle">${set.description}</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="error-box">
                        <i class="fa fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <div class="set-actions">
                    <c:if test="${set.studentId == sessionScope.user.userId}">
                        <a href="set?action=editSetForm&setId=${set.setId}" class="create-btn">
                            Chỉnh sửa
                        </a>
                        
                        <a href="set?action=deleteSet&setId=${set.setId}" 
                           class="add-card-btn" 
                           onclick="return confirm('Bạn có chắc muốn xóa bộ thẻ này không?')">
                            Xóa
                        </a>
                    </c:if>
                    <a href="flashcard-study?setId=${set.setId}" class="study-btn">
                        Học Flashcard
                    </a>
                </div>
            </div>

            <div class="terms-header-row">
                <h2 class="terms-header">Danh sách Flashcard</h2>
                <form action="dashboard" method="get" class="sort-bar">
                    <input type="hidden" name="action" value="viewSet" />
                    <input type="hidden" name="setId" value="${set.setId}" />
                    <label for="sortOrder">Sắp xếp:</label>
                    <select name="sortOrder" id="sortOrder" onchange="this.form.submit()">
                        <option value="">-- Chọn --</option>
                        <option value="asc"  ${param.sortOrder == 'asc'  ? 'selected' : ''}>Thuật ngữ A → Z</option>
                        <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Thuật ngữ Z → A</option>
                    </select>
                </form>
            </div>

            <div class="terms-section">
                <c:choose>
                    <c:when test="${fn:length(cards) > 0}">
                        <div class="terms-list">
                            <c:forEach var="card" items="${cards}" varStatus="st">
                                <div class="term-item">
                                    <div class="term-label">#${st.index + 1}</div>
                                    <div class="term-content-row">
                                        <div class="term-col">
                                            <span class="term-title">TERM:</span>
                                            <span class="term-text">${card.frontText}</span>
                                        </div>
                                        <div class="term-col">
                                            <span class="term-title">DEFINITION:</span>
                                            <span class="term-text">${card.backText}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-text">Chưa có thẻ nào trong bộ này.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </body>
</html>
