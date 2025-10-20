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
  <<jsp:include page="../includes-manager/sidebar-manager.jsp" />
  <main>
    <div class="header-detail">
      <h2>${set.title}</h2>
      <div>
        <a href="manager-flashcard" class="btn btn-back"><i class="fa fa-arrow-left"></i> Quay lại</a>

        <form action="flashcard-detail" method="post" style="display:inline;">
          <input type="hidden" name="action" value="deleteSet">
          <input type="hidden" name="setId" value="${set.setId}">
          <button type="submit" class="btn btn-delete-set">🗑 Xóa bộ này</button>
        </form>
      </div>
    </div>

    <div class="flashcard-list">
      <c:forEach var="card" items="${cards}">
        <div class="flashcard-item">
          <input type="checkbox" class="checkbox" />
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

          <form action="flashcard-detail" method="post" style="display:inline;">
            <input type="hidden" name="action" value="deleteCard">
            <input type="hidden" name="cardId" value="${card.cardId}">
            <input type="hidden" name="setId" value="${set.setId}">
            <button type="submit" class="btn-delete"><i class="fas fa-trash"></i></button>
          </form>
        </div>
      </c:forEach>

      <c:if test="${empty cards}">
        <p style="color: gray; margin-top: 2rem;">Bộ flashcard này chưa có thẻ nào.</p>
      </c:if>
    </div>
  </main>

  <div id="cardModal" class="modal" style="display:none;">
    <div class="modal-content">
      <h3 id="cardModalTitle">Xóa thẻ?</h3>
      <p>Bạn có chắc chắn muốn xóa thẻ này không?</p>
      <div class="modal-buttons">
        <button class="btn-delete" onclick="confirmDeleteCard()">Xóa</button>
        <button class="btn btn-back" onclick="closeModal()">Hủy</button>
      </div>
    </div>
  </div>

  <div id="setModal" class="modal" style="display:none;">
    <div class="modal-content">
      <h3>Xóa bộ Flashcard này?</h3>
      <p>Tất cả các thẻ trong bộ này sẽ bị xóa. Bạn có chắc không?</p>
      <div class="modal-buttons">
        <button class="btn-delete" onclick="confirmDeleteSet()">Xóa</button>
        <button class="btn btn-back" onclick="closeModal()">Hủy</button>
      </div>
    </div>
  </div>

  <script>
    let currentCard = "";
    function openDeleteCard(name) {
      currentCard = name;
      document.getElementById("cardModalTitle").textContent = 'Xóa "' + name + '"?';
      document.getElementById("cardModal").style.display = "flex";
    }
    function openDeleteSet() {
      document.getElementById("setModal").style.display = "flex";
    }
    function closeModal() {
      document.getElementById("cardModal").style.display = "none";
      document.getElementById("setModal").style.display = "none";
    }
  </script>
</body>
</html>