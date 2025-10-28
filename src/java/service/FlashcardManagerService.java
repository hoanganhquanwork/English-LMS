/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.FlashcardDAO;
import dal.FlashcardSetDAO;
import model.entity.Flashcard;
import model.entity.FlashcardSet;
/**
 *
 * @author LENOVO
 */
import dal.FlashcardDAO;
import dal.FlashcardManagerDAO;
import java.util.List;

public class FlashcardManagerService {
    
   
    private final FlashcardManagerDAO setDAO = new FlashcardManagerDAO();
    private final FlashcardDAO cardDAO = new FlashcardDAO();

    public List<FlashcardSet> getAllSets(String keyword, String sortType) {
        return setDAO.getAllSets(keyword, sortType);
    }

    public FlashcardSet getSetById(int setId) {
        return setDAO.getSetById(setId);
    }

    public List<Flashcard> getCardsBySet(int setId) {
        return cardDAO.getCardsBySet(setId);
    }

    public boolean hideSet(int setId) {
        return setDAO.hideSet(setId);
    }

    public boolean activateSet(int setId) {
        return setDAO.activateSet(setId);
    }
}