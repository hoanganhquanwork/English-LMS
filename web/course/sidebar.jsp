<%-- 
    Document   : sidebar
    Created on : Oct 7, 2025, 11:52:53 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <aside class="sidebar bg-white border-end">
            <div class="p-3">
                <c:if test="${not empty courseTitle}">
                    <h5 class="fw-bold text-primary mb-3">${courseTitle}</h5>
                </c:if>

                <div id="course-outline">
                    <c:choose>
                        <c:when test="${not empty modules}">
                            <c:forEach var="m" items="${modules}">
                                <div class="border-bottom mb-2 pb-2">
                                    <!-- Module header -->
                                    <button type="button"
                                            class="btn w-100 d-flex justify-content-between align-items-center text-start ${m.expanded ? '' : 'collapsed'}"
                                            data-bs-toggle="collapse"
                                            data-bs-target="#module-${m.id}"
                                            aria-expanded="${m.expanded ? 'true' : 'false'}"
                                            aria-controls="module-${m.id}">
                                        <span>
                                            <span class="text-secondary fw-semibold">Module ${m.orderIndex}:</span>
                                            <span class="ms-1 fw-semibold text-dark">${m.name}</span>
                                        </span>
                                        <i class="bi bi-chevron-down"></i>
                                    </button>

                                    <!-- Module items -->
                                    <div id="module-${m.id}"
                                         class="collapse ${m.expanded ? 'show' : ''}"
                                         data-bs-parent="#course-outline">
                                        <ul class="list-unstyled ps-3 mt-2 mb-0">
                                            <c:forEach var="it" items="${m.items}">
                                                <li class="d-flex align-items-start mb-2 p-2 rounded position-relative
                                                    ${it.active ? 'bg-light border-start border-3 border-primary' : ''}">
                                                    <!-- trạng thái hoàn thành -->
                                                    <i class="bi ${it.completed ? 'bi-check-circle-fill text-success' : 'bi-circle text-secondary'} me-2 mt-1"></i>

                                                    <!-- điều hướng theo itemId -->
                                                    <a class="flex-grow-1 text-decoration-none ${it.active ? 'text-dark' : 'text-body'}"
                                                       href="${pageContext.request.contextPath}/course-item?itemId=${it.id}">
                                                        <div class="fw-semibold small">${it.title}</div>
                                                        <small class="text-muted text-capitalize">${it.type}</small>
                                                        <c:if test="${not empty it.duration}">
                                                            <small class="text-muted"> • ${it.duration}</small>
                                                        </c:if>
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted small">No modules available.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </aside>
    </body>
</html>
