<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
    <div class="header-left">
        <a href="set?action=listSets" class="nav-btn">⌂</a>
    </div>
    <title>Edit Flashcard Set</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-styles.css">

</head>
<body>
    <div class="container">
        <div class="create-content">
            <div class="create-header">
                <h1 class="create-title">Sửa Flashcard Set</h1>
                <p class="create-subtitle">Chỉnh sửa tiêu đề, mô tả và toàn bộ flashcard của bạn</p>
            </div>

            <form action="set" method="post" 
                  onsubmit="return confirm('Bạn có chắc muốn lưu thay đổi?')">
                <input type="hidden" name="action" value="updateSet"/>
                <input type="hidden" name="setId" value="${set.setId}"/>

                <!-- Set info -->
                <div class="set-info">
                    <div class="input-group">
                        <label class="input-label">Title</label>
                        <input type="text" class="title-input" name="title" value="${set.title}" required/>
                    </div>
                    <div class="input-group">
                        <label class="input-label">Description</label>
                        <textarea class="description-input" name="description">${set.description}</textarea>
                    </div>
                </div>

                <!-- Flashcard list -->
                <div class="flashcard-entries" id="cards-container">
                    <c:forEach var="card" items="${cards}" varStatus="status">
                        <div class="card-entry">
                            <div class="card-number">${status.index + 1}</div>
                            <div class="card-inputs">
                                <input type="hidden" name="cardIds[]" value="${card.cardId}"/>
                                <input type="text" class="term-input" name="terms[]" value="${card.frontText}" required/>
                                <input type="text" class="definition-input" name="definitions[]" value="${card.backText}" required/>
                            </div>
                            <div class="card-actions">
                                <label>
                                    <input type="checkbox" name="deleteIds[]" value="${card.cardId}"> Delete
                                </label>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="add-card-section">
                    <button type="button" class="add-card-btn" onclick="addCard()">+ Add Card</button>
                </div>

                <div class="create-section">
                    <button type="submit" class="create-btn">Save Changes</button>
                </div>
            </form>

        </div>
    </div>
    <script>
        function addCard() {
            const container = document.getElementById("cards-container");
            const index = container.children.length;
            const div = document.createElement("div");
            div.className = "card-entry";
            div.innerHTML = `
<div class="card-number">${index + 1}</div>
<div class="card-inputs">
    <input type="hidden" name="cardIds[]" value=""/>
    <input type="text" class="term-input" name="terms[]" placeholder="Front text" required/>
    <input type="text" class="definition-input" name="definitions[]" placeholder="Back text" required/>
</div>
<div class="card-actions">
    <label>
        <input type="checkbox" name="deleteIds[]" value="" disabled> Delete
    </label>
</div>
`;
            container.appendChild(div);
            reindexCards();
        }

        function reindexCards() {
            const cards = document.querySelectorAll(".card-entry .card-number");
            cards.forEach((el, i) => {
                el.textContent = i + 1;
            });
        }
    </script>
</body>
</html>
