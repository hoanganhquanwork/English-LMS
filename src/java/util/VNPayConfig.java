package util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VNPayConfig {
    // ==== Thông tin cấu hình sandbox demo ====
    public static final String vnp_TmnCode = "58X4B4HP";
    public static final String vnp_HashSecret = "VRLDWNVWDNPCOEPBZUTWSEDQAGXJCNGZ";
    public static final String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String vnp_ReturnUrl = "http://localhost:8080/EnglishLMS/parent/vnpay-return";

    // ==== Hỗ trợ ký HMAC SHA512 ====
    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) {
                hash.append(String.format("%02x", b));
            }
            return hash.toString();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi tạo HMAC SHA512", e);
        }
    }

    // ==== Hàm tiện ích nối param ====
    public static String hashAllFields(Map<String, String> fields) throws UnsupportedEncodingException {
        StringBuilder sb = new StringBuilder();
        Iterator<Map.Entry<String, String>> itr = fields.entrySet().iterator();
        while (itr.hasNext()) {
            Map.Entry<String, String> entry = itr.next();
            sb.append(entry.getKey()).append('=')
              .append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII));
            if (itr.hasNext()) sb.append('&');
        }
        return sb.toString();
    }
}
