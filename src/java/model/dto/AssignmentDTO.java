/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Admin
 */
public class AssignmentDTO {
    private int assignmentId;         
    private String title;
    private String content;            
    private String instructions;       
    private String submissionType;     
    private String attachmentUrl;
    private BigDecimal passingScorePct; 
    private boolean aiGradeAllowed;     
    private String promptSummary;       

    private List<RubricCriterionDTO> rubric;

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

    public BigDecimal getPassingScorePct() {
        return passingScorePct;
    }

    public void setPassingScorePct(BigDecimal passingScorePct) {
        this.passingScorePct = passingScorePct;
    }

    public boolean isAiGradeAllowed() {
        return aiGradeAllowed;
    }

    public void setAiGradeAllowed(boolean aiGradeAllowed) {
        this.aiGradeAllowed = aiGradeAllowed;
    }

    public String getPromptSummary() {
        return promptSummary;
    }

    public void setPromptSummary(String promptSummary) {
        this.promptSummary = promptSummary;
    }

    public List<RubricCriterionDTO> getRubric() {
        return rubric;
    }

    public void setRubric(List<RubricCriterionDTO> rubric) {
        this.rubric = rubric;
    }
    
    
}
