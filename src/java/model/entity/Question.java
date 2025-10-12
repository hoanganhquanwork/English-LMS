/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class Question {

    private int questionId;
    private int moduleId;
    private Integer lessonId;         // Có thể null
    private String content;           // Nội dung câu hỏi
    private String mediaType;         // image | audio | null
    private String mediaUrl;          // đường dẫn ảnh hoặc audio
    private String type;              // mcq_single | mcq_multi | fib
    private String explanation;       // Giải thích đáp án (hiển thị sau khi nộp)

    public Question() {
    }

    public Question(int questionId, int moduleId, Integer lessonId, String content, String mediaType, String mediaUrl, String type, String explanation) {
        this.questionId = questionId;
        this.moduleId = moduleId;
        this.lessonId = lessonId;
        this.content = content;
        this.mediaType = mediaType;
        this.mediaUrl = mediaUrl;
        this.type = type;
        this.explanation = explanation;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
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

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
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

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

}
