/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class Lesson {

    private int moduleItemId;
    private String title;
    private String contentType; // video / reading
    private String videoUrl;
    private int durationSec;
    private String textContent;

    public Lesson() {
    }

    public Lesson(int moduleItemId, String title, String contentType, String videoUrl, int durationSec, String textContent) {
        this.moduleItemId = moduleItemId;
        this.title = title;
        this.contentType = contentType;
        this.videoUrl = videoUrl;
        this.durationSec = durationSec;
        this.textContent = textContent;
    }

    public int getModuleItemId() {
        return moduleItemId;
    }

    public void setModuleItemId(int moduleItemId) {
        this.moduleItemId = moduleItemId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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

    public int getDurationSec() {
        return durationSec;
    }

    public void setDurationSec(int durationSec) {
        this.durationSec = durationSec;
    }

    public String getTextContent() {
        return textContent;
    }

    public void setTextContent(String textContent) {
        this.textContent = textContent;
    }
    
}
