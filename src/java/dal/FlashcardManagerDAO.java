/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.entity.FlashcardSet;

public class FlashcardManagerDAO extends DBContext {

    public List<FlashcardSet> getAllSets(String keyword, String sortType) {
        List<FlashcardSet> list = new ArrayList<>();
        String order = switch (sortType == null ? "" : sortType.toLowerCase()) {
            case "oldest" -> "ORDER BY s.set_id ASC";
            case "az" -> "ORDER BY s.title ASC";
            case "za" -> "ORDER BY s.title DESC";
            default -> "ORDER BY s.set_id DESC";
        };

        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, COUNT(f.card_id) AS termCount, "
                   + "u.username AS authorName "
                   + "FROM FlashcardSets s "
                   + "LEFT JOIN Flashcards f ON s.set_id = f.set_id "
                   + "JOIN Users u ON s.student_id = u.user_id "
                   + "WHERE s.status IN ('public', 'inactive') "
                   + "AND (s.title LIKE ? OR s.description LIKE ? OR u.username LIKE ?) "
                   + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username "
                   + order;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + (keyword == null ? "" : keyword) + "%";
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

    public FlashcardSet getSetById(int setId) {
        String sql = "SELECT s.set_id, s.student_id, s.title, s.description, s.status, "
                   + "COUNT(c.card_id) AS termCount, u.username AS authorName "
                   + "FROM FlashcardSets s "
                   + "LEFT JOIN Flashcards c ON s.set_id = c.set_id "
                   + "JOIN Users u ON s.student_id = u.user_id "
                   + "WHERE s.set_id=? "
                   + "GROUP BY s.set_id, s.student_id, s.title, s.description, s.status, u.username";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, setId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new FlashcardSet(
                    rs.getInt("set_id"),
                    rs.getInt("student_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getInt("termCount"),
                    rs.getString("status"),
                    rs.getString("authorName")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hideSet(int setId) {
        String sql = "UPDATE FlashcardSets SET status='inactive', updated_at=GETDATE() WHERE set_id=? AND status='public'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, setId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    
    public boolean activateSet(int setId) {
        String sql = "UPDATE FlashcardSets SET status='public', updated_at=GETDATE() WHERE set_id=? AND status='inactive'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, setId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}