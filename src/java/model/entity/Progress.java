/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class Progress {
    private int studentId;
    private int moduleItemId;
    private String status;       
    private Double percentDone;  
    private Double scorePct;    
    private Date startedAt;
    private Date completedAt;
    private Date updatedAt;

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getModuleItemId() {
        return moduleItemId;
    }

    public void setModuleItemId(int moduleItemId) {
        this.moduleItemId = moduleItemId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getPercentDone() {
        return percentDone;
    }

    public void setPercentDone(Double percentDone) {
        this.percentDone = percentDone;
    }

    public Double getScorePct() {
        return scorePct;
    }

    public void setScorePct(Double scorePct) {
        this.scorePct = scorePct;
    }

    public Date getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Date startedAt) {
        this.startedAt = startedAt;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    
}
