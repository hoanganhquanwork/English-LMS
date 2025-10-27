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

    private ModuleItem assignmentId;
    private String title;
    private String content;
    private String instructions;
    private String submissionType;
    private String attachmentUrl;
    private double maxScore;
    private Double passingScorePct; // có thể null
    private String promptSummary;
    private boolean isAiGradeAllowed;

    public Assignment() {
    }

    public Assignment(ModuleItem assignmentId, String title, String content, String instructions,
                      String submissionType, String attachmentUrl, double maxScore,
                      Double passingScorePct, String promptSummary, boolean isAiGradeAllowed) {
        this.assignmentId = assignmentId;
        this.title = title;
        this.content = content;
        this.instructions = instructions;
        this.submissionType = submissionType;
        this.attachmentUrl = attachmentUrl;
        this.maxScore = maxScore;
        this.passingScorePct = passingScorePct;
        this.promptSummary = promptSummary;
        this.isAiGradeAllowed = isAiGradeAllowed;
    }

    public ModuleItem getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(ModuleItem assignmentId) {
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

    public String getPromptSummary() {
        return promptSummary;
    }

    public void setPromptSummary(String promptSummary) {
        this.promptSummary = promptSummary;
    }

    public boolean isIsAiGradeAllowed() {
        return isAiGradeAllowed;
    }

    public void setIsAiGradeAllowed(boolean isAiGradeAllowed) {
        this.isAiGradeAllowed = isAiGradeAllowed;
    }

    public boolean isAiGradeAllowed() {
        return isAiGradeAllowed;
    }

    public void setAiGradeAllowed(boolean isAiGradeAllowed) {
        this.isAiGradeAllowed = isAiGradeAllowed;
    }
}