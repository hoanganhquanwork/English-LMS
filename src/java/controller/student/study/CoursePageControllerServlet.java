/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student.study;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.dto.CoursePageDTO;
import model.dto.DiscussionDTO;
import model.dto.DiscussionPostDTO;
import model.dto.ModuleItemViewDTO;
import model.dto.ModuleWithItemsDTO;
import model.entity.Lesson;
import model.entity.Users;
import service.CoursePageService;
import service.DiscussionService;
import service.LessonService;
import service.ProgressService;
import util.ParseUtil;
import static util.ParseUtil.parseIntOrNull;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CoursePageController", urlPatterns = {"/coursePage"})
public class CoursePageControllerServlet extends HttpServlet {

    private CoursePageService coursePageService = new CoursePageService();
    private ProgressService progressService = new ProgressService();
    private LessonService lessonService = new LessonService();
    private DiscussionService discussionService = new DiscussionService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CoursePageController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CoursePageController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer courseId = parseIntOrNull(request.getParameter("courseId"));
        Integer itemId = parseIntOrNull(request.getParameter("itemId"));

        if (courseId == null) {
            request.setAttribute("errorMessage", "Tham số truyền vào không hợp lệ");
            request.getRequestDispatcher("/course/main-layout.jsp").forward(request, response);
            return;
        }

        int userId = user.getUserId();

        try {
            //side bar
            CoursePageDTO coursePage = coursePageService.getCoursePage(courseId, userId);
            if (coursePage != null) {
                request.setAttribute("coursePage", coursePage);
            }

            if (itemId == null) {
                //lay khoa hoc dau tien
                itemId = findFirstItemId(coursePage);
            }
            ModuleItemViewDTO item = getItem(coursePage, itemId);
            if (item == null) {
                item = getItem(coursePage, findFirstItemId(coursePage));
                itemId = (item != null ? item.getModuleItemId() : null);
            }
            //update for when first click module item
            progressService.createFirstProgressIfNeeded(userId, itemId);

//            request.setAttribute("item", item);
            request.setAttribute("activeItemId", itemId);
            request.setAttribute("selectedItemType", item.getItemType());
            // lesson/quiz/assignment/discussion
            request.setAttribute("selectedContentType", item.getContentType());
            request.setAttribute("title", item.getTitle());
            request.setAttribute("status", item.getStatus());

            if ("lesson".equalsIgnoreCase(item.getItemType())) {
                if ("video".equalsIgnoreCase(item.getContentType())) {
                    Lesson video = lessonService.getLessonById(item.getModuleItemId());
                    request.setAttribute("lesson", video);
                } else if ("reading".equalsIgnoreCase(item.getContentType())) {
                    Lesson reading = lessonService.getLessonById(item.getModuleItemId());
                    request.setAttribute("lesson", reading);
                }
            } else if ("discussion".equalsIgnoreCase(item.getItemType())) {
                DiscussionDTO discussion = discussionService.getDiscussionByModuleItemId(item.getModuleItemId());
                boolean firstPostStatus = discussionService.hasDiscussionPost(userId, item.getModuleItemId());
                Integer pageNumber = parseIntOrNull(request.getParameter("pageNumber"));
                if (pageNumber == null) {
                    pageNumber = 1;
                }
                int pageSize = 3;
                int totalPosts = discussionService.countDiscusionPost(item.getModuleItemId());
                int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

                List<DiscussionPostDTO> listPost
                        = discussionService.getListDiscussionPost(item.getModuleItemId(), pageNumber, pageSize);

                request.setAttribute("discussion", discussion);
                request.setAttribute("firstPostStatus", firstPostStatus);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("page", pageNumber);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("listPost", listPost);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (RuntimeException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Có lỗi trong quá trình xử lý");
        }
        request.getRequestDispatcher("/course/main-layout.jsp").forward(request, response);
    }

//    private Integer parseIntOrNull(String s) {
//        if (s == null || s.isBlank()) {
//            return null;
//        }
//
//        try {
//            return Integer.valueOf(s.trim());
//        } catch (NumberFormatException e) {
//            return null;
//        }
//    }
    private Integer findFirstItemId(CoursePageDTO coursePage) {
        if (coursePage == null || coursePage.getModules() == null || coursePage.getModules().isEmpty()) {
            return null;
        }
        ModuleWithItemsDTO firstModule = coursePage.getModules().get(0);
        if (firstModule.getItems() == null || firstModule.getItems().isEmpty()) {
            return null;
        }
        return firstModule.getItems().get(0).getModuleItemId();
    }

    private ModuleItemViewDTO getItem(CoursePageDTO cp, Integer itemId) {
        if (cp == null || cp.getModules() == null || itemId == null) {
            return null;
        }

        for (ModuleWithItemsDTO m : cp.getModules()) {
            if (m.getItems() == null) {
                continue;
            }
            for (ModuleItemViewDTO item : m.getItems()) {
                if (item.getModuleItemId() == itemId) {
                    return item;
                }
            }
        }
        return null;
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
