/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.FlashcardDAO;
import dal.FlashcardSetDAO;
import java.util.List;
import model.entity.Flashcard;
import model.entity.FlashcardSet;
import util.GeminiUtils;

/**
 *
 * @author LENOVO
 */
public class FlashcardAIService {


    private final FlashcardDAO flashcardDAO = new FlashcardDAO();
    private final FlashcardSetDAO setDAO = new FlashcardSetDAO();

    public List<Flashcard> generateAndSave(String prompt, Integer setId, int studentId, String title, String status) {
        if (prompt == null || prompt.trim().isEmpty()) {
            return List.of();
        }

        if (status == null || (!status.equalsIgnoreCase("public") && !status.equalsIgnoreCase("private"))) {
            status = "private";
        }

        try {
            if (setId == null || setId <= 0) {
                FlashcardSet newSet = new FlashcardSet();
                newSet.setStudentId(studentId);

                String cleanTitle = (title != null && !title.trim().isEmpty())
                        ? title.trim()
                        : "AI Generated: " + prompt.substring(0, Math.min(30, prompt.length())).trim();

                newSet.setTitle(cleanTitle);
                newSet.setDescription("Bộ flashcard được tạo tự động bằng Gemini AI.");
                newSet.setStatus(status.toLowerCase());

                setId = setDAO.insertFlashcardSetReturnId(newSet);
            }

            List<Flashcard> cards = GeminiUtils.generateFlashcards(prompt, setId);

            if (cards != null && !cards.isEmpty()) {
                flashcardDAO.insertBatch(cards);
            }

            return cards;

        } catch (Exception e) {    
            e.printStackTrace();
            return List.of();
        }
    }
}
