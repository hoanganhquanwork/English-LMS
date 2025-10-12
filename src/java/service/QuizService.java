/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ModuleItemDAO;
import dal.QuizDAO;
import java.util.List;
import model.entity.ModuleItem;
import model.entity.Quiz;
import java.sql.SQLException;

/**
 *
 * @author Lenovo
 */
public class QuizService {

    private QuizDAO quizDAO = new QuizDAO();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

    // Tạo quiz và tự động sinh moduleItem
    public boolean addQuizWithPool(int moduleId, Quiz quiz, List<Integer> moduleSourceIds) {
        try {
            ModuleItem item = new ModuleItem();
            item.setModuleId(moduleId);
            item.setItemType("quiz");
            item.setOrderIndex(moduleItemDAO.getNextOrderIndex(moduleId));   
            item.setRequired(false);
            int moduleItemId = moduleItemDAO.insertModuleItem(item);
            if (moduleItemId == -1) {
                System.out.println(" Không thể tạo ModuleItem cho quiz");
                return false;
            }

            quiz.setQuizId(moduleItemId);
            boolean created = quizDAO.insertQuiz(quiz);

            // In ra pool câu hỏi (có thể lưu sau)
            if (moduleSourceIds != null && !moduleSourceIds.isEmpty()) {
                List<Integer> questionIds = quizDAO.getQuestionIdsByModules(moduleSourceIds);
                System.out.println("Quiz question pool: " + questionIds);
            }

            return created;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
