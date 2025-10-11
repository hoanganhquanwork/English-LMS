/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.DiscussionDAO;
import model.entity.Discussion;

/**
 *
 * @author Lenovo
 */
public class DiscussionService {

    private DiscussionDAO discussionDAO = new DiscussionDAO();

    public boolean createDiscussion(int moduleId, String title, String description) {
        return discussionDAO.insertDiscussion(moduleId, title, description);
    }

    public Discussion getDiscussion(int id) {
        return discussionDAO.getDiscussionById(id);
    }

}
