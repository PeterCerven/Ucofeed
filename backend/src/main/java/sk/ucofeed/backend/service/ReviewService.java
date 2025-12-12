package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.model.User;

import java.util.List;

public interface ReviewService {
    /**
     * Creates a new review for a study program.
     *
     * @param user Authenticated user creating the review
     * @param request Review creation data
     * @return Created review details
     * @throws sk.ucofeed.backend.exception.StudyProgramNotFoundException if study program doesn't exist
     * @throws sk.ucofeed.backend.exception.UserNotEnrolledException if user is not enrolled in the program
     */
    ReviewResponse createReview(User user, CreateReviewRequest request);

    /**
     * Get all reviews for a specific study program.
     */
    List<ReviewResponse> getReviewsByStudyProgram(Long studyProgramId);

    /**
     * Get all reviews created by a user.
     */
    List<ReviewResponse> getReviewsByUser(User user);
}
