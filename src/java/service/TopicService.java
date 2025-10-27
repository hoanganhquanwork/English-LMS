/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TopicDAO;
import model.entity.Topic;
import java.util.List;

/**
 *
 * @author Lenovo
 */
public class TopicService {
    
    private TopicDAO topicDAO = new TopicDAO();
    
    public List<Topic> getAllTopics() {
        return topicDAO.getAllTopics();
    }
    
    public Topic getTopicById(int topicId) {
        return topicDAO.getTopicById(topicId);
    }
}
