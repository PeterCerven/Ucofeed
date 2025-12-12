package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.dto.DashboardReviewMessageDataDTO;

import java.util.UUID;

public interface DashboardNotifier {
    /**
     * Create a new dashboard message.
     * @param message the text to display on the dashboard
     */
    void notify(String message);

    default void reviewCreated(StudyProgram studyProgram, UUID userId) {
        notify(DashboardReviewMessageDataDTO.from(studyProgram, userId));
    }
}
