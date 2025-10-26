<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Tạo Flashcard Set Mới</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flashcard-styles.css">
    </head>
    <body>
        <div class="container">
            <header class="header">
                <div class="header-left">
                    <a href="dashboard?action=listSets" class="nav-btn" title="Về trang chính">
                        <i class="fa fa-home"></i>
                    </a>
                </div>
            </header>
            <c:if test="${not empty message}">
                <div class="alert success">${message}</div>
            </c:if>
            <main class="main-content create-content">
                <div class="create-header">
                    <h1 class="create-title">Create a new flashcard set</h1>
                    <p class="create-subtitle">Trang tạo flash card set và chỉnh sửa</p>
                </div>

                <form id="createSetForm" method="post" action="<%= cpath %>/set">
                    <input type="hidden" name="action" value="createSet" />

                    <div class="set-info">
                        <div class="input-group">
                            <label class="input-label" for="title">Title</label>
                            <input id="title" name="title" type="text"
                                   class="title-input" placeholder="Enter title"
                                   value="${fn:escapeXml(param.title)}" required />
                        </div>
                        <div class="input-group">
                            <label class="input-label" for="description">Description</label>
                            <textarea id="description" name="description"
                                      class="description-input" placeholder="Add a description..."
                                      rows="4">${fn:escapeXml(param.description)}</textarea>
                        </div>
                    </div>

                    <div id="flashcardList" class="flashcard-entries">
                        <c:forEach begin="0" end="1" varStatus="st">
                            <div class="card-entry" data-index="${st.index}">
                                <div class="card-number">${st.index + 1}</div>
                                <div class="card-inputs">
                                    <div class="input-group">
                                        <label class="input-label">TERM</label>
                                        <input name="frontText" type="text"
                                               class="term-input" placeholder="Enter term" required />
                                    </div>
                                    <div class="input-group">
                                        <label class="input-label">DEFINITION</label>
                                        <input name="backText" type="text"
                                               class="definition-input" placeholder="Enter definition" required />
                                    </div>
                                </div>
                                <div class="card-actions">
                                    <button class="remove-card-btn" type="button" onclick="removeCard(this)">🗑️</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

   
                    <div class="add-card-section">
                        <button class="add-card-btn" type="button" id="addCardBtn">Add a card</button>
                    </div>

                    <div class="create-section">
                        <button class="create-btn" type="submit">Create</button>

                        <a href="<c:url value='/flashcard-ai?setId=${setId}'/>" class="ai-btn">
                            Generate with AI
                        </a>
                    </div>
                </form>
            </main>
        </div>

        <template id="cardTemplate">
            <div class="card-entry" data-index="__INDEX__">
                <div class="card-number">__NUM__</div>
                <div class="card-inputs">
                    <div class="input-group">
                        <label class="input-label">TERM</label>
                        <input name="frontText" type="text" class="term-input" placeholder="Enter term" required />
                    </div>
                    <div class="input-group">
                        <label class="input-label">DEFINITION</label>
                        <input name="backText" type="text" class="definition-input" placeholder="Enter definition" required />
                    </div>
                </div>
                <div class="card-actions">
                    <button class="remove-card-btn" type="button" onclick="removeCard(this)"><i class = "fa fa-trash"></i></button>
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
                        if (num)
                            num.textContent = i + 1;
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
                    if (!entry)
                        return;
                    entry.remove();
                    renumber();
                }
            })();
        </script>
    </body>
</html>