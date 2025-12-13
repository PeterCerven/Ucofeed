package sk.ucofeed.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sk.ucofeed.backend.exception.ReviewNotFoundException;
import sk.ucofeed.backend.exception.StudyProgramNotFoundException;
import sk.ucofeed.backend.exception.UnauthorizedReviewActionException;
import sk.ucofeed.backend.exception.UserNotEnrolledException;
import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ErrorDto;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.dto.UpdateReviewRequest;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.ReviewRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UserEducationRepository;

import java.util.Comparator;
import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    private static final Logger LOG = LoggerFactory.getLogger(ReviewServiceImpl.class);

    private final ReviewRepository reviewRepository;
    private final StudyProgramRepository studyProgramRepository;
    private final UserEducationRepository userEducationRepository;
    private final DashboardNotifier dashboardNotifier;

    public ReviewServiceImpl(
            ReviewRepository reviewRepository,
            StudyProgramRepository studyProgramRepository,
            UserEducationRepository userEducationRepository,
            DashboardNotifier dashboardNotifier
    ) {
        this.reviewRepository = reviewRepository;
        this.studyProgramRepository = studyProgramRepository;
        this.userEducationRepository = userEducationRepository;
        this.dashboardNotifier = dashboardNotifier;
    }

    @Override
    @Transactional
    public ReviewResponse createReview(User user, CreateReviewRequest request) {
        LOG.info("Creating review for user {} and study program {}",
                user.getId(), request.studyProgramId());

        // Step 1: Validate study program exists
        StudyProgram studyProgram = studyProgramRepository
                .findById(request.studyProgramId())
                .orElseThrow(() -> StudyProgramNotFoundException.builder()
                        .errorType(ErrorDto.ErrorType.STUDY_PROGRAM_NOT_FOUND)
                        .message("Study program not found with ID: " + request.studyProgramId())
                        .build());

        // Step 3: Validate user enrollment and get StudyProgramVariant
        StudyProgramVariant variant = validateEnrollmentAndGetVariant(user, studyProgram);

        // Step 4: Create and save review
        Review review = Review.builder()
                .studyProgram(studyProgram)
                .studyProgramVariant(variant)
                .user(user)
                .rating(request.rating())
                .comment(request.comment())
                .anonymous(request.anonymous())
                .build();

        review = reviewRepository.save(review);
        LOG.info("Review created successfully with ID: {}", review.getId());

        dashboardNotifier.reviewCreated(studyProgram, user.getId());

        return ReviewResponse.from(review);
    }

    /**
     * Validates user enrollment and selects appropriate StudyProgramVariant.
     * Priority order: ENROLLED > ON_HOLD > COMPLETED
     * Throws UserNotEnrolledException if user is not eligible to review.
     */
    private StudyProgramVariant validateEnrollmentAndGetVariant(
            User user, StudyProgram studyProgram) {

        // Get all user educations for this study program
        List<UserEducation> educations = userEducationRepository.findByUser(user)
                .stream()
                .filter(ed -> ed.getStudyProgram().getId().equals(studyProgram.getId()))
                .filter(ed -> ed.getStatus() != UserEducation.Status.DROPPED_OUT)
                .toList();

        if (educations.isEmpty()) {
            throw UserNotEnrolledException.builder()
                    .errorType(ErrorDto.ErrorType.USER_NOT_ENROLLED)
                    .message(String.format(
                            "You must be enrolled in %s to write a review",
                            studyProgram.getName()))
                    .build();
        }

        // Select variant with highest priority status
        UserEducation selectedEducation = educations.stream()
                .min(Comparator.comparing(ed -> getStatusPriority(ed.getStatus())))
                .orElseThrow(); // Should never happen due to isEmpty check

        LOG.info("Selected variant {} for user {} with status {}",
                selectedEducation.getStudyProgramVariant().getId(),
                user.getId(),
                selectedEducation.getStatus());

        return selectedEducation.getStudyProgramVariant();
    }

    /**
     * Returns priority value for status ordering (lower = higher priority).
     */
    private int getStatusPriority(UserEducation.Status status) {
        return switch (status) {
            case ENROLLED -> 1;
            case ON_HOLD -> 2;
            case COMPLETED -> 3;
            case DROPPED_OUT -> 4; // Should never reach here due to filter
        };
    }

    @Override
    @Transactional
    public ReviewResponse updateReview(User user, Long reviewId, UpdateReviewRequest request) {
        LOG.info("Updating review {} by user {}", reviewId, user.getId());

        // Find review and verify ownership
        Review review = reviewRepository.findByIdAndUser(reviewId, user)
                .orElseThrow(() -> {
                    // Check if review exists at all
                    if (!reviewRepository.existsById(reviewId)) {
                        return ReviewNotFoundException.builder()
                                .errorType(ErrorDto.ErrorType.REVIEW_NOT_FOUND)
                                .message("Review not found with ID: " + reviewId)
                                .build();
                    }
                    // Review exists but user is not the owner
                    return UnauthorizedReviewActionException.builder()
                            .errorType(ErrorDto.ErrorType.UNAUTHORIZED_REVIEW_ACTION)
                            .message("You are not authorized to edit this review")
                            .build();
                });

        // Update fields
        review.setRating(request.rating());
        review.setComment(request.comment());
        review.setAnonymous(request.anonymous());

        review = reviewRepository.save(review);
        LOG.info("Review {} updated successfully", reviewId);

        return ReviewResponse.from(review);
    }

    @Override
    @Transactional
    public void deleteReview(User user, Long reviewId) {
        LOG.info("Deleting review {} by user {}", reviewId, user.getId());

        // Find review and verify ownership
        Review review = reviewRepository.findByIdAndUser(reviewId, user)
                .orElseThrow(() -> {
                    // Check if review exists at all
                    if (!reviewRepository.existsById(reviewId)) {
                        return ReviewNotFoundException.builder()
                                .errorType(ErrorDto.ErrorType.REVIEW_NOT_FOUND)
                                .message("Review not found with ID: " + reviewId)
                                .build();
                    }
                    // Review exists but user is not the owner
                    return UnauthorizedReviewActionException.builder()
                            .errorType(ErrorDto.ErrorType.UNAUTHORIZED_REVIEW_ACTION)
                            .message("You are not authorized to delete this review")
                            .build();
                });

        reviewRepository.delete(review);
        LOG.info("Review {} deleted successfully", reviewId);
    }

    @Override
    public boolean canCreateReview(User user, Long studyProgramId) {
        // Check if study program exists
        StudyProgram studyProgram = studyProgramRepository.findById(studyProgramId)
                .orElse(null);

        if (studyProgram == null) {
            return false;
        }

        // Check if user already has a review for this program
        if (reviewRepository.existsByUserAndStudyProgram(user, studyProgram)) {
            return false;
        }

        // Check if user is enrolled (ENROLLED, ON_HOLD, or COMPLETED - not DROPPED_OUT)
        List<UserEducation> enrollments = userEducationRepository.findByUser(user)
                .stream()
                .filter(ed -> ed.getStudyProgram().getId().equals(studyProgramId))
                .filter(ed -> ed.getStatus() != UserEducation.Status.DROPPED_OUT)
                .toList();

        return !enrollments.isEmpty();
    }

    @Override
    public List<ReviewResponse> getReviewsByStudyProgram(Long studyProgramId) {
        StudyProgram studyProgram = studyProgramRepository.findById(studyProgramId)
                .orElseThrow(() -> StudyProgramNotFoundException.builder()
                        .errorType(ErrorDto.ErrorType.STUDY_PROGRAM_NOT_FOUND)
                        .message("Study program not found with ID: " + studyProgramId)
                        .build());

        return reviewRepository.findByStudyProgramOrderByCreatedAtDesc(studyProgram)
                .stream()
                .map(ReviewResponse::from)
                .toList();
    }

    @Override
    public List<ReviewResponse> getReviewsByUser(User user) {
        return reviewRepository.findByUser(user)
                .stream()
                .map(ReviewResponse::from)
                .toList();
    }
}
