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

@WebServlet("/parent/vnpay-initiate")
public class VNPayInitiateController extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            double amount = paymentService.getOrderTotal(orderId);
            String txnRef = "ORD" + orderId + "_" + System.currentTimeMillis();

            // 1️⃣ Tạo bản ghi Payment
            paymentService.createPayment(orderId, amount, "card", txnRef);

            // 2️⃣ Tham số gửi sang VNPay
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

            // 3️⃣ Sinh chuỗi hash
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
                    if (itr.hasNext()) {
                        hashData.append('&');
                        query.append('&');
                    }
                }
            }

            // 4️⃣ Tạo secure hash
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);

            // 5️⃣ Redirect sang VNPay
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query;
            response.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khởi tạo thanh toán VNPay: " + e.getMessage());
        }
    }
}
