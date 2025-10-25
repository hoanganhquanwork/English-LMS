package model.dto;

public class CourseProgressDTO {

    private int courseId;
    private String courseTitle;
    private int totalItems;
    private int completedItems;
    private int requiredItems;
    private int requiredCompleted;
    private double progressPctRequired;
    private Double avgScorePct;

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getCompletedItems() {
        return completedItems;
    }

    public void setCompletedItems(int completedItems) {
        this.completedItems = completedItems;
    }

    public int getRequiredItems() {
        return requiredItems;
    }

    public void setRequiredItems(int requiredItems) {
        this.requiredItems = requiredItems;
    }

    public int getRequiredCompleted() {
        return requiredCompleted;
    }

    public void setRequiredCompleted(int requiredCompleted) {
        this.requiredCompleted = requiredCompleted;
    }

    public double getProgressPctRequired() {
        return progressPctRequired;
    }

    public void setProgressPctRequired(double progressPctRequired) {
        this.progressPctRequired = progressPctRequired;
    }

    public Double getAvgScorePct() {
        return avgScorePct;
    }

    public void setAvgScorePct(Double avgScorePct) {
        this.avgScorePct = avgScorePct;
    }
}
