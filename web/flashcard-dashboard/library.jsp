<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <title>Flashcard Library</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-home-styles.css">
    </head>
    <body class="dashboard">
        <jsp:include page="/header.jsp" />

        <div class="add-set-btn">
            <a href="set?action=createForm">+</a>
        </div>
            <div class="function-header">Flashcard Library</div>
        <!-- Search Library -->
        <form action="dashboard" method="get" class="search-bar">
            <input type="hidden" name="action" value="searchLibrary"/>
            <input type="text" name="keyword" placeholder="Search library sets"
                   value="${keyword}"/>
        </form>

        <!-- điều hướng -->
        <div class="nav-buttons">
            <a href="dashboard?action=viewAllMySets" class="nav-btn">My Sets</a>
            <a href="dashboard?action=listSets" class="nav-btn">Dashboard</a>
        </div>

        <div class="recents-container">
            <div class="recents-header-row">
                <!-- Sort dropdown -->
                <c:if test="${empty keyword}">
                    <form action="dashboard" method="get" class="sort-bar">
                        <input type="hidden" name="action" value="viewAllLibrary"/>
                        <label for="sortOrder">Sắp xếp: </label>
                        <select name="sortOrder" id="sortOrder" onchange="this.form.submit()">
                            <option value="">-- Chọn --</option>
                            <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Tên A → Z</option>
                            <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Tên Z → A</option>
                        </select>
                    </form>
                </c:if>

            </div>
            <div class="recents-subtitle">Tất cả flashcard sets công khai</div>

            <!-- Set Libary -->
            <div class="flashcard-grid">
                <c:forEach var="set" items="${librarySets}">
                    <div class="flashcard-card"
                         onclick="location.href = 'dashboard?action=viewSet&setId=${set.setId}'">
                        <div class="flashcard-title">${set.title}</div>
                        <div class="flashcard-meta">
                            ${set.termCount} terms • 
                            ${empty set.description ? "No description" : set.description} • 
                            by ${set.authorUsername}
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty librarySets}">
                    <p class="empty-msg">Library hiện chưa có flashcard set nào.</p>
                </c:if>
            </div>
        </div>
        <jsp:include page="/footer.jsp" />

    </body>
</html>
