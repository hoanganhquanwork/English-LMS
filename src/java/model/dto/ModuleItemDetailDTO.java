package model.dto;

import java.util.List;

public class ModuleItemDetailDTO {

    private int moduleId;
    private String moduleTitle;
    private int itemId;
    private String itemType;
    private int orderIndex;

    // LESSON
    private String lessonTitle;
    private String contentType;
    private String videoUrl;
    private String textContent;
    private int durationSec;
    private List<QuestionDTO> lessonQuestions;


    // QUIZ

    private String quizTitle;
    private Integer attemptsAllowed;
    private Double quizPassingPct;
    private Integer pickCount;
    private Integer timeLimitMin;

    // ASSIGNMENT
    private String assignmentTitle;
    private Double maxScore;
    private String submissionType;
    private Double assignmentPassingPct;
    private String assignmentContent;
    private String assignmentInstructions;
    private String attachmentUrl;
    private String rubric;

    // DISCUSSION
    private String discussionTitle;
    private String discussionDescription;

    // Có thể giữ nếu Assignment có subWorks (không bắt buộc)
    private List<AssignmentWorkDTO> assignmentWorks;

    // ================== GETTERS & SETTERS ==================
    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getModuleTitle() {
        return moduleTitle;
    }

    public void setModuleTitle(String moduleTitle) {
        this.moduleTitle = moduleTitle;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getTextContent() {
        return textContent;
    }

    public void setTextContent(String textContent) {
        this.textContent = textContent;
    }

    public int getDurationSec() {
        return durationSec;
    }

    public void setDurationSec(int durationSec) {
        this.durationSec = durationSec;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public Integer getAttemptsAllowed() {
        return attemptsAllowed;
    }

    public void setAttemptsAllowed(Integer attemptsAllowed) {
        this.attemptsAllowed = attemptsAllowed;
    }

    public Double getQuizPassingPct() {
        return quizPassingPct;
    }

    public void setQuizPassingPct(Double quizPassingPct) {
        this.quizPassingPct = quizPassingPct;
    }

    public Integer getPickCount() {
        return pickCount;
    }

    public void setPickCount(Integer pickCount) {
        this.pickCount = pickCount;
    }

    public String getAssignmentTitle() {
        return assignmentTitle;
    }

    public void setAssignmentTitle(String assignmentTitle) {
        this.assignmentTitle = assignmentTitle;
    }

    public Double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(Double maxScore) {
        this.maxScore = maxScore;
    }

    public String getSubmissionType() {
        return submissionType;
    }

    public void setSubmissionType(String submissionType) {
        this.submissionType = submissionType;
    }

    public Double getAssignmentPassingPct() {
        return assignmentPassingPct;
    }

    public void setAssignmentPassingPct(Double assignmentPassingPct) {
        this.assignmentPassingPct = assignmentPassingPct;
    }

    public String getAssignmentContent() {
        return assignmentContent;
    }

    public void setAssignmentContent(String assignmentContent) {
        this.assignmentContent = assignmentContent;
    }

    public String getAssignmentInstructions() {
        return assignmentInstructions;
    }

    public void setAssignmentInstructions(String assignmentInstructions) {
        this.assignmentInstructions = assignmentInstructions;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public String getRubric() {
        return rubric;
    }

    public void setRubric(String rubric) {
        this.rubric = rubric;
    }

    public String getDiscussionTitle() {
        return discussionTitle;
    }

    public void setDiscussionTitle(String discussionTitle) {
        this.discussionTitle = discussionTitle;
    }

    public String getDiscussionDescription() {
        return discussionDescription;
    }

    public void setDiscussionDescription(String discussionDescription) {
        this.discussionDescription = discussionDescription;
    }
    public List<AssignmentWorkDTO> getAssignmentWorks() {
        return assignmentWorks;
    }

    public void setAssignmentWorks(List<AssignmentWorkDTO> assignmentWorks) {
        this.assignmentWorks = assignmentWorks;
    }

    public Integer getTimeLimitMin() {
        return timeLimitMin;
    }

    public void setTimeLimitMin(Integer timeLimitMin) {
        this.timeLimitMin = timeLimitMin;
    }
    public List<QuestionDTO> getLessonQuestions() {
        return lessonQuestions;
    }

    public void setLessonQuestions(List<QuestionDTO> lessonQuestions) {
        this.lessonQuestions = lessonQuestions;
    }
}
