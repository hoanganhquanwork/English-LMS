<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sửa Flashcard Set</title>
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
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-edit" style="color: #667eea; margin-right: 15px;"></i>
                        Sửa Flashcard Set
                    </h1>
                    <p class="page-subtitle">Chỉnh sửa tiêu đề, mô tả và toàn bộ flashcard của bạn</p>
                </div>

                <form action="set" method="post" onsubmit="return confirm('Bạn có chắc muốn lưu thay đổi?')">
                    <input type="hidden" name="action" value="updateSet" />
                    <input type="hidden" name="setId" value="${set.setId}" />
                    <div class="form-actions">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                    </div>
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-info-circle"></i>
                            Thông tin cơ bản
                        </h3>
                        <div class="form-grid">
                            <div class="input-group">
                                <label class="input-label">Tiêu đề</label>
                                <input type="text" class="form-input" name="title" value="${set.title}" required />
                            </div>
                            <div class="input-group">
                                <label class="input-label">Mô tả</label>
                                <textarea class="form-input form-textarea" name="description">${set.description}</textarea>
                            </div>
                            <div class="input-group">
                                <label class="input-label" for="status">Trạng thái bộ thẻ</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="private" ${set.status == 'private' ? 'selected' : ''}>🔒 Riêng tư (Chỉ mình tôi)</option>
                                    <option value="public" ${set.status == 'public' ? 'selected' : ''}>🌍 Công khai (Mọi người đều xem được)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="cards-section">
                        <h3 class="section-title">
                            <i class="fas fa-layer-group"></i>
                            Flashcard
                        </h3>
                        <div id="cards-container">
                            <c:forEach var="card" items="${cards}" varStatus="status">
                                <div class="card-entry">
                                    <div class="card-header">
                                        <div class="card-number">${status.index + 1}</div>
                                        <div class="card-actions">
                                            <label class="delete-checkbox">
                                                <input type="checkbox" name="deleteIds[]" value="${card.cardId}" />
                                                <i class="fas fa-trash"></i> Xóa
                                            </label>
                                        </div>
                                    </div>
                                    <div class="card-inputs">
                                        <input type="hidden" name="cardIds[]" value="${card.cardId}" />
                                        <div class="input-group">
                                            <label class="input-label">Thuật ngữ</label>
                                            <input type="text" class="form-input" name="terms[]" value="${card.frontText}" required />
                                        </div>
                                        <div class="input-group">
                                            <label class="input-label">Định nghĩa</label>
                                            <input type="text" class="form-input" name="definitions[]" value="${card.backText}" required />
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="add-card-section">
                            <button type="button" class="add-card-btn" onclick="addCard()">
                                <i class="fas fa-plus"></i> Thêm thẻ mới
                            </button>
                        </div>
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
                    <div class="card-header">
                        <div class="card-number">${index + 1}</div>
                        <div class="card-actions">
                            <label class="delete-checkbox">
                                <input type="checkbox" name="deleteIds[]" value="" disabled> 
                                <i class="fas fa-trash"></i> Xóa
                            </label>
                        </div>
                    </div>
                    <div class="card-inputs">
                        <input type="hidden" name="cardIds[]" value=""/>
                        <div class="input-group">
                            <label class="input-label">Thuật ngữ</label>
                            <input type="text" class="form-input" name="terms[]" placeholder="Nhập thuật ngữ..." required/>
                        </div>
                        <div class="input-group">
                            <label class="input-label">Định nghĩa</label>
                            <input type="text" class="form-input" name="definitions[]" placeholder="Nhập định nghĩa..." required/>
                        </div>
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
