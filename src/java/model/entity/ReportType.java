package model.entity;

public class ReportType {

    private int typeId;
    private String role;
    private String name;
    private boolean isActive;

    // Constructors
    public ReportType() {
    }

    public ReportType(int typeId, String role, String name, boolean isActive) {
        this.typeId = typeId;
        this.role = role;
        this.name = name;
        this.isActive = isActive;
    }

    // Getters & setters
    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
