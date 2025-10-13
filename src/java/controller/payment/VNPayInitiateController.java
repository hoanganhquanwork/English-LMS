package controller.payment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import service.PaymentService;
import util.VNPayConfig;

// NEW
import dal.CourseRequestDAO;
import model.entity.CourseRequest;

@WebServlet("/parent/vnpay-initiate")
public class VNPayInitiateController extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();
    // NEW
    private final CourseRequestDAO crdao = new CourseRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(
                String.valueOf(request.getAttribute("orderId") != null
                    ? request.getAttribute("orderId")
                    : request.getParameter("orderId"))
            );

            // NEW: nhận danh sách requestIds (nếu có)
            String reqJoined = (String) request.getAttribute("requestIds");
            if (reqJoined == null) reqJoined = request.getParameter("requestIds");

            double amount;
            String txnRef;

            if (reqJoined != null && !reqJoined.isBlank()) {
                // NEW: tính tổng tiền từ CourseRequest 'unpaid'
                amount = 0d;
                for (String s : reqJoined.split("-")) {
                    if (s.isBlank()) continue;
                    int reqId = Integer.parseInt(s);
                    CourseRequest cr = crdao.getById(reqId);
                    if (cr != null && "unpaid".equalsIgnoreCase(cr.getStatus())) {
                        amount += cr.getCourse().getPrice().doubleValue();
                    }
                }
                if (amount <= 0) throw new IllegalStateException("Tổng tiền không hợp lệ.");
                // NEW: gói danh sách CR vào txnRef để return parse
                txnRef = "ORD" + orderId + "_R" + reqJoined + "_" + System.currentTimeMillis();
            } else {
                // luồng cũ: lấy tổng theo order nếu cần
                amount = paymentService.getOrderTotal(orderId);
                txnRef = "ORD" + orderId + "_" + System.currentTimeMillis();
            }

            paymentService.createPayment(orderId, amount, "card", txnRef);

            Map<String, String> vnp_Params = new LinkedHashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf((long) (amount * 100)));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", txnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang #" + orderId);
            vnp_Params.put("vnp_OrderType", "billpayment");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", request.getRemoteAddr());
            vnp_Params.put("vnp_CreateDate",
                    new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));

            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            for (Iterator<String> itr = fieldNames.iterator(); itr.hasNext();) {
                String name = itr.next();
                String value = vnp_Params.get(name);
                if (value != null && !value.isEmpty()) {
                    hashData.append(name).append('=')
                            .append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                    query.append(URLEncoder.encode(name, StandardCharsets.US_ASCII))
                         .append('=')
                         .append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                    if (itr.hasNext()) { hashData.append('&'); query.append('&'); }
                }
            }

            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);

            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query;
            response.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khởi tạo thanh toán VNPay: " + e.getMessage());
        }
    }
}
