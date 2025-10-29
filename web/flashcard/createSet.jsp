<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Flashcard Set Mới</title>
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
        
        <c:if test="${not empty message}">
            <div class="alert success">${message}</div>
        </c:if>
        
        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-plus-circle" style="color: #667eea; margin-right: 15px;"></i>
                    Tạo Flashcard Set Mới
                </h1>
                <p class="page-subtitle">Tạo bộ flashcard mới và chia sẻ kiến thức của bạn</p>
            </div>

            <form id="createSetForm" method="post" action="<%= cpath %>/set">
                <input type="hidden" name="action" value="createSet" />

                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-info-circle"></i>
                        Thông tin cơ bản
                    </h3>
                    <div class="form-grid">
                        <div class="input-group">
                            <label class="input-label" for="title">Tiêu đề</label>
                            <input id="title" name="title" type="text" class="form-input" 
                                   placeholder="Nhập tiêu đề cho bộ flashcard..." 
                                   value="${fn:escapeXml(param.title)}" required />
                        </div>
                        <div class="input-group">
                            <label class="input-label" for="description">Mô tả</label>
                            <textarea id="description" name="description" class="form-input form-textarea" 
                                      placeholder="Thêm mô tả chi tiết về bộ flashcard...">${fn:escapeXml(param.description)}</textarea>
                        </div>
                        <div class="input-group">
                            <label class="input-label" for="status">Quyền riêng tư</label>
                            <select id="status" name="status" class="form-select">
                                <option value="private" selected>🔒 Riêng tư (Chỉ mình tôi)</option>
                                <option value="public">🌍 Công khai (Mọi người đều xem được)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="cards-section">
                    <h3 class="section-title">
                        <i class="fas fa-layer-group"></i>
                        Flashcard
                    </h3>
                    <div id="flashcardList">
                        <c:forEach begin="0" end="1" varStatus="st">
                            <div class="card-entry" data-index="${st.index}">
                                <div class="card-header">
                                    <div class="card-number">${st.index + 1}</div>
                                    <button class="remove-card-btn" type="button" onclick="removeCard(this)">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </div>
                                <div class="card-inputs">
                                    <div class="input-group">
                                        <label class="input-label">Thuật ngữ</label>
                                        <input name="frontText" type="text" class="form-input" 
                                               placeholder="Nhập thuật ngữ..." required />
                                    </div>
                                    <div class="input-group">
                                        <label class="input-label">Định nghĩa</label>
                                        <input name="backText" type="text" class="form-input" 
                                               placeholder="Nhập định nghĩa..." required />
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="add-card-section">
                        <button class="add-card-btn" type="button" id="addCardBtn">
                            <i class="fas fa-plus"></i> Thêm thẻ mới
                        </button>
                    </div>
                </div>

                <div class="form-actions">
                    <button class="btn-primary" type="submit">
                        <i class="fas fa-save"></i> Tạo bộ flashcard
                    </button>
                    <a href="<c:url value='/flashcard-ai?setId=${setId}'/>" class="btn-secondary">
                        <i class="fas fa-robot"></i> Tạo bằng AI
                    </a>
                </div>
            </form>
        </div>
    </div>

    <template id="cardTemplate">
        <div class="card-entry" data-index="__INDEX__">
            <div class="card-header">
                <div class="card-number">__NUM__</div>
                <button class="remove-card-btn" type="button" onclick="removeCard(this)">
                    <i class="fas fa-trash"></i> Xóa
                </button>
            </div>
            <div class="card-inputs">
                <div class="input-group">
                    <label class="input-label">Thuật ngữ</label>
                    <input name="frontText" type="text" class="form-input" placeholder="Nhập thuật ngữ..." required />
                </div>
                <div class="input-group">
                    <label class="input-label">Định nghĩa</label>
                    <input name="backText" type="text" class="form-input" placeholder="Nhập định nghĩa..." required />
                </div>
            </div>
        </div>
    </template>

    <script>
        (function () {
            const listEl = document.getElementById('flashcardList');
            const addBtn = document.getElementById('addCardBtn');
            const tpl = document.getElementById('cardTemplate').innerHTML;

            function renumber() {
                const items = listEl.querySelectorAll('.card-entry');
                items.forEach((el, i) => {
                    el.dataset.index = i;
                    const num = el.querySelector('.card-number');
                    if (num) num.textContent = i + 1;
                });
            }

            addBtn.addEventListener('click', () => {
                const nextIndex = listEl.querySelectorAll('.card-entry').length;
                const html = tpl.replaceAll('__INDEX__', nextIndex).replaceAll('__NUM__', nextIndex + 1);
                const wrapper = document.createElement('div');
                wrapper.innerHTML = html.trim();
                const node = wrapper.firstElementChild;
                listEl.appendChild(node);
                renumber();
            });

            window.removeCard = function (btn) {
                const entry = btn.closest('.card-entry');
                if (!entry) return;
                entry.remove();
                renumber();
            }
        })();
    </script>
</body>
</html>
