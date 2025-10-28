<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem Flashcard Set</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-styles.css">

    </head>
    <body>
        <div class="modern-container">
            <div class="header-nav">
                <a href="dashboard?action=listSets" class="nav-link">
                    <i class="fas fa-home"></i>
                    Về trang chính
                </a>
            </div>

            <div class="main-content">
                <div class="set-header">
                    <h1 class="set-title">${set.title}</h1>
                    <p class="set-description">${set.description}</p>
                    <div class="set-meta">
                        <div class="meta-item">
                            <i class="fas fa-layer-group meta-icon"></i>
                            <span>${set.termCount} thẻ</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-user meta-icon"></i>
                            <span>${set.authorUsername}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-clock meta-icon"></i>
                            <span>Cập nhật: 
                                <c:choose>
                                    <c:when test="${not empty set.lastActivityAt}">
                                        <fmt:formatDate value="${set.lastActivityAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:when test="${not empty set.updatedAt}">
                                        <fmt:formatDate value="${set.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatDate value="${set.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="error-box">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <div class="action-buttons">
                    <c:if test="${set.studentId == sessionScope.user.userId}">
                        <a href="set?action=editSetForm&setId=${set.setId}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </a>
                        
                        <a href="set?action=deleteSet&setId=${set.setId}" 
                           class="btn btn-danger" 
                           onclick="return confirm('Bạn có chắc muốn xóa bộ thẻ này không?')">
                            <i class="fas fa-trash"></i> Xóa
                        </a>
                    </c:if>
                    <a href="flashcard-study?setId=${set.setId}" class="btn btn-success">
                        <i class="fas fa-play"></i> Học Flashcard
                    </a>
                </div>

                <div class="cards-section">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-list"></i>
                            Danh sách Flashcard
                        </h2>
                        <form action="dashboard" method="get" class="sort-form">
                            <input type="hidden" name="action" value="viewSet" />
                            <input type="hidden" name="setId" value="${set.setId}" />
                            <select name="sortOrder" class="sort-select" onchange="this.form.submit()">
                                <option value="">-- Sắp xếp --</option>
                                <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Thuật ngữ A → Z</option>
                                <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Thuật ngữ Z → A</option>
                            </select>
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${fn:length(cards) > 0}">
                            <div class="cards-grid">
                                <c:forEach var="card" items="${cards}" varStatus="st">
                                    <div class="card-item">
                                        <div class="card-number">${st.index + 1}</div>
                                        <div class="card-content">
                                            <div class="card-side">
                                                <div class="card-label">Thuật ngữ</div>
                                                <div class="card-text">${card.frontText}</div>
                                            </div>
                                            <div class="card-side">
                                                <div class="card-label">Định nghĩa</div>
                                                <div class="card-text">${card.backText}</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-layer-group empty-icon"></i>
                                <p class="empty-text">Chưa có thẻ nào</p>
                                <p class="empty-subtext">Bộ flashcard này hiện chưa có thẻ nào.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body>
</html>
