package model.entity;

import java.time.LocalDateTime;

public class UserReport {

    private int reportId;
    private int reporterId;
    private int typeId;
    private String description;
    private String typeName;
    private String pageUrl;
    private String status;
    private String adminNote;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String reporterName;
    private String reporterRole;
    private String reporterEmail;
    public UserReport() {
    }

    // Getters & Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getReporterId() {
        return reporterId;
    }

    public void setReporterId(int reporterId) {
        this.reporterId = reporterId;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPageUrl() {
        return pageUrl;
    }

    public void setPageUrl(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }

    public void setReporterRole(String reporterRole) {
        this.reporterRole = reporterRole;
    }

    public String getReporterName() {
        return reporterName;
    }

    public String getReporterRole() {
        return reporterRole;
    }

    public String getReporterEmail() {
        return reporterEmail;
    }

    public void setReporterEmail(String reporterEmail) {
        this.reporterEmail = reporterEmail;
    }
    
}
