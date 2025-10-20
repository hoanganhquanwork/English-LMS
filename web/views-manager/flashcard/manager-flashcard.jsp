<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Quản lý Flashcard Sets - EnglishLMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="<c:url value='/css/manager-flashcard.css?v=227' />">
    </head>

    <body>
        <button class="menu-toggle" onclick="toggleSidebar()">
            <i class="fa fa-bars"></i>
        </button>
        <jsp:include page="../includes-manager/sidebar-manager.jsp" />

        <main>
            <div class="header">
                <h2>Quản lý Flashcard Sets</h2>
            </div>

            <form class="filter-bar" method="get" action="manager-flashcard">
                <div class="search-box">
                    <input type="text" name="keyword" placeholder="Tìm kiếm flashcard set..." value="${keyword}">
                </div>
                <select class="sort-select" name="sort" onchange="this.form.submit()">
                    <option value="newest" ${sortType == 'newest' ? 'selected' : ''}>Mới nhất</option>
                    <option value="oldest" ${sortType == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                    <option value="az" ${sortType == 'az' ? 'selected' : ''}>A → Z</option>
                    <option value="za" ${sortType == 'za' ? 'selected' : ''}>Z → A</option>
                </select>
            </form>

            <div class="deck-grid">
                <c:forEach var="set" items="${sets}">
                    <div class="deck-card">
                        <h3 class="deck-title">${set.title}</h3>
                        <p>${set.description}</p>
                        <p class="deck-meta">${set.termCount} thẻ • by ${set.authorUsername}</p>

                        <div class="deck-actions">
                            <a href="flashcard-detail?setId=${set.setId}" class="btn btn-view"> <i class="fas fa-eye"></i></a>
                            <form action="manager-flashcard" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="deleteSet">
                                <input type="hidden" name="setId" value="${set.setId}">
                                <button type="submit" class="btn btn-delete2"><i class="fas fa-trash"></i></button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty sets}">
                    <p style="color: gray; margin-top: 2rem;">Không có flashcard set nào được tìm thấy.</p>
                </c:if>
            </div>
        </main>
        <div id="confirmModal" class="modal" style="display:none;">
            <div class="modal-content">
                <h3 id="modalTitle">Xóa Flashcard Set?</h3>
                <p>Bạn có chắc chắn muốn xóa bộ này không?</p>
                <div class="modal-buttons">
                    <button class="btn btn-delete" onclick="confirmDelete()">Xóa</button>
                    <button class="btn btn-view" onclick="closeModal()">Hủy</button>
                </div>
            </div>
        </div>

        <script>
            let currentDeck = "";
            function openModal(deck) {
                currentDeck = deck;
                document.getElementById("modalTitle").textContent = 'Xóa "' + deck + '"?';
                document.getElementById("confirmModal").style.display = "flex";
            }
            function closeModal() {
                document.getElementById("confirmModal").style.display = "none";
            }
            function confirmDelete() {
                alert("Đã xóa bộ: " + currentDeck);
                closeModal();
            }
            function viewSet(link) {
                window.location.href = link;
            }

            function toggleSidebar() {
                document.querySelector(".sidebar").classList.toggle("active");
            }
        </script>
    </body>
</html>