package service;

import java.util.List;
import dal.FlashcardDAO;
import dal.FlashcardSetDAO;
import model.entity.Flashcard;
import model.entity.FlashcardSet;

public class FlashcardService {
    private FlashcardSetDAO setDAO = new FlashcardSetDAO();
    private FlashcardDAO cardDAO = new FlashcardDAO();

    // --- FlashcardSet ---
    public int createSetReturnId(FlashcardSet set) {
        return setDAO.insertFlashcardSetReturnId(set);
    }

    public List<FlashcardSet> getSetsByStudent(int studentId) {
        return setDAO.getSetsByStudent(studentId);
    }

    public FlashcardSet getSetById(int setId) {
        return setDAO.getSetById(setId);
    }

    public void updateSet(int setId, String title, String description) {
        setDAO.updateSet(setId, title, description);
    }

    public void deleteSet(int setId) {
        setDAO.deleteSet(setId);
    }

    public List<FlashcardSet> searchMySets(int studentId, String keyword) {
        return setDAO.searchMySets(studentId, keyword);
    }

    // --- Flashcard ---
    public void addCards(List<Flashcard> cards) {
        for (Flashcard card : cards) {
            cardDAO.insertFlashcard(card);
        }
    }

    public List<Flashcard> getCardsBySet(int setId) {
        return cardDAO.getCardsBySet(setId);
    }

    public Flashcard getCardById(int cardId) {
        return cardDAO.getCardById(cardId);
    }

    public void updateCard(int cardId, String front, String back) {
        cardDAO.updateCard(cardId, front, back);
    }

    public void deleteCard(int cardId) {
        cardDAO.deleteCard(cardId);
    }

    public List<FlashcardSet> getAllSets() {
       return setDAO.getAllSets();
    }

    public List<FlashcardSet> searchAllSets(String trim) {
        return setDAO.searchAllSets(trim);
    }
    // --- Authorization ---

public boolean canEditSet(int setId, int studentId) {
    FlashcardSet set = getSetById(setId);
    return set != null && set.getStudentId() == studentId;
}

public boolean updateSetIfOwner(int setId, int studentId, String title, String description) {
    if (canEditSet(setId, studentId)) {
        updateSet(setId, title, description);
        return true;
    }
    return false;
}

public boolean deleteSetIfOwner(int setId, int studentId) {
    if (canEditSet(setId, studentId)) {
        deleteSet(setId);
        return true;
    }
    return false;
}

}

