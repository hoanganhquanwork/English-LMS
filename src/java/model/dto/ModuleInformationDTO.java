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
public class ModuleInformationDTO {
    private int id;
    private int orderNo;     
    private String title;
    
    private int videoCount;
    private int readingCount;
    private int assignmentCount;
    private int quizCount;
    private int discussionCount;

    private List<ModuleItemInformationDTO> videos;
    private List<ModuleItemInformationDTO> readings;
    private List<ModuleItemInformationDTO> assignments;
    private List<ModuleItemInformationDTO> quizzes;
    private List<ModuleItemInformationDTO> discussions;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(int orderNo) {
        this.orderNo = orderNo;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getVideoCount() {
        return videoCount;
    }

    public void setVideoCount(int videoCount) {
        this.videoCount = videoCount;
    }

    public int getReadingCount() {
        return readingCount;
    }

    public void setReadingCount(int readingCount) {
        this.readingCount = readingCount;
    }

    public int getAssignmentCount() {
        return assignmentCount;
    }

    public void setAssignmentCount(int assignmentCount) {
        this.assignmentCount = assignmentCount;
    }

    public int getQuizCount() {
        return quizCount;
    }

    public void setQuizCount(int quizCount) {
        this.quizCount = quizCount;
    }

    public int getDiscussionCount() {
        return discussionCount;
    }

    public void setDiscussionCount(int discussionCount) {
        this.discussionCount = discussionCount;
    }

    public List<ModuleItemInformationDTO> getVideos() {
        return videos;
    }

    public void setVideos(List<ModuleItemInformationDTO> videos) {
        this.videos = videos;
    }

    public List<ModuleItemInformationDTO> getReadings() {
        return readings;
    }

    public void setReadings(List<ModuleItemInformationDTO> readings) {
        this.readings = readings;
    }

    public List<ModuleItemInformationDTO> getAssignments() {
        return assignments;
    }

    public void setAssignments(List<ModuleItemInformationDTO> assignments) {
        this.assignments = assignments;
    }

    public List<ModuleItemInformationDTO> getQuizzes() {
        return quizzes;
    }

    public void setQuizzes(List<ModuleItemInformationDTO> quizzes) {
        this.quizzes = quizzes;
    }

    public List<ModuleItemInformationDTO> getDiscussions() {
        return discussions;
    }

    public void setDiscussions(List<ModuleItemInformationDTO> discussions) {
        this.discussions = discussions;
    }

   
    
}
