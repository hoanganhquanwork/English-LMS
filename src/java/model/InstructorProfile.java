/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class InstructorProfile {
    private int userId;       
    private String bio;
    private String expertise;
    private String qualifications;

    public InstructorProfile() {
    }

    public InstructorProfile(int userId, String bio, String expertise, String qualifications) {
        this.userId = userId;
        this.bio = bio;
        this.expertise = expertise;
        this.qualifications = qualifications;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getExpertise() {
        return expertise;
    }

    public void setExpertise(String expertise) {
        this.expertise = expertise;
    }

    public String getQualifications() {
        return qualifications;
    }

    public void setQualifications(String qualifications) {
        this.qualifications = qualifications;
    }

    @Override
    public String toString() {
        return "InstructorProfile{" + "userId=" + userId + ", bio=" + bio + ", expertise=" + expertise + ", qualifications=" + qualifications + '}';
    }
    
    
}
