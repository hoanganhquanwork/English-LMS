package controller.payment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dal.CourseRequestDAO;
import dal.OrderItemDAO;
import model.entity.CourseRequest;
import service.OrderService;
import service.PaymentService;
import service.EnrollmentService;

@WebServlet("/parent/vnpay-return")
public class VNPayReturnController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final OrderService orderService = new OrderService();
    private final EnrollmentService eService = new EnrollmentService();
    private final CourseRequestDAO crdao = new CourseRequestDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();

    private static class ParsedRef {
        int orderId = -1; List<Integer> reqIds = new ArrayList<>();
    }
    private ParsedRef parseRef(String txnRef) {
        ParsedRef p = new ParsedRef();
        if (txnRef != null && txnRef.startsWith("ORD")) {
            try {
                String core = txnRef.substring(3);               // {orderId}_R...
                String[] a = core.split("_R");
                p.orderId = Integer.parseInt(a[0]);
                if (a.length > 1) {
                    String reqPart = a[1].split("_")[0];         // r1-r2-... (bỏ timestamp)
                    for (String s : reqPart.split("-")) {
                        if (!s.isBlank()) p.reqIds.add(Integer.parseInt(s));
                    }
                }
            } catch (Exception ignore) {}
        }
        return p;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        boolean success = "00".equals(responseCode);

        paymentService.updatePaymentStatus(txnRef, success ? "captured" : "failed");

        ParsedRef ref = parseRef(txnRef);
        String result = "fail";

        if (success && ref.orderId > 0) {
            // đánh dấu đơn đã thanh toán
            paymentService.markOrderPaidByTxn(txnRef);

            //  tạo OrderItems + enroll + CR -> approved
            for (Integer reqId : ref.reqIds) {
                CourseRequest cr = crdao.getById(reqId);
                if (cr == null || !"unpaid".equalsIgnoreCase(cr.getStatus())) continue;

                int courseId  = cr.getCourse().getCourseId();
                int studentId = cr.getStudent().getUserId();
                double price  = cr.getCourse().getPrice().doubleValue();

                try {
                    itemDAO.createForOrder(ref.orderId, reqId, courseId, studentId, price);
                } catch (RuntimeException ignoreDup) {
                    // nếu unique (order_id,course_id,student_id) đã tồn tại -> bỏ qua
                }

                eService.enrollAfterPayment(courseId, studentId);
                crdao.updateStatus(reqId, "approved");
            }
            result = "success";
        } else {
            if (ref.orderId > 0) {
                orderService.cancelOrder(ref.orderId);
            }
        }

        request.setAttribute("result", result);
        request.getRequestDispatcher("/parent/vnpay_result.jsp").forward(request, response);
    }
}
