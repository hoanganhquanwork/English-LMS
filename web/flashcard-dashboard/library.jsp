<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flashcard Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-home-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
   
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="modern-container">
        <div class="header-section">
            <h1 class="page-title">
                <i class="fas fa-book-open" style="color: #667eea; margin-right: 15px;"></i>
                Flashcard Library
            </h1>
            <p class="page-subtitle">Khám phá các bộ flashcard công khai từ cộng đồng</p>
            
            <!-- Search -->
            <form action="dashboard" method="get" class="search-container">
                <input type="hidden" name="action" value="searchLibrary"/>
                <i class="fas fa-search search-icon"></i>
                <input type="text" name="keyword" class="search-input" 
                       placeholder="Tìm kiếm flashcard sets..." value="${keyword}"/>
            </form>
            
            <!-- Navigation -->
            <div class="nav-tabs">
                <a href="dashboard?action=viewAllMySets" class="nav-tab">
                    <i class="fas fa-user" style="margin-right: 8px;"></i>My Sets
                </a>
                <a href="dashboard?action=listSets" class="nav-tab">
                    <i class="fas fa-home" style="margin-right: 8px;"></i>Dashboard
                </a>
            </div>
            
            <!-- Sort -->
            <c:if test="${empty keyword}">
                <div class="sort-container">
                    <form action="dashboard" method="get" style="display: inline;">
                        <input type="hidden" name="action" value="viewAllLibrary"/>
                        <select name="sortOrder" class="sort-select" onchange="this.form.submit()">
                            <option value="">-- Sắp xếp theo tên --</option>
                            <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>A → Z</option>
                            <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Z → A</option>
                        </select>
                    </form>
                </div>
            </c:if>
        </div>
        
        <!-- Cards Grid -->
        <div class="cards-grid">
            <c:forEach var="set" items="${librarySets}">
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
            </c:forEach>
            
            <c:if test="${empty librarySets}">
                <div class="empty-state">
                    <i class="fas fa-book-open empty-icon"></i>
                    <p class="empty-text">Chưa có flashcard set nào</p>
                    <p class="empty-subtext">Library hiện tại chưa có bộ flashcard công khai nào.</p>
                </div>
            </c:if>
        </div>
    </div>
    
    <!-- Floating Add Button -->
    <a href="set?action=createForm" class="floating-add-btn">
        <i class="fas fa-plus"></i>
    </a>
    
    <jsp:include page="/footer.jsp" />
</body>
</html>
