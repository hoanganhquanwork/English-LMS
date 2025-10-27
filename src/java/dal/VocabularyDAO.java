/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.StudentVocabulary;

/**
 *
 * @author Admin
 */
public class VocabularyDAO extends DBContext {

    public boolean saveAVocabulary(int userId,
            String word,
            String phonetic,
            String audioUrl,
            String partOfSpeech,
            String definition,
            String example,
            String synonyms,
            String antonyms) {
        String sql = "INSERT INTO StudentVocabulary "
                + " (user_id, word, phonetic, audio_url, part_of_speech, definition, example, synonyms, antonyms) "
                + " SELECT ?, ?, ?, ?, ?, ?, ?, ?, ? "
                + " WHERE NOT EXISTS ("
                + "   SELECT 1 FROM StudentVocabulary WHERE user_id = ? AND word = ?"
                + " )";

        if (word == null || word.trim().isEmpty()) {
            return false;
        }
        word = word.trim().toLowerCase();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setString(2, word);
            st.setString(3, phonetic);
            st.setString(4, audioUrl);
            st.setString(5, partOfSpeech);
            st.setString(6, definition);
            st.setString(7, example);
            st.setString(8, synonyms);
            st.setString(9, antonyms);
            st.setInt(10, userId);
            st.setString(11, word);

            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<StudentVocabulary> listVocabulary(int userId, String keyword,
            String sortKey, int page, int pageSize) {
        List<StudentVocabulary> listVocab = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT vocab_id, user_id, word, phonetic, audio_url, "
                + "               part_of_speech, definition, example, synonyms, antonyms, saved_at "
                + "        FROM StudentVocabulary "
                + "        WHERE user_id = ?");
        boolean hasKeyword = (keyword != null && !keyword.isBlank());
        if (hasKeyword) {
            sb.append(" AND word LIKE ?");
        }

        String orderBy;
        if (sortKey == null) {
            sortKey = "";
        }
        switch (sortKey) {
            case "created_asc":
                orderBy = "saved_at ASC, vocab_id ASC";
                break;
            case "word_asc":
                orderBy = "word ASC";
                break;
            case "word_desc":
                orderBy = "word DESC";
                break;
            case "created_desc":
            default:
                orderBy = "saved_at DESC, vocab_id DESC";
                break;
        }
        sb.append(" ORDER BY ").append(orderBy);

        if (page < 1) {
            page = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }

        int offset = (page - 1) * pageSize;

        sb.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            PreparedStatement st = connection.prepareStatement(sb.toString());
            int i = 1;
            st.setInt(i++, userId);
            if (hasKeyword) {
                st.setString(i++, "%" + keyword.trim() + "%");
            }
            st.setInt(i++, offset);
            st.setInt(i++, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                StudentVocabulary v = new StudentVocabulary();
                v.setVocabId(rs.getInt("vocab_id"));
                v.setUserId(rs.getInt("user_id"));
                v.setWord(rs.getString("word"));
                v.setPhonetic(rs.getString("phonetic"));
                v.setAudioUrl(rs.getString("audio_url"));
                v.setPartOfSpeech(rs.getString("part_of_speech"));
                v.setDefinition(rs.getString("definition"));
                v.setExample(rs.getString("example"));
                v.setSynonyms(rs.getString("synonyms"));
                v.setAntonyms(rs.getString("antonyms"));
                java.sql.Timestamp ts = rs.getTimestamp("saved_at");
                v.setSavedAt(ts == null ? null : ts.toLocalDateTime());
                listVocab.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listVocab;
    }

    public int countVocabulary(int userId, String keyword) {
        StringBuilder sb = new StringBuilder(
                "SELECT COUNT(*) FROM StudentVocabulary WHERE user_id = ?"
        );

        boolean hasKeyword = (keyword != null && !keyword.isBlank());
        if (hasKeyword) {
            sb.append(" AND word LIKE ?");
        }

        try (PreparedStatement st = connection.prepareStatement(sb.toString())) {
            int i = 1;
            st.setInt(i++, userId);
            if (hasKeyword) {
                st.setString(i++, "%" + keyword + "%");
            }
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
