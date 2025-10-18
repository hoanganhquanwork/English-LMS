/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.instructor.question;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.entity.Question;
import model.entity.Topic;
import model.entity.Users;
import model.entity.InstructorProfile;
import service.QuestionService;
import service.TopicService;
import dal.InstructorProfileDAO;

/**
 *
 * @author Lenovo
 */
public class QuestionsController extends HttpServlet {

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("auth/login.jsp");
            return;
        }
        List<Question> draftQuestions = questionService.getDraftQuestionsByInstructor(user.getUserId());
        request.setAttribute("draftQuestions", draftQuestions);

        request.getRequestDispatcher("teacher/questions-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
