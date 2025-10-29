package model.entity;

public class FlashcardSet {
    private int setId;
    private int studentId;
    private String title;
    private String description;
    private int termCount; 
    private String status;
    private String authorUsername;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;
    private java.sql.Timestamp lastActivityAt;

    public FlashcardSet() {
    }

    public FlashcardSet(int setId, int studentId, String title, String description, int termCount, String status, String authorUsername) {
        this.setId = setId;
        this.studentId = studentId;
        this.title = title;
        this.description = description;
        this.termCount = termCount;
        this.status = status;
        this.authorUsername = authorUsername;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    

    public int getSetId() {
        return setId;
    }

    public void setSetId(int setId) {
        this.setId = setId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTermCount() {
        return termCount;
    }

    public void setTermCount(int termCount) {
        this.termCount = termCount;
    }

    public String getAuthorUsername() {
        return authorUsername;
    }

    public void setAuthorUsername(String authorUsername) {
        this.authorUsername = authorUsername;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public java.sql.Timestamp getLastActivityAt() {
        return lastActivityAt;
    }

    public void setLastActivityAt(java.sql.Timestamp lastActivityAt) {
        this.lastActivityAt = lastActivityAt;
    }
    
}
