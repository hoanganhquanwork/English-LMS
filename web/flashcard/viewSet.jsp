<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
    <head>
    <div class="header-left">
        <a href="dashboard?action=listSets" class="nav-btn">⌂</a>
    </div>
    <title>View Flashcard Set</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-styles.css">
</head>
<body>
    <div class="container">

        <!-- Set header -->
        <div class="create-content">
            <div class="create-header">
                <h1 class="create-title">${set.title}</h1>
                <p class="create-subtitle">${set.description}</p>
            </div>

            <div class="set-actionsset">
                <c:if test="${set.studentId == sessionScope.user.userId}">
                    <a href="set?action=editSetForm&setId=${set.setId}" class="create-btn">Edit</a>
                    <a href="set?action=deleteSet&setId=${set.setId}" class="add-card-btn"
                       onclick="return confirm('Delete this set?')">Delete</a>
                </c:if>
            </div>

        </div>

        <div class="terms-header-row">
            <h2 class="terms-header">Flashcards</h2>
            <form action="dashboard" method="get" class="sort-bar">
                <input type="hidden" name="action" value="viewSet"/>
                <input type="hidden" name="setId" value="${set.setId}"/>
                <label for="sortOrder">Sắp xếp: </label>
                <select name="sortOrder" id="sortOrder" onchange="this.form.submit()">
                    <option value="">-- Chọn --</option>
                    <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Thuật ngữ A → Z</option>
                    <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Thuật ngữ Z → A</option>
                </select>
            </form>
        </div>

        <!-- List of flashcards -->
        <div class="terms-section">
            <c:if test="${fn:length(cards) > 0}">
                <div class="terms-list">
                    <c:forEach var="card" items="${cards}" varStatus="st">
                        <div class="term-item">
                            <div class="term-label">${st.index + 1}</div>
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
            </c:if>

            <!-- Nếu chưa có card -->
            <c:if test="${fn:length(cards) == 0}">
                <p class="empty-text">No flashcards in this set.</p>
            </c:if>
        </div>
    </div>
</body>
</html>
