/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.util.List;

/**
 *
 * @author Admin
 */
public class DiscussionDTO {

    private int discussionId;
    private String title;
    private String description;
    private List<DiscussionPostDTO> posts;

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

    public List<DiscussionPostDTO> getPosts() {
        return posts;
    }

    public void setPosts(List<DiscussionPostDTO> posts) {
        this.posts = posts;
    }

}
