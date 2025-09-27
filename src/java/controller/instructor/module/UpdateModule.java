/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.module;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Module;
import service.ModuleService;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "UpdateModule", urlPatterns = {"/UpdateModule"})
public class UpdateModule extends HttpServlet {

    private ModuleService moduleService = new ModuleService();

    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateModule</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateModule at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("moduleName");
        String description = request.getParameter("moduleDescription");

        Module module = new Module();
        module.setModuleId(moduleId);
        module.setTitle(title);
        module.setDescription(description);
        boolean success = moduleService.updateModule(module);
        if (success) {
            response.sendRedirect("manageModule?courseId=" + request.getParameter("courseId"));
        }
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
