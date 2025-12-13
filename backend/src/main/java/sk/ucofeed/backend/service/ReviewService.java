package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.dto.UpdateReviewRequest;
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
     * Updates an existing review.
     * Only the owner can update their review.
     *
     * @param user Authenticated user
     * @param reviewId ID of review to update
     * @param request Update data
     * @return Updated review
     * @throws sk.ucofeed.backend.exception.ReviewNotFoundException if review doesn't exist
     * @throws sk.ucofeed.backend.exception.UnauthorizedReviewActionException if user is not the owner
     */
    ReviewResponse updateReview(User user, Long reviewId, UpdateReviewRequest request);

    /**
     * Deletes a review.
     * Only the owner can delete their review.
     *
     * @param user Authenticated user
     * @param reviewId ID of review to delete
     * @throws sk.ucofeed.backend.exception.ReviewNotFoundException if review doesn't exist
     * @throws sk.ucofeed.backend.exception.UnauthorizedReviewActionException if user is not the owner
     */
    void deleteReview(User user, Long reviewId);

    /**
     * Checks if user can create a review for a study program.
     * User must be enrolled with status: ENROLLED, ON_HOLD, or COMPLETED.
     *
     * @param user Authenticated user
     * @param studyProgramId Study program ID
     * @return true if user can create review, false otherwise
     */
    boolean canCreateReview(User user, Long studyProgramId);

    /**
     * Get all reviews for a specific study program.
     *
     * @param studyProgramId Study program ID
     * @param currentUser Optionally authenticated user (null if public request)
     * @return List of reviews with isOwner flag calculated
     */
    List<ReviewResponse> getReviewsByStudyProgram(Long studyProgramId, User currentUser);

    /**
     * Get all reviews created by a user.
     */
    List<ReviewResponse> getReviewsByUser(User user);
}
