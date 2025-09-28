package controller.Flashcard.CRUD;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import model.Flashcard;
import model.FlashcardSet;
import model.Users;
import service.FlashcardService;

public class FlashcardDashboardController extends HttpServlet {

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
        if (action == null) {
            action = "listSets";
        }

        try {
            switch (action) {
                case "listSets":
                    showRecents(request, response, studentId);
                    break;
                case "viewAllMySets":
                    viewAllMySets(request, response, studentId);
                    break;
                case "viewAllLibrary":
                    viewAllLibrary(request, response);
                    break;
                case "searchMySets":
                    searchMySets(request, response, studentId);
                    break;
                case "searchLibrary":
                    searchLibrary(request, response);
                    break;
                case "viewSet":
                    viewSet(request, response);
                    break;
                default:
                    response.sendRedirect("dashboard?action=listSets");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showRecents(HttpServletRequest request, HttpServletResponse response, Integer studentId)
            throws Exception {
        List<FlashcardSet> mySets = service.getSetsByStudent(studentId);
        if (mySets.size() > 4) {
            mySets = mySets.subList(0, 4);
        }

        List<FlashcardSet> librarySets = service.getAllSets();
        if (librarySets.size() > 4) {
            librarySets = librarySets.subList(0, 4);
        }

        request.setAttribute("mySets", mySets);
        request.setAttribute("librarySets", librarySets);
        request.getRequestDispatcher("/flashcard-dashboard/recents.jsp").forward(request, response);
    }

    private void viewAllMySets(HttpServletRequest request, HttpServletResponse response, Integer studentId)
            throws Exception {
        List<FlashcardSet> mySets = service.getSetsByStudent(studentId);

        String sortOrder = request.getParameter("sortOrder");
        if ("asc".equals(sortOrder)) {
            mySets.sort(Comparator.comparing(FlashcardSet::getTitle, String.CASE_INSENSITIVE_ORDER));
        } else if ("desc".equals(sortOrder)) {
            mySets.sort(Comparator.comparing(FlashcardSet::getTitle, String.CASE_INSENSITIVE_ORDER).reversed());
        }
        request.setAttribute("mySets", mySets);
        request.getRequestDispatcher("/flashcard-dashboard/mySets.jsp").forward(request, response);
    }

    private void viewAllLibrary(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<FlashcardSet> librarySets = service.getAllSets();
        String sortOrder = request.getParameter("sortOrder");
        if ("asc".equals(sortOrder)) {
            librarySets.sort(Comparator.comparing(FlashcardSet::getTitle, String.CASE_INSENSITIVE_ORDER));
        } else if ("desc".equals(sortOrder)) {
            librarySets.sort(Comparator.comparing(FlashcardSet::getTitle, String.CASE_INSENSITIVE_ORDER).reversed());
        }

        request.setAttribute("librarySets", librarySets);
        request.getRequestDispatcher("/flashcard-dashboard/library.jsp").forward(request, response);
    }

    private void searchMySets(HttpServletRequest request, HttpServletResponse response, Integer studentId)
            throws Exception {
        String keyword = request.getParameter("keyword");
        List<FlashcardSet> mySets;
        if (keyword != null && !keyword.trim().isEmpty()) {
            mySets = service.searchMySets(studentId, keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            mySets = service.getSetsByStudent(studentId);
        }
        request.setAttribute("mySets", mySets);
        request.getRequestDispatcher("/flashcard-dashboard/mySets.jsp").forward(request, response);
    }

    private void searchLibrary(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String keyword = request.getParameter("keyword");
        List<FlashcardSet> librarySearch;
        if (keyword != null && !keyword.trim().isEmpty()) {
            librarySearch = service.searchAllSets(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            librarySearch = service.getAllSets();
        }
        request.setAttribute("librarySets", librarySearch);
        request.getRequestDispatcher("/flashcard-dashboard/library.jsp").forward(request, response);
    }

    private void viewSet(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int setId = Integer.parseInt(request.getParameter("setId"));
        FlashcardSet set = service.getSetById(setId);
        List<Flashcard> cards = service.getCardsBySet(setId);

        String sortCardOrder = request.getParameter("sortOrder");
        if ("asc".equals(sortCardOrder)) {
            cards.sort(Comparator.comparing(Flashcard::getFrontText, String.CASE_INSENSITIVE_ORDER));
        } else if ("desc".equals(sortCardOrder)) {
            cards.sort(Comparator.comparing(Flashcard::getFrontText, String.CASE_INSENSITIVE_ORDER).reversed());
        }
        request.setAttribute("set", set);
        request.setAttribute("cards", cards);
        request.getRequestDispatcher("/flashcard/viewSet.jsp").forward(request, response);
    }
}
