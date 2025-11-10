package model.entity;

public class CourseManagers {
    private int courseId;          
    private int userId;           
    private String rejectReason;   

    public CourseManagers() {
    }

    public CourseManagers(int courseId, int userId, String rejectReason) {
        this.courseId = courseId;
        this.userId = userId;
        this.rejectReason = rejectReason;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }
}