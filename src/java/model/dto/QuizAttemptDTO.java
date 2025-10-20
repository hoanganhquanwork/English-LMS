/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Admin
 */
public class QuizAttemptDTO {

    private long attemptId;
    private int quizId;
    private int studentId;
    private int attemptNo;
    private String status;
    private LocalDateTime submittedAt;
    private Double scorePct;

    private List<QuizAttemptQuestionDTO> questions;
    private List<QuizAttemptAnswerDTO> answers;

    public long getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(long attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getAttemptNo() {
        return attemptNo;
    }

    public void setAttemptNo(int attemptNo) {
        this.attemptNo = attemptNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public Double getScorePct() {
        return scorePct;
    }

    public void setScorePct(Double scorePct) {
        this.scorePct = scorePct;
    }

    public List<QuizAttemptQuestionDTO> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuizAttemptQuestionDTO> questions) {
        this.questions = questions;
    }

    public List<QuizAttemptAnswerDTO> getAnswers() {
        return answers;
    }

    public void setAnswers(List<QuizAttemptAnswerDTO> answers) {
        this.answers = answers;
    }
    
    
}
