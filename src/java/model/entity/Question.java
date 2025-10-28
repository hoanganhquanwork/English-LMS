/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.util.List;

/**
 *
 * @author Lenovo
 */
public class Question {

    private int questionId;
    private Integer lessonId;
    private String content;
    private String mediaUrl;
    private String type;
    private InstructorProfile createdBy;
    private String explanation;
    private String status;
    private Integer topicId;
    private String reviewComment;

    private List<QuestionOption> options;
    private QuestionTextKey textKey;

    public Question() {
    }

    public Question(int questionId, Integer lessonId, String content, String mediaUrl, String type, InstructorProfile createdBy, String explanation, String status, Integer topicId, String reviewComment) {
        this.questionId = questionId;
        this.lessonId = lessonId;
        this.content = content;
        this.mediaUrl = mediaUrl;
        this.type = type;
        this.createdBy = createdBy;
        this.explanation = explanation;
        this.status = status;
        this.topicId = topicId;
        this.reviewComment = reviewComment;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getMediaUrl() {
        return mediaUrl;
    }

    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public InstructorProfile getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(InstructorProfile createdBy) {
        this.createdBy = createdBy;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getTopicId() {
        return topicId;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
    }

    public String getReviewComment() {
        return reviewComment;
    }

    public void setReviewComment(String reviewComment) {
        this.reviewComment = reviewComment;
    }

    public List<QuestionOption> getOptions() {
        return options;
    }

    public void setOptions(List<QuestionOption> options) {
        this.options = options;
    }

    public QuestionTextKey getTextKey() {
        return textKey;
    }

    public void setTextKey(QuestionTextKey textKey) {
        this.textKey = textKey;
    }

    @Override
    public String toString() {
        return "Question{" + "questionId=" + questionId + ", lessonId=" + lessonId + ", content=" + content + ", mediaUrl=" + mediaUrl + ", type=" + type + ", createdBy=" + createdBy + ", explanation=" + explanation + ", status=" + status + ", topicId=" + topicId + ", reviewComment=" + reviewComment + ", options=" + options + ", textKey=" + textKey + '}';
    }
    
    
}
