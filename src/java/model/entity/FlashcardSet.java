package model.entity;

public class FlashcardSet {
    private int setId;
    private int studentId;
    private String title;
    private String description;
    private int termCount; 
    private String authorUsername;

    public FlashcardSet() {
    }

    public FlashcardSet(int setId, int studentId, String title, String description, int termCount, String authorUsername) {
        this.setId = setId;
        this.studentId = studentId;
        this.title = title;
        this.description = description;
        this.termCount = termCount;
        this.authorUsername = authorUsername;
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
    
    
}
