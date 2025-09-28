package model;

public class ParentProfile {
    private int userId;
    private String address;
    private String occupation;

    public ParentProfile() {}

    public ParentProfile(int userId, String address, String occupation) {
        this.userId = userId;
        this.address = address;
        this.occupation = occupation;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getOccupation() {
        return occupation;
    }
    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }
}
