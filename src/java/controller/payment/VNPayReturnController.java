package controller.payment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import service.PaymentService;

@WebServlet("/parent/vnpay-return")
public class VNPayReturnController extends HttpServlet {
        
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String result = paymentService.handleVNPayReturn(request);
        request.setAttribute("result", result);
        request.getRequestDispatcher("/parent/vnpay_result.jsp").forward(request, response);
    }
}
