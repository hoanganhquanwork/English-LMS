package controller.Flashcard.CRUD;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Flashcard;
import model.FlashcardSet;
import model.Users;
import service.FlashcardService;

public class FlashcardSetController extends HttpServlet {

    private FlashcardService service = new FlashcardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer studentId = user.getUserId();
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "createForm":
                    request.getRequestDispatcher("/flashcard/createSet.jsp").forward(request, response);
                    break;

                case "editSetForm": {
                    int setId = Integer.parseInt(request.getParameter("setId"));

                    if (!service.canEditSet(setId, studentId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa set này.");
                        return;
                    }

                    FlashcardSet set = service.getSetById(setId);
                    List<Flashcard> cards = service.getCardsBySet(setId);
                    request.setAttribute("set", set);
                    request.setAttribute("cards", cards);
                    request.getRequestDispatcher("/flashcard/editSet.jsp").forward(request, response);
                    break;
                }

                case "deleteSet": {
                    int deleteId = Integer.parseInt(request.getParameter("setId"));
                    if (!service.deleteSetIfOwner(deleteId, studentId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa set này.");
                        return;
                    }
                    response.sendRedirect("dashboard?action=listSets");
                    break;
                }

                default:
                    response.sendRedirect("dashboard?action=listSets");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer studentId = user.getUserId();
        String action = request.getParameter("action");

        try {
            if ("createSet".equals(action)) {
                createSet(request, response, studentId);
            } else if ("updateSet".equals(action)) {
                updateSet(request, response, studentId);
            } else {
                response.sendRedirect("dashboard?action=listSets");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void createSet(HttpServletRequest request, HttpServletResponse response, Integer studentId)
            throws Exception {
        FlashcardSet set = new FlashcardSet();
        set.setStudentId(studentId);
        set.setTitle(request.getParameter("title"));
        set.setDescription(request.getParameter("description"));

        int setId = service.createSetReturnId(set);

        String[] terms = request.getParameterValues("frontText");
        String[] defs = request.getParameterValues("backText");
        if (terms != null && defs != null) {
            List<Flashcard> cards = new ArrayList<>();
            for (int i = 0; i < terms.length; i++) {
                if (!terms[i].trim().isEmpty() && !defs[i].trim().isEmpty()) {
                    cards.add(new Flashcard(0, setId, terms[i].trim(), defs[i].trim()));
                }
            }
            service.addCards(cards);
        }

        response.sendRedirect("dashboard?action=viewSet&setId=" + setId);
    }

    private void updateSet(HttpServletRequest request, HttpServletResponse response, Integer studentId)
            throws Exception {
        int setId = Integer.parseInt(request.getParameter("setId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        if (!service.updateSetIfOwner(setId, studentId, title, description)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa set này.");
            return;
        }

        String[] cardIds = request.getParameterValues("cardIds[]");
        String[] terms = request.getParameterValues("terms[]");
        String[] defs = request.getParameterValues("definitions[]");

        if (terms != null && defs != null) {
            List<Flashcard> newCards = new ArrayList<>();
            for (int i = 0; i < terms.length; i++) {
                String term = terms[i].trim();
                String def = defs[i].trim();

                if (cardIds != null && i < cardIds.length && !cardIds[i].isEmpty()) {
                    int cardId = Integer.parseInt(cardIds[i]);
                    service.updateCard(cardId, term, def);
                } else {
                    if (!term.isEmpty() && !def.isEmpty()) {
                        newCards.add(new Flashcard(0, setId, term, def));
                    }
                }
            }
            if (!newCards.isEmpty()) {
                service.addCards(newCards);
            }
        }

        String[] deleteIds = request.getParameterValues("deleteIds[]");
        if (deleteIds != null) {
            for (String idStr : deleteIds) {
                if (idStr != null && !idStr.isEmpty()) {
                    int cardId = Integer.parseInt(idStr);
                    service.deleteCard(cardId);
                }
            }
        }
        response.sendRedirect("dashboard?action=viewSet&setId=" + setId);
    }
}
