/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class Quiz {

    private int quizId;
    private String title;
    private Double passingScorePct;
    private Integer pickCount;
    private Integer timeLimitMin;

    public Quiz() {
    }

    public Quiz(int quizId, String title, Double passingScorePct, Integer pickCount, Integer timeLimitMin) {
        this.quizId = quizId;
        this.title = title;
        this.passingScorePct = passingScorePct;
        this.pickCount = pickCount;
        this.timeLimitMin = timeLimitMin;
    }

    // ===== Getters & Setters =====
    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
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
}