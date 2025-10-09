/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

/**
 *
 * @author Lenovo
 */
public class ModuleItem {

    private int moduleItemId;
    private int moduleId;
    private String itemType;  // lesson, quiz, assignment, discussion
    private int orderIndex;
    private boolean required;

    public ModuleItem() {
    }

    public ModuleItem(int moduleItemId, int moduleId, String itemType, int orderIndex, boolean required) {
        this.moduleItemId = moduleItemId;
        this.moduleId = moduleId;
        this.itemType = itemType;
        this.orderIndex = orderIndex;
        this.required = required;
    }

    public int getModuleItemId() {
        return moduleItemId;
    }

    public void setModuleItemId(int moduleItemId) {
        this.moduleItemId = moduleItemId;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public boolean isRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }
    
    
}
