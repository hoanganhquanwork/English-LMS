<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${empty set.title ? 'Flashcard Study Mode' : set.title}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            :root{
                --brand:#4f46e5;
                --brand-dark:#3730a3;
                --bg:#f9fafb;
                --text:#1f2937;
                --muted:#6b7280;
                --card-bg:#fff;
            }
            body{
                background:var(--bg);
                font-family:"Inter",sans-serif;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                height:100vh;
                margin:0;
            }
            .back-btn{
                position:absolute;
                top:20px;
                left:25px;
                background:var(--brand);
                color:#fff;
                border:none;
                border-radius:50%;
                width:42px;
                height:42px;
                display:flex;
                align-items:center;
                justify-content:center;
                cursor:pointer;
                font-size:1.1rem;
                box-shadow:0 4px 10px rgba(0,0,0,.15);
                transition:background .2s,transform .2s;
            }
            .back-btn:hover{
                background:var(--brand-dark);
                transform:scale(1.05);
            }
            h1{
                color:var(--brand-dark);
                margin-bottom:20px;
                font-size:1.6rem;
                text-align:center;
            }
            .study-area{
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:90px;
            }
            .card{
                perspective:1200px;
                perspective-origin:center;
                width:500px;
                height:280px;
                position:relative;
                cursor:pointer;
                transition:transform .3s ease,opacity .3s ease;
            }
            .inner{
                position:absolute;
                width:100%;
                height:100%;
                transition:transform .6s cubic-bezier(.4,.2,.2,1);
                transform-style:preserve-3d;
                border-radius:14px;
                transform-origin:center;
            }
            .card.flipped .inner{
                transform:rotateY(180deg);
            }
            .front,.back{
                position:absolute;
                inset:0;
                border-radius:14px;
                display:flex;
                justify-content:center;
                align-items:center;
                text-align:center;
                padding:25px;
                font-size:1.25rem;
                line-height:1.6;
                box-shadow:0 6px 18px rgba(0,0,0,.1);
                backface-visibility:hidden;
            }
            .front{
                background:var(--card-bg);
                color:var(--text);
            }
            .back{
                background:var(--card-bg);
                color:var(--text);
                transform:rotateY(180deg);
            }
            .card.enter{
                opacity:0;
                transform:translateX(40px) scale(.98);
            }
            .card.enter-active{
                opacity:1;
                transform:translateX(0) scale(1);
                transition:all .4s ease;
            }
            .card.exit{
                opacity:1;
                transform:translateX(0) scale(1);
            }
            .card.exit-active{
                opacity:0;
                transform:translateX(-40px) scale(.98);
                transition:all .4s ease;
            }
            .controls{
                display:flex;
                gap:12px;
                justify-content:center;
            }
            .controls button{
                background:var(--brand);
                border:none;
                color:#fff;
                padding:8px 18px;
                border-radius:8px;
                cursor:pointer;
                font-weight:600;
                transition:.2s;
                display:flex;
                align-items:center;
                gap:6px;
                font-size:.95rem;
            }
            .controls button:hover{
                background:var(--brand-dark);
                transform:translateY(-1px);
            }
            .progress{
                color:var(--muted);
                margin-top:8px;
                font-weight:500;
                font-size:.95rem;
            }
            @media (max-width:600px){
                .card{
                    width:90%;
                    height:230px
                }
                .front,.back{
                    font-size:1.1rem
                }
            }
            .error-box{
                background:#fee2e2;
                color:#b91c1c;
                border:1px solid #fca5a5;
                border-radius:8px;
                padding:10px 14px;
                margin:10px auto;
                text-align:center;
                font-weight:600;
            }
        </style>
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
