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

    public Map<Question, Object> getLessonQuestionsWithAnswers(int lessonId) {
        Map<Question, Object> result = new LinkedHashMap<>();

        // Lấy tất cả câu hỏi thuộc lesson
        List<Question> questions = questionDAO.getQuestionsByLesson(lessonId);

        for (Question q : questions) {
            if ("mcq_single".equalsIgnoreCase(q.getType())) {
                // Nếu là câu hỏi trắc nghiệm đơn → lấy các phương án lựa chọn
                List<QuestionOption> options = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, options);
            } else if ("text".equalsIgnoreCase(q.getType())) {
                // Nếu là câu hỏi tự luận → lấy đáp án text từ QuestionTextKey
                String answer = questionDAO.getAnswerByQuestionId(q.getQuestionId());
                result.put(q, answer);
            }
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

    public boolean removeQuestionFromModule(int moduleId, int questionId) {
        return questionDAO.removeQuestionFromModule(moduleId, questionId);
    }

    public Map<Question, Object> getDraftQuestionsWithAnswersPaged(int instructorId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Question> questions = questionDAO.getDraftQuestionsByInstructorPaged(instructorId, offset, pageSize);
        Map<Question, Object> result = new LinkedHashMap<>();

        for (Question q : questions) {
            if ("mcq_single".equals(q.getType())) {
                List<QuestionOption> opts = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, opts);
            } else if ("text".equals(q.getType())) {
                String answer = questionDAO.getAnswerByQuestionId(q.getQuestionId());
                result.put(q, answer);
            }
        }
        return result;
    }

    public int countDraftQuestions(int instructorId) {
        return questionDAO.countDraftQuestionsByInstructor(instructorId);
    }

    public Map<Question, Object> getQuestionsByModuleWithAnswers(int moduleId) {
        List<Question> questions = questionDAO.getQuestionsByModule(moduleId);
        Map<Question, Object> result = new LinkedHashMap<>();

        for (Question q : questions) {
            if ("mcq_single".equals(q.getType())) {
                List<QuestionOption> opts = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, opts);
            } else if ("text".equals(q.getType())) {
                String answer = questionDAO.getAnswerByQuestionId(q.getQuestionId());
                result.put(q, answer);
            }
        }

        return result;
    }

    public int countSubmittedQuestions(int instructorId, String statusFilter, String topicFilter) {
        return questionDAO.countSubmittedQuestions(instructorId, statusFilter, topicFilter);
    }

    public Map<Question, Object> getSubmittedQuestionsWithAnswersPaged(int instructorId, String statusFilter, String topicFilter, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Question> questions = questionDAO.getSubmittedQuestionsPaged(instructorId, statusFilter, topicFilter, offset, pageSize);
        Map<Question, Object> result = new LinkedHashMap<>();

        for (Question q : questions) {
            if ("mcq_single".equals(q.getType())) {
                List<QuestionOption> opts = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, opts);
            } else if ("text".equals(q.getType())) {
                String answer = questionDAO.getAnswerByQuestionId(q.getQuestionId());
                result.put(q, answer);
            }
        }
        return result;
    }

    public int countApprovedQuestions(String topicFilter) {
        return questionDAO.countApprovedQuestions(topicFilter);
    }

    public Map<Question, Object> getApprovedQuestionsWithAnswersPaged(String topicFilter, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Question> questions = questionDAO.getApprovedQuestionsPaged(topicFilter, offset, pageSize);
        Map<Question, Object> result = new LinkedHashMap<>();

        for (Question q : questions) {
            if ("mcq_single".equals(q.getType())) {
                List<QuestionOption> opts = questionDAO.getOptionsByQuestion(q.getQuestionId());
                result.put(q, opts);
            } else if ("text".equals(q.getType())) {
                String answer = questionDAO.getAnswerByQuestionId(q.getQuestionId());
                result.put(q, answer);
            }
        }
        return result;
    }

    public boolean submitQuestions(List<Integer> questionIds) {
        return questionDAO.submitQuestions(questionIds);
    }

    public int addQuestionsToModule(int moduleId, List<Integer> questionIds) {
        return questionDAO.addQuestionsToModule(moduleId, questionIds);
    }

    public boolean updateQuestionWithOptions(Question question, List<QuestionOption> options) {
        try {
            return questionDAO.updateQuestionWithOptions(question, options);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateQuestionWithTextAnswer(Question q, String answerText) {

        try {
            return questionDAO.updateQuestionWithTextAnswer(q, answerText);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void assignTopic(int topicId, List<Integer> questionIds) {
        questionDAO.assignTopicToQuestions(topicId, questionIds);
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

}
