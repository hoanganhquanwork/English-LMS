/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Question {
    private int questionId;
    private int moduleId;
    private Integer lessonId;  // Có thể null
    private String questionText;
    private String questionType; // 'mcq_single', 'mcq_multiple', 'true_false'
    private String explanation;

    public Question() {}

    public Question(int questionId, int moduleId, Integer lessonId, String questionText, String questionType, String explanation) {
        this.questionId = questionId;
        this.moduleId = moduleId;
        this.lessonId = lessonId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.explanation = explanation;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }
}
