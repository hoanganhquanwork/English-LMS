/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class RubricCriterion {

    private Assignment assignment;
    private int criterionNo;
    private double weight;
    private String guidance;

    public RubricCriterion() {
    }

    public RubricCriterion(Assignment assignment, int criterionNo, double weight, String guidance) {
        this.assignment = assignment;
        this.criterionNo = criterionNo;
        this.weight = weight;
        this.guidance = guidance;
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public void setAssignment(Assignment assignment) {
        this.assignment = assignment;
    }

    public int getCriterionNo() {
        return criterionNo;
    }

    public void setCriterionNo(int criterionNo) {
        this.criterionNo = criterionNo;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getGuidance() {
        return guidance;
    }

    public void setGuidance(String guidance) {
        this.guidance = guidance;
    }
    
    
}
