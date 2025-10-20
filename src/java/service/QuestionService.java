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
import model.dto.QuestionDTO;
import model.entity.QuestionTextKey;

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
    
    public boolean addQuestionWithTextKey(Question question, QuestionTextKey textKey) {
        try {
            int questionId = questionDAO.insertQuestion(question);
            if (questionId != -1 && textKey != null) {
                textKey.setQuestionId(questionId);
                questionDAO.insertTextAnswer(textKey);
            }
            return true;
        } catch (Exception e) {
            System.err.println("Lỗi khi thêm câu hỏi dạng text: " + e.getMessage());
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
     public List<Question> getDraftQuestionsByInstructor(int instructorId) {
        return questionDAO.getDraftQuestionsByInstructor(instructorId);
    }
//
//    public Map<Question, List<QuestionOption>> getQuestionsWithOptionsByModule(int moduleId) {
//        Map<Question, List<QuestionOption>> map = new LinkedHashMap<>();
//        List<Question> questions = questionDAO.getQuestionsByModule(moduleId);
//
//        for (Question q : questions) {
//            List<QuestionOption> opts = questionDAO.getOptionsByQuestion(q.getQuestionId());
//            map.put(q, opts);
//        }
//        return map;
//    }

    public boolean updateQuestionWithOptions(Question question, List<QuestionOption> options) {
        try {
            return questionDAO.updateQuestionWithOptions(question, options);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<QuestionDTO> getQuestionByLessonId(int lessonId) {
        if (lessonId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return questionDAO.getQuestionByLessonId(lessonId);
    }

    public boolean isCorrectOption(int questionId, int optionId) {
        if (questionId <= 0 || optionId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return questionDAO.isCorrectOption(questionId, optionId);
    }

    public boolean isCorrectTextAnswer(int questionId, String answer) {
        if (questionId <= 0 || answer.isBlank()) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return questionDAO.isCorrectTextAnswer(questionId, answer);
    }

    // Get all questions by instructor
//    public List<Question> getQuestionsByInstructor(int instructorId) {
//        return questionDAO.getQuestionsByInstructor(instructorId);
//    }
//
//    // Get questions by instructor and topic
//    public List<Question> getQuestionsByInstructorAndTopic(int instructorId, int topicId) {
//        return questionDAO.getQuestionsByInstructorAndTopic(instructorId, topicId);
//    }
//
//    // Get draft questions by instructor
//    public List<Question> getDraftQuestionsByInstructor(int instructorId) {
//        return questionDAO.getDraftQuestionsByInstructor(instructorId);
//    }

}
