<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Flashcard - EnglishLMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
        <link rel="stylesheet" href="<c:url value='/css/manager-flashcard.css?v=2712' />">
    </head>

    <body>
        <jsp:include page="../includes-manager/sidebar-manager.jsp" />

        <main>
            <div>
                <a href="manager-flashcard" class="btn btn-back"><i class="fa fa-arrow-left"></i> Quay lại</a>
            </div>

            <div class="header-detail" style="margin-top: 1rem;">

                <div class="header-info">
                    <h2>${set.title}</h2>
                    <p style="color:#6b7280;">${set.description}</p>

                    <div class="status-display">
                        <span style="font-weight:600;">Trạng thái:</span>
                        <c:choose>
                            <c:when test="${set.status eq 'public'}">
                                <span class="badge badge-public"><i class="fa fa-globe"></i> Public</span>
                            </c:when>
                            <c:when test="${set.status eq 'inactive'}">
                                <span class="badge badge-inactive"><i class="fa fa-eye-slash"></i> Inactive</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-private"><i class="fa fa-lock"></i> Private</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="action-group" style="margin-top:10px;">
                        <c:choose>
                            <c:when test="${set.status eq 'public'}">
                                <form  action="flashcard-detail" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="hideSet">
                                    <input type="hidden" name="setId" value="${set.setId}">
                                    <button type="submit" class="btn btn-hide"><i class="fa fa-eye-slash"></i> Ẩn bộ này</button>
                                </form>
                            </c:when>
                            <c:when test="${set.status eq 'inactive'}">
                                <form action="flashcard-detail" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="activateSet">
                                    <input type="hidden" name="setId" value="${set.setId}">
                                    <button type="submit" class="btn btn-show"><i class="fa fa-rotate-right"></i> Hiển thị lại</button>
                                </form>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="flashcard-list">
                <c:forEach var="card" items="${cards}" varStatus="st">
                    <div class="flashcard-item">
                        <div class="flashcard-content">
                            <div class="term-box">
                                <div class="term-title">TERM:</div>
                                <div class="term-text">${card.frontText}</div>
                            </div>
                            <div class="definition-box">
                                <div class="definition-title">DEFINITION:</div>
                                <div class="definition-text">${card.backText}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty cards}">
                    <p style="color: gray; margin-top: 2rem;">Bộ flashcard này chưa có thẻ nào.</p>
                </c:if>
            </div>
        </main>

    </body>
</html>