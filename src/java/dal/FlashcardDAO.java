package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.Flashcard;

public class FlashcardDAO extends DBContext {

    public void insertFlashcard(Flashcard card) {
        String sql = "INSERT INTO Flashcards(set_id, front_text, back_text) VALUES (?,?,?)";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, card.getSetId());
            stm.setString(2, card.getFrontText());
            stm.setString(3, card.getBackText());
            stm.executeUpdate();
            // touch parent set updated_at to now
            touchSetUpdatedAt(card.getSetId());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Flashcard> getCardsBySet(int setId) {
        List<Flashcard> list = new ArrayList<>();
        String sql = "SELECT * FROM Flashcards WHERE set_id=?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, setId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Flashcard(
                        rs.getInt("card_id"),
                        rs.getInt("set_id"),
                        rs.getString("front_text"),
                        rs.getString("back_text")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Flashcard getCardById(int cardId) {
        Flashcard card = null;
        String sql = "SELECT * FROM Flashcards WHERE card_id=?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, cardId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                card = new Flashcard(
                        rs.getInt("card_id"),
                        rs.getInt("set_id"),
                        rs.getString("front_text"),
                        rs.getString("back_text")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return card;
    }

    public void updateCard(int cardId, String front, String back) {
        String sql = "UPDATE Flashcards SET front_text=?, back_text=?, updated_at=GETDATE() WHERE card_id=?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, front);
            stm.setString(2, back);
            stm.setInt(3, cardId);
            stm.executeUpdate();
            // update parent set updated_at based on this card's set
            Integer setId = getSetIdByCardId(cardId);
            if (setId != null) {
                touchSetUpdatedAt(setId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteCard(int cardId) {
        String sql = "DELETE FROM Flashcards WHERE card_id=?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, cardId);
            stm.executeUpdate();
            Integer setId = getSetIdByCardId(cardId);
            if (setId != null) {
                touchSetUpdatedAt(setId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Integer getSetIdByCardId(int cardId) {
        String sql = "SELECT set_id FROM Flashcards WHERE card_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cardId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void touchSetUpdatedAt(int setId) {
        String sql = "UPDATE FlashcardSets SET updated_at=GETDATE() WHERE set_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, setId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertBatch(List<Flashcard> cards) {
        String sql = "INSERT INTO Flashcards (set_id, front_text, back_text) VALUES (?, ?, ?)";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            for (Flashcard c : cards) {
                stm.setInt(1, c.getSetId());
                stm.setString(2, c.getFrontText());
                stm.setString(3, c.getBackText());
                stm.addBatch();
            }
            stm.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Flashcard> getBySetId(int setId) {
        List<Flashcard> list = new ArrayList<>();
        String sql = "SELECT card_id, set_id, front_text, back_text FROM Flashcards WHERE set_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, setId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Flashcard f = new Flashcard(
                        rs.getInt("card_id"),
                        rs.getInt("set_id"),
                        rs.getString("front_text"),
                        rs.getString("back_text")
                );
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
