<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Flashcards</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-home-styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    </head>
    <body class="dashboard">
        <jsp:include page="/header.jsp" />

        <div class="modern-container">
            <div class="header-section">
                <h1 class="page-title">
                    <i class="fas fa-home" style="color: #667eea; margin-right: 15px;"></i>
                    Flashcard
                </h1>
                <p class="page-subtitle">Tổng quan các bộ flashcard của bạn và thư viện công khai</p>

                <!-- Search -->
                <form action="dashboard" method="get" class="search-container">
                    <input type="hidden" name="action" value="searchLibrary"/>
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" name="keyword" class="search-input" 
                           placeholder="Tìm kiếm trong thư viện..." value="${keyword}"/>
                </form>

                <!-- Navigation -->
                <div class="nav-tabs">
                    <a href="dashboard?action=viewAllLibrary" class="nav-tab">
                        <i class="fas fa-book-open" style="margin-right: 8px;"></i>Thư viện
                    </a>
                    <a href="dashboard?action=viewAllMySets" class="nav-tab">
                        <i class="fas fa-user" style="margin-right: 8px;"></i>Flashcard của tôi
                    </a>
                </div>
            </div>

            <!-- My Sets Section -->
            <div class="section-container">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-layer-group"></i>
                        Flashcard của tôi                </h2>
                        <c:if test="${fn:length(mySets) > 0}">
                        <a href="dashboard?action=viewAllMySets" class="view-all-link">
                            Xem tất cả <i class="fas fa-arrow-right"></i>
                        </a>
                    </c:if>
                </div>
                <p class="section-subtitle">Danh sách flashcard của bạn</p>

                <div class="cards-grid">
                    <c:forEach var="set" items="${mySets}" varStatus="st">
                        <c:if test="${st.index < 4}">
                            <div class="card" onclick="location.href = 'dashboard?action=viewSet&setId=${set.setId}'">
                                <div class="status-badge status-${set.status}">
                                    <c:choose>
                                        <c:when test="${set.status == 'private'}">
                                            <i class="fas fa-lock"></i> Riêng tư
                                        </c:when>
                                        <c:when test="${set.status == 'public'}">
                                            <i class="fas fa-globe"></i> Công khai
                                        </c:when>
                                    </c:choose>
                                </div>
                                <h3 class="card-title">${set.title}</h3>
                                <p class="card-description">
                                    ${empty set.description ? "Không có mô tả" : set.description}
                                </p>
                                <div class="card-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-layer-group meta-icon"></i>
                                        <span>${set.termCount} thẻ</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-user meta-icon"></i>
                                        <span>${set.authorUsername}</span>
                                    </div>
                                    <c:if test="${not empty set.lastActivityAt}">
                                        <div class="meta-item">
                                            <i class="fas fa-clock meta-icon"></i>
                                            <span><fmt:formatDate value="${set.lastActivityAt}" pattern="dd/MM/yyyy" /></span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${empty mySets}">
                        <div class="empty-state">
                            <i class="fas fa-layer-group empty-icon"></i>
                            <p class="empty-text">Chưa có bộ flashcard nào</p>
                            <p class="empty-subtext">Bạn chưa tạo bộ flashcard nào. Hãy tạo bộ đầu tiên!</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Library Section -->
            <div class="section-container">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-book-open"></i>
                        Thư viện Flashcard 
                    </h2>
                    <c:if test="${fn:length(librarySets) > 0}">
                        <a href="dashboard?action=viewAllLibrary" class="view-all-link">
                            Xem tất cả <i class="fas fa-arrow-right"></i>
                        </a>
                    </c:if>
                </div>
                <p class="section-subtitle">Tất cả các bộ flashcard công khai</p>

                <div class="cards-grid">
                    <c:forEach var="set" items="${librarySets}" varStatus="st">
                        <c:if test="${st.index < 4}">
                            <div class="card" onclick="location.href = 'dashboard?action=viewSet&setId=${set.setId}'">
                                <h3 class="card-title">${set.title}</h3>
                                <p class="card-description">
                                    ${empty set.description ? "Không có mô tả" : set.description}
                                </p>
                                <div class="card-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-layer-group meta-icon"></i>
                                        <span>${set.termCount} thẻ</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-user meta-icon"></i>
                                        <span>${set.authorUsername}</span>
                                    </div>
                                    <c:if test="${not empty set.lastActivityAt}">
                                        <div class="meta-item">
                                            <i class="fas fa-clock meta-icon"></i>
                                            <span><fmt:formatDate value="${set.lastActivityAt}" pattern="dd/MM/yyyy" /></span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${empty librarySets}">
                        <div class="empty-state">
                            <i class="fas fa-book-open empty-icon"></i>
                            <p class="empty-text">Chưa có bộ flashcard nào</p>
                            <p class="empty-subtext">Library hiện tại chưa có bộ flashcard công khai nào.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Floating Add Button -->
        <a href="set?action=createForm" class="floating-add-btn">
            <i class="fas fa-plus"></i>
        </a>

        <jsp:include page="/footer.jsp" />
    </body>
</html>
