/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.math.BigDecimal;

/**
 *
 * @author Admin
 */
public class RubricCriterionDTO {

    private int assignmentId;
    private short criterionNo;
    private BigDecimal weight;
    private String guidance;

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public short getCriterionNo() {
        return criterionNo;
    }

    public void setCriterionNo(short criterionNo) {
        this.criterionNo = criterionNo;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public String getGuidance() {
        return guidance;
    }

    public void setGuidance(String guidance) {
        this.guidance = guidance;
    }
    
    
}
