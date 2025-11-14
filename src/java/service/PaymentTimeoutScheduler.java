package service;

import dal.OrderDAO;
import dal.PaymentDAO;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class PaymentTimeoutScheduler {

    private ScheduledExecutorService scheduler;
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    public void start() {
        if (scheduler != null && !scheduler.isShutdown()) return;

        scheduler = Executors.newSingleThreadScheduledExecutor();

        scheduler.scheduleAtFixedRate(() -> {
                System.out.println("[Scheduler] Cleanup job running...");
                paymentDAO.cleanupExpiredPayments();
                orderDAO.cleanupExpiredOrders();
                System.out.println("[Scheduler] Cleanup job done.");       
        }, 0, 20, TimeUnit.MINUTES);
    }

    public void stop() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
    }
}
