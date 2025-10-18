/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class Assignment {

    private int assignmentId;
    private String title;
    private String content;
    private String instructions;
    private String submissionType;
    private String attachmentUrl;
    private double maxScore;
    private Double passingScorePct; // có thể null
    private String rubric;

    public Assignment() {
    }

    public Assignment(int assignmentId, String title, String content, String instructions, String submissionType, String attachmentUrl, double maxScore, Double passingScorePct, String rubric) {
        this.assignmentId = assignmentId;
        this.title = title;
        this.content = content;
        this.instructions = instructions;
        this.submissionType = submissionType;
        this.attachmentUrl = attachmentUrl;
        this.maxScore = maxScore;
        this.passingScorePct = passingScorePct;
        this.rubric = rubric;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public String getSubmissionType() {
        return submissionType;
    }

    public void setSubmissionType(String submissionType) {
        this.submissionType = submissionType;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(double maxScore) {
        this.maxScore = maxScore;
    }

    public Double getPassingScorePct() {
        return passingScorePct;
    }

    public void setPassingScorePct(Double passingScorePct) {
        this.passingScorePct = passingScorePct;
    }

    public String getRubric() {
        return rubric;
    }

    public void setRubric(String rubric) {
        this.rubric = rubric;
    }

    
}
