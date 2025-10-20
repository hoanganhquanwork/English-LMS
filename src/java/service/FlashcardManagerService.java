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
import java.util.List;

public class FlashcardManagerService {
    
    private final FlashcardDAO fDao = new FlashcardDAO();
    private final FlashcardSetDAO fsDAO = new FlashcardSetDAO();
    
    public List<FlashcardSet> getAllSet(String keyword, String sortType) {
        if (keyword == null) {
            keyword = "";
        }
        if (sortType == null) {
            sortType = "newest";
        }
        return fsDAO.searchAllSetsByName(keyword, sortType);
    }
    
    public FlashcardSet getFlashcardSetById(int setId) {
        return fsDAO.getSetById(setId);
    }

    public List<Flashcard> getAllFlashcardById(int setId) {
        return fDao.getCardsBySet(setId);
    }

    public void deleteFlashcard(int cardId) {
        fDao.deleteCard(cardId);
    }

    public void deleteFlashcardSet(int setId) {
        fsDAO.deleteSet(setId);
    }
}
