package sk.ucofeed.backend.controller.external;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.service.ReviewService;

import java.util.List;

@RestController
@RequestMapping("/api/public/review")
public class ReviewController {

    private static final Logger LOG = LoggerFactory.getLogger(ReviewController.class);

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    /**
     * Create a new review for a study program.
     * Requires authentication.
     */
    @PostMapping
    public ResponseEntity<ReviewResponse> createReview(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody @NotNull CreateReviewRequest request) {

        LOG.info("Review creation request from user {} for program {}",
                user.getId(), request.studyProgramId());

        ReviewResponse response = reviewService.createReview(user, request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    /**
     * Get all reviews for a specific study program.
     * Public endpoint - no authentication required.
     */
    @GetMapping("/program/{studyProgramId}")
    public ResponseEntity<List<ReviewResponse>> getReviewsByProgram(
            @PathVariable Long studyProgramId) {

        LOG.info("Fetching reviews for study program {}", studyProgramId);
        List<ReviewResponse> reviews = reviewService.getReviewsByStudyProgram(studyProgramId);
        return ResponseEntity.ok(reviews);
    }

    /**
     * Get all reviews created by the authenticated user.
     * Requires authentication.
     */
    @GetMapping("/my-reviews")
    public ResponseEntity<List<ReviewResponse>> getMyReviews(
            @AuthenticationPrincipal User user) {

        LOG.info("Fetching reviews for user {}", user.getId());
        List<ReviewResponse> reviews = reviewService.getReviewsByUser(user);
        return ResponseEntity.ok(reviews);
    }
}
