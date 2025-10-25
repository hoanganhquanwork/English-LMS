/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.util.List;

/**
 *
 * @author Admin
 */
public class QuizDTO {

    private int quizId;
    private Integer moduleId;
    private String title;
    private Double passingScorePct;
    private Integer pickCount;
    private Integer timeLimitMin;
    private List<QuestionDTO> bank;

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public Integer getModuleId() {
        return moduleId;
    }

    public void setModuleId(Integer moduleId) {
        this.moduleId = moduleId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Double getPassingScorePct() {
        return passingScorePct;
    }

    public void setPassingScorePct(Double passingScorePct) {
        this.passingScorePct = passingScorePct;
    }

    public Integer getPickCount() {
        return pickCount;
    }

    public void setPickCount(Integer pickCount) {
        this.pickCount = pickCount;
    }

    public Integer getTimeLimitMin() {
        return timeLimitMin;
    }

    public void setTimeLimitMin(Integer timeLimitMin) {
        this.timeLimitMin = timeLimitMin;
    }

    public List<QuestionDTO> getBank() {
        return bank;
    }

    public void setBank(List<QuestionDTO> bank) {
        this.bank = bank;
    }

    
    
}
