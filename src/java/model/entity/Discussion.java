/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;


import java.time.LocalDateTime;

/**
 *
 * @author Lenovo
 */
public class Discussion {

    private int discussionId;  
    private String title;
    private String description;
    private LocalDateTime createdAt;

    public Discussion() {
    }

    public Discussion(int discussionId, String title, String description, LocalDateTime createdAt) {
        this.discussionId = discussionId;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
    }



    public int getDiscussionId() {
        return discussionId;
    }

    public void setDiscussionId(int discussionId) {
        this.discussionId = discussionId;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }



}
