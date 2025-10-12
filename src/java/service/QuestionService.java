/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.QuestionDAO;
import java.util.List;
import model.dto.QuestionDTO;

/**
 *
 * @author Admin
 */
public class QuestionService {

    private QuestionDAO qdao = new QuestionDAO();

    public List<QuestionDTO> getQuestionByLessonId(int lessonId) {
        if (lessonId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return qdao.getQuestionByLessonId(lessonId);
    }

    public boolean isCorrectOption(int questionId, int optionId) {
        if (questionId <= 0 || optionId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return qdao.isCorrectOption(questionId, optionId);
    }
    
    public boolean isCorrectTextAnswer(int questionId, String answer){
        if (questionId <= 0 || answer.isBlank()) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return qdao.isCorrectTextAnswer(questionId, answer);
    }
    
    

}
