/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class QuizAttemptQuestionDTO {

    private long attemptQuestionId;
    private long attemptId;
    private int questionId;
    private int displayOrder;
    private QuestionDTO question;

    public long getAttemptQuestionId() {
        return attemptQuestionId;
    }

    public void setAttemptQuestionId(long attemptQuestionId) {
        this.attemptQuestionId = attemptQuestionId;
    }

    public long getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(long attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public QuestionDTO getQuestion() {
        return question;
    }

    public void setQuestion(QuestionDTO question) {
        this.question = question;
    }
    
    
}
