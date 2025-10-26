/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Admin
 */
public class Course {
    private int courseId;
    private String title;
    private String description;
    private String language;
    private String level;
    private String thumbnail;
    private String status;          // draft, submitted, approved, rejected
    private BigDecimal price;
    private LocalDateTime createdAt;
    private LocalDateTime publishAt;
    private InstructorProfile createdBy;
    private Category category;

    public Course() {
    }

    public Course(int courseId, String title, String description, String language, String level, String thumbnail, String status, BigDecimal price, LocalDateTime createdAt, LocalDateTime publishAt, InstructorProfile createdBy, Category category) {
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.language = language;
        this.level = level;
        this.thumbnail = thumbnail;
        this.status = status;
        this.price = price;
        this.createdAt = createdAt;
        this.publishAt = publishAt;
        this.createdBy = createdBy;
        this.category = category;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
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

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getPublishAt() {
        return publishAt;
    }

    public void setPublishAt(LocalDateTime publishAt) {
        this.publishAt = publishAt;
    }
    
    public String getPublishAtStr(){
        if (publishAt == null) return "";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return publishAt.format(fmt);
    }

    public InstructorProfile getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(InstructorProfile createdBy) {
        this.createdBy = createdBy;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
    
    
}
