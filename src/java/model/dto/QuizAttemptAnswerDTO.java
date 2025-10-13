/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

/**
 *
 * @author Admin
 */
public class QuizAttemptAnswerDTO {

    private long attemptId;
    private int questionId;
    private Integer chosenOptionId;  // cho mcq_single
    private String answerText;       // cho text
    private Boolean isCorrect;

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

    public Integer getChosenOptionId() {
        return chosenOptionId;
    }

    public void setChosenOptionId(Integer chosenOptionId) {
        this.chosenOptionId = chosenOptionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public Boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public Integer getOptionId() {
        return chosenOptionId;
    } // alias

    public String getTextValue() {
        return answerText;
    }//alias
}
