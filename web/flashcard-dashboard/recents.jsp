<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>My Flashcards & Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-home-styles.css">
</head>
<body class="dashboard">
        <jsp:include page="/header.jsp" />

    <div class="add-set-btn">
        <a href="set?action=createForm">+</a>
    </div>

    <div class="recents-container">
        
        <!-- Search (Library) -->
        <form action="dashboard" method="get" class="search-bar">
            <input type="hidden" name="action" value="searchLibrary"/>
            <input type="text" name="keyword" placeholder="Search library sets"
                   value="${keyword}"/>
        </form>

        <!-- điều hướng -->
        <div class="nav-buttons">
            <a href="dashboard?action=viewAllLibrary" class="nav-btn">Library</a>
            <a href="dashboard?action=viewAllMySets" class="nav-btn">My Sets</a>
        </div>

        <!-- My Sets -->
        <div class="recents-header">My Flashcard Sets</div>
        <div class="recents-subtitle">Danh sách flashcard của bạn</div>

        <div class="flashcard-grid">
            <c:forEach var="set" items="${mySets}" varStatus="st">
                <c:if test="${st.index < 4}">
                    <div class="flashcard-card"
                         onclick="location.href = 'dashboard?action=viewSet&setId=${set.setId}'">
                        <div class="flashcard-title">${set.title}</div>
                        <div class="flashcard-meta">
                            ${set.termCount} terms • 
                            ${empty set.description ? "No description" : set.description} • 
                            by ${set.authorUsername}
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${empty mySets}">
                <p class="empty-msg">Bạn chưa có flashcard set nào.</p>
            </c:if>
        </div>

        <c:if test="${fn:length(mySets) > 0}">
            <a href="dashboard?action=viewAllMySets" class="view-all-link">Xem tất cả »</a>
        </c:if>

        <hr/>

        <!-- Library -->
        <div class="recents-header">Flashcard Library</div>
        <div class="recents-subtitle">Tất cả flashcard sets công khai</div>

        <div class="flashcard-grid">
            <c:forEach var="set" items="${librarySets}" varStatus="st">
                <c:if test="${st.index < 4}">
                    <div class="flashcard-card"
                         onclick="location.href = 'dashboard?action=viewSet&setId=${set.setId}'">
                        <div class="flashcard-title">${set.title}</div>
                        <div class="flashcard-meta">
                            ${set.termCount} terms • 
                            ${empty set.description ? "No description" : set.description} • 
                            by ${set.authorUsername}
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${empty librarySets}">
                <p class="empty-msg">Library hiện chưa có flashcard set nào.</p>
            </c:if>
        </div>

        <c:if test="${fn:length(librarySets) > 0}">
            <a href="dashboard?action=viewAllLibrary" class="view-all-link">Xem tất cả »</a>
        </c:if>

    </div>
                <jsp:include page="/footer.jsp" />

</body>
</html>
