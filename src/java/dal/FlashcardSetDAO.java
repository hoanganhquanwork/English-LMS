package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.FlashcardSet;

public class FlashcardSetDAO extends DBContext {
    
public int insertFlashcardSetReturnId(FlashcardSet set) {
        String sql = "INSERT INTO FlashcardSets(student_id, title, description, status) VALUES (?,?,?,?)";
        try {
            PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setInt(1, set.getStudentId());
            stm.setString(2, set.getTitle());
            stm.setString(3, set.getDescription());
            stm.setString(4, set.getStatus() != null ? set.getStatus() : "private");
            stm.executeUpdate();

            ResultSet rs = stm.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<FlashcardSet> getSetsByStudent(int studentId) {
        List<FlashcardSet> list = new ArrayList<>();
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, "
                + "COUNT(c.card_id) AS termCount, u.username AS authorUsername "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                + "JOIN Users u ON s.student_id = u.user_id "
                + "WHERE s.student_id = ? "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                + "ORDER BY s.set_id DESC";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, studentId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorUsername")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public FlashcardSet getSetById(int setId) {
        FlashcardSet set = null;
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, "
                + "s.created_at, s.updated_at, "
                + "MAX(COALESCE(c.updated_at, c.created_at)) AS lastCardActivity, "
                + "COUNT(c.card_id) AS termCount, u.username AS authorUsername "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                + "JOIN Users u ON s.student_id = u.user_id "
                + "WHERE s.set_id = ? "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, s.created_at, s.updated_at, u.username";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, setId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                set = new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorUsername")
                );
                set.setCreatedAt(rs.getTimestamp("created_at"));
                set.setUpdatedAt(rs.getTimestamp("updated_at"));
                set.setLastActivityAt(rs.getTimestamp("lastCardActivity"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return set;
    }

    public void updateSet(int setId, String title, String description, String status) {
        String sql = "UPDATE FlashcardSets SET title=?, description=?, status=?, updated_at=GETDATE() WHERE set_id=?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, title);
            stm.setString(2, description);
            stm.setString(3, status);
            stm.setInt(4, setId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteSet(int setId) {
        String sqlCards = "DELETE FROM Flashcards WHERE set_id=?";
        String sqlSet = "DELETE FROM FlashcardSets WHERE set_id=?";
        try {
            PreparedStatement stm1 = connection.prepareStatement(sqlCards);
            stm1.setInt(1, setId);
            stm1.executeUpdate();

            PreparedStatement stm2 = connection.prepareStatement(sqlSet);
            stm2.setInt(1, setId);
            stm2.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

      public List<FlashcardSet> getAllSets() {
        List<FlashcardSet> list = new ArrayList<>();
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, "
                + "COUNT(c.card_id) AS termCount, u.username AS authorUsername "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                + "JOIN Users u ON s.student_id = u.user_id "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                + "ORDER BY s.set_id DESC";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorUsername")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FlashcardSet> searchMySets(int studentId, String keyword) {
        List<FlashcardSet> list = new ArrayList<>();
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, "
                + "COUNT(c.card_id) AS termCount, u.username AS authorUsername "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                + "JOIN Users u ON s.student_id = u.user_id "
                + "WHERE s.student_id=? "
                + "  AND (s.title COLLATE SQL_Latin1_General_Cp1253_CI_AI LIKE ? "
                + "       OR COALESCE(s.description,'') COLLATE SQL_Latin1_General_Cp1253_CI_AI LIKE ?) "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                + "ORDER BY s.set_id DESC";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, studentId);
            String kw = "%" + keyword + "%";
            stm.setString(2, kw);
            stm.setString(3, kw);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorUsername")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FlashcardSet> searchAllSets(String keyword) {
        List<FlashcardSet> list = new ArrayList<>();
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, COUNT(c.card_id) AS termCount, "
                + "u.username AS authorUsername "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                + "LEFT JOIN Users u ON s.student_id = u.user_id "
                + "WHERE s.status <> 'private' "
                + "  AND (s.title COLLATE SQL_Latin1_General_Cp1253_CI_AI LIKE ? "
                + "       OR COALESCE(s.description,'') COLLATE SQL_Latin1_General_Cp1253_CI_AI LIKE ?) "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                + "ORDER BY s.set_id DESC";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            stm.setString(1, kw);
            stm.setString(2, kw);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorUsername")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FlashcardSet> searchAllSetsByName(String keyword, String sortType) {
        List<FlashcardSet> list = new ArrayList<>();
        String orderClause = "ORDER BY s.set_id DESC";
        if ("oldest".equalsIgnoreCase(sortType)) {
            orderClause = "ORDER BY s.set_id ASC";
        } else if ("az".equalsIgnoreCase(sortType)) {
            orderClause = "ORDER BY s.title ASC";
        } else if ("za".equalsIgnoreCase(sortType)) {
            orderClause = "ORDER BY s.title DESC";
        }

        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, COUNT(f.card_id) AS termCount, "
                + "u.username AS authorName "
                + "FROM FlashcardSets s "
                + "LEFT JOIN Flashcards f ON s.set_id = f.set_id "
                + "LEFT JOIN Users u ON s.student_id = u.user_id "
                + "WHERE s.status <> 'private' "
                + "  AND (s.title LIKE ? OR s.description LIKE ? OR u.username LIKE ?) "
                + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                + orderClause;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new FlashcardSet(
                        rs.getInt("set_id"),
                        rs.getInt("student_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("termCount"),
                        rs.getString("status"),
                        rs.getString("authorName")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
