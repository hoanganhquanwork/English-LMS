/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Admin
 */
public class InstructorProfile {

    private Users user;
    private String bio;
    private String expertise;
    private String qualifications;

    public InstructorProfile() {
    }

    public InstructorProfile(Users user, String bio, String expertise, String qualifications) {
        this.user = user;
        this.bio = bio;
        this.expertise = expertise;
        this.qualifications = qualifications;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
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



}
