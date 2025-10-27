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
import java.util.Map;
import model.entity.QuestionOption;

/**
 *
 * @author Lenovo
 */
public class QuestionsController extends HttpServlet {

    private QuestionService questionService = new QuestionService();
    private TopicService topicService = new TopicService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("loginInternal");
            return;
        }
        String tab = request.getParameter("tab");
        String statusFilter = request.getParameter("statusFilter");
        String topicFilter = request.getParameter("topicFilter");

        int pageSize = 5; // Số câu hỏi mỗi trang
        int draftPage = 1;
        int submittedPage = 1;
        int approvedPage = 1;

        // Lấy số trang hiện tại từ request (tùy tab)
        if (request.getParameter("draftPage") != null) {
            draftPage = Integer.parseInt(request.getParameter("draftPage"));
        }
        if (request.getParameter("submittedPage") != null) {
            submittedPage = Integer.parseInt(request.getParameter("submittedPage"));
        }
        if (request.getParameter("page") != null) { // tab ngân hàng
            approvedPage = Integer.parseInt(request.getParameter("page"));
        }

        List<Topic> topics = topicService.getAllTopics();

        int totalDraft = questionService.countDraftQuestions(user.getUserId());
        int draftTotalPages = (int) Math.ceil((double) totalDraft / pageSize);
        Map<Question, Object> draftQuestionMap = questionService.getDraftQuestionsWithAnswersPaged(user.getUserId(), draftPage, pageSize);
//        Map<Question, Object> draftQuestionMap = questionService.getDraftQuestionsWithAnswers(user.getUserId());

        int totalSubmitted = questionService.countSubmittedQuestions(user.getUserId(), statusFilter, topicFilter);
        int submittedTotalPages = (int) Math.ceil((double) totalSubmitted / pageSize);
        Map<Question, Object> submittedQuestions
                = questionService.getSubmittedQuestionsWithAnswersPaged(user.getUserId(), statusFilter, topicFilter, submittedPage, pageSize);
//        Map<Question, Object> submittedQuestions = questionService.getSubmittedQuestionsWithAnswers(user.getUserId(), statusFilter, topicFilter);

        int totalApproved = questionService.countApprovedQuestions(topicFilter);
        int approvedTotalPages = (int) Math.ceil((double) totalApproved / pageSize);
        Map<Question, Object> approvedQuestionMap
                = questionService.getApprovedQuestionsWithAnswersPaged(topicFilter, approvedPage, pageSize);
//        Map<Question, Object> approvedQuestionMap = questionService.getApprovedQuestionsWithAnswers(topicFilter);

        request.setAttribute("topics", topics);
        request.setAttribute("draftQuestionMap", draftQuestionMap);
        request.setAttribute("submittedQuestions", submittedQuestions);
        request.setAttribute("approvedQuestionMap", approvedQuestionMap);
        // Phân trang Draft
        request.setAttribute("draftPage", draftPage);
        request.setAttribute("draftTotalPages", draftTotalPages);

        // Phân trang Submitted
        request.setAttribute("submittedPage", submittedPage);
        request.setAttribute("submittedTotalPages", submittedTotalPages);

        // Phân trang Approved
        request.setAttribute("page", approvedPage);
        request.setAttribute("totalPages", approvedTotalPages);

        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("selectedTopic", topicFilter);

        if (tab != null && !tab.isEmpty()) {
            request.setAttribute("activeTab", tab);
        } else {
            request.setAttribute("activeTab", "questions"); 
        }

        request.getRequestDispatcher("teacher/questions-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
