package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.dto.DashboardMessageDTO;

import java.util.UUID;

public interface DashboardNotifier {
    /**
     * Creates a new dashboard message.
     * @param message the text to display in the dashboard message
     */
    void notify(String message);

    default void reviewCreated(StudyProgram studyProgram, UUID userId) {
        notify(DashboardMessageDTO.Review.from(studyProgram, userId));
    }
}
