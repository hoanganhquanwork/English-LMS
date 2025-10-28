<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${empty set.title ? 'Flashcard Study Mode' : set.title}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="<c:url value='/css/flashcard-study.css?v=20' />">
    </head>
    <body>

        <button class="back-btn" onclick="window.history.back()">
            <i class="fa fa-arrow-left"></i>
        </button>

        <h1>${empty set.title ? 'Flashcard Study Mode' : set.title}</h1>

        <c:choose>
            <c:when test="${cards == null or fn:length(cards) == 0}">
                <div class="error-box">Bộ này chưa có flashcard nào. Vui lòng quay lại và thêm thẻ.</div>
            </c:when>

            <c:otherwise>
                <div class="study-area">
                    <div class="card" id="flashcard">
                        <div class="inner">
                            <div class="front" id="front"></div>
                            <div class="back" id="back"></div>
                        </div>
                    </div>

                    <div class="controls">
                        <button id="prev"><i class="fa fa-arrow-left"></i></button>
                        <button id="flip"><i class="fa fa-retweet"></i> Lật thẻ</button>
                        <button id="next"><i class="fa fa-arrow-right"></i></button>
                        <button id="shuffle"><i class="fa fa-random"></i></button>
                    </div>

                    <div class="progress" id="progress"></div>
                </div>

                <script>
                    const flashcards = [
                    <c:forEach var="c" items="${cards}" varStatus="st">
                    { term: "${fn:escapeXml(c.frontText)}", definition: "${fn:escapeXml(c.backText)}" }<c:if test="${!st.last}">,</c:if>
                    </c:forEach>
                    ];

                    let index = 0;
                    let flipped = false;
                    let cards = [...flashcards];

                    const card = document.getElementById("flashcard");
                    const front = document.getElementById("front");
                    const back = document.getElementById("back");
                    const progress = document.getElementById("progress");

                    function renderCard() {
                        const {term, definition} = cards[index];
                        front.textContent = term;
                        back.textContent = definition;
                        progress.textContent = "Thẻ " + (index + 1) + " / " + cards.length;
                    }
                    function animateCardChange(direction = "next") {
                        card.classList.add("exit");
                        setTimeout(() => {
                            card.classList.add("exit-active");
                            setTimeout(() => {
                                flipped = false;
                                card.classList.remove("flipped", "exit", "exit-active");
                                index = direction === "next"
                                        ? (index + 1) % cards.length
                                        : (index - 1 + cards.length) % cards.length;
                                renderCard();
                                card.classList.add("enter");
                                setTimeout(() => {
                                    card.classList.add("enter-active");
                                    setTimeout(() => card.classList.remove("enter", "enter-active"), 400);
                                }, 10);
                            }, 300);
                        }, 10);
                    }

                    document.getElementById("flip").onclick = () => {
                        flipped = !flipped;
                        card.classList.toggle("flipped", flipped);
                    };
                    document.getElementById("next").onclick = () => animateCardChange("next");
                    document.getElementById("prev").onclick = () => animateCardChange("prev");
                    document.getElementById("shuffle").onclick = () => {
                        cards.sort(() => Math.random() - 0.5);
                        index = 0;
                        flipped = false;
                        card.classList.remove("flipped");
                        renderCard();
                        card.classList.add("enter", "enter-active");
                        setTimeout(() => card.classList.remove("enter", "enter-active"), 400);
                    };
                    card.onclick = () => {
                        flipped = !flipped;
                        card.classList.toggle("flipped", flipped);
                    };

                    renderCard();
                </script>
            </c:otherwise>
        </c:choose>
    </body>
</html>
