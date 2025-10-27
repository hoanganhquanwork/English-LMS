/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

/**
 *
 * @author LENOVO
 */
public class AssignmentDetailDTO {

    private int assignmentId;
    private String title;
    private String content;
    private String instructions;
    private String submissionType;
    private String attachmentUrl;
    private String rubric;
    private Double passingScorePct; // có thể null
    private double maxScore;

    public AssignmentDetailDTO() {
    }

    public AssignmentDetailDTO(int assignmentId, String title, String content, String instructions, String submissionType, String attachmentUrl, String rubric, Double passingScorePct, double maxScore) {
        this.assignmentId = assignmentId;
        this.title = title;
        this.content = content;
        this.instructions = instructions;
        this.submissionType = submissionType;
        this.attachmentUrl = attachmentUrl;
        this.rubric = rubric;
        this.passingScorePct = passingScorePct;
        this.maxScore = maxScore;
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

    public String getRubric() {
        return rubric;
    }

    public void setRubric(String rubric) {
        this.rubric = rubric;
    }

    public Double getPassingScorePct() {
        return passingScorePct;
    }

    public void setPassingScorePct(Double passingScorePct) {
        this.passingScorePct = passingScorePct;
    }

    public double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(double maxScore) {
        this.maxScore = maxScore;
    }

}
