package dal;

import java.sql.*;
import model.entity.Payment;

public class PaymentDAO extends DBContext {

    // Thêm bản ghi Payment khi khởi tạo VNPay
    public void insertPayment(int orderId, double amount, String method, String txnRef) {
        String sql = """
            INSERT INTO Payments (order_id, amount_vnd, payment_method, status, txn_ref)
            VALUES (?, ?, ?, 'initiated', ?)
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            stm.setDouble(2, amount);
            stm.setString(3, method);
            stm.setString(4, txnRef);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật trạng thái thanh toán (captured / failed)
    public void updatePaymentStatus(String txnRef, String status) {
        String sql = "UPDATE Payments SET status=?, captured_at=GETDATE() WHERE txn_ref=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setString(2, txnRef);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật đơn hàng khi thanh toán thành công
    public void updateOrderPaidByTxn(String txnRef) {
        String sql = """
            UPDATE Orders
            SET status='paid', paid_at=GETDATE()
            WHERE order_id = (SELECT order_id FROM Payments WHERE txn_ref=?)
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, txnRef);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Kiểm tra xem order đã có payment chưa
    public boolean hasPaymentForOrder(int orderId) {
        String sql = "SELECT 1 FROM Payments WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoá payment theo orderId (nếu huỷ order)
    public void deletePaymentByOrder(int orderId) {
        String sql = "DELETE FROM Payments WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Tính tổng tiền của order
    public double getOrderTotal(int orderId) {
        String sql = "SELECT SUM(price_vnd) FROM OrderItems WHERE order_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, orderId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Payment getPaymentByTxnRef(String txnRef) {
        String sql = "SELECT * FROM Payments WHERE txn_ref = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, txnRef);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setOrderId(rs.getInt("order_id"));
                p.setAmount(rs.getDouble("amount_vnd"));
                p.setMethod(rs.getString("payment_method"));
                p.setStatus(rs.getString("status"));
                p.setTxnRef(rs.getString("txn_ref"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setCapturedAt(rs.getTimestamp("captured_at"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cleanupExpiredPayments() {
        String sql = """
        UPDATE Payments
        SET status = 'failed'
        WHERE status = 'initiated'
          AND created_at < DATEADD(MINUTE, -30, GETDATE());
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
