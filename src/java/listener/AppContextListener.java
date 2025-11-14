package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import service.PaymentTimeoutScheduler;

@WebListener
public class AppContextListener implements ServletContextListener {

    private PaymentTimeoutScheduler scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println(">>> Application starting...");
        scheduler = new PaymentTimeoutScheduler();
        scheduler.start();
        System.out.println(">>> PaymentTimeoutScheduler STARTED");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println(">>> Application shutting down...");
        if (scheduler != null) {
            scheduler.stop();
            System.out.println(">>> PaymentTimeoutScheduler STOPPED");
        }
    }
}
