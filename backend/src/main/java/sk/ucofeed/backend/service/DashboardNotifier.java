package sk.ucofeed.backend.service;

public interface DashboardNotifier {
    /**
     * Create a new dashboard message.
     * @param message the text to display on the dashboard
     */
    void notify(String message);
}
