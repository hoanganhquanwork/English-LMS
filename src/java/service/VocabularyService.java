/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.VocabularyDAO;
import java.util.List;
import model.entity.StudentVocabulary;

/**
 *
 * @author Admin
 */
public class VocabularyService {

    VocabularyDAO vdao = new VocabularyDAO();

    public boolean saveAVocabulary(int userId,
            String word,
            String phonetic,
            String audioUrl,
            String partOfSpeech,
            String definition,
            String example,
            String synonyms,
            String antonyms) {

        return vdao.saveAVocabulary(userId, word, phonetic, audioUrl,
                partOfSpeech, definition, example, synonyms, antonyms);
    }

    public List<StudentVocabulary> listVocabulary(int userId, String keyword,
            String sortKey, int page, int pageSize) {
        if (keyword != null && keyword.isEmpty()) {
            keyword = null;
        }
        return vdao.listVocabulary(userId, keyword, sortKey, page, pageSize);
    }

    public int countVocabulary(int userId, String keyword) {
        if (keyword != null && keyword.isEmpty()) {
            keyword = null;
        }
        return vdao.countVocabulary(userId, keyword);
    }
}
