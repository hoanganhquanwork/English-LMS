/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.QuestionDAO;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.entity.Question;
import model.entity.QuestionOption;

/**
 *
 * @author Lenovo
 */
public class QuestionService {
    private QuestionDAO questionDAO = new QuestionDAO();

    public boolean addQuestionWithOptions(Question question, List<QuestionOption> options) {
        try {
            int questionId = questionDAO.insertQuestion(question);
            if (questionId != -1 && options != null) {
                for (QuestionOption opt : options) {
                    opt.setQuestionId(questionId);
                    questionDAO.insertOption(opt);
                }
            }
            return true;
        } catch (Exception e) {
            System.err.println(" Lỗi khi thêm câu hỏi và phương án: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
     public Map<Question, List<QuestionOption>> getLessonQuestionsMap(int lessonId) {
        Map<Question, List<QuestionOption>> result = new LinkedHashMap<>();
        try {
            List<Question> questions = questionDAO.getQuestionsByLesson(lessonId);
            for (Question q : questions) {
                List<QuestionOption> options = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, options);
            }
        } catch (Exception e) {
            System.err.println(" Lỗi service getLessonQuestionsMap: " + e.getMessage());
        }
        return result;
    }
        public boolean deleteQuestion(int questionId) {
        try {
            return questionDAO.deleteQuestion(questionId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
        
           public boolean updateQuestionWithOptions(Question question, List<QuestionOption> options) {
        try {
            return questionDAO.updateQuestionWithOptions(question, options);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
