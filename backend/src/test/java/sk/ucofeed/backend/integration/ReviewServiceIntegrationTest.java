package sk.ucofeed.backend.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.transaction.annotation.Transactional;
import sk.ucofeed.backend.exception.ReviewNotFoundException;
import sk.ucofeed.backend.exception.StudyProgramNotFoundException;
import sk.ucofeed.backend.exception.UnauthorizedReviewActionException;
import sk.ucofeed.backend.exception.UserNotEnrolledException;
import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.dto.UpdateReviewRequest;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.*;
import sk.ucofeed.backend.service.DashboardNotifier;
import sk.ucofeed.backend.service.ReviewService;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ReviewServiceIntegrationTest {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private UniversityRepository universityRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudyProgramRepository studyProgramRepository;

    @Autowired
    private StudyProgramVariantRepository studyProgramVariantRepository;

    @Autowired
    private UserEducationRepository userEducationRepository;

    @MockitoBean
    private DashboardNotifier dashboardNotifier;

    private User testUser;
    private User otherUser;
    private StudyProgram testStudyProgram;
    private StudyProgramVariant testVariant;
    private UserEducation userEducation;

    @BeforeEach
    void setUp() {
        doNothing().when(dashboardNotifier).reviewCreated(any(), any());

        reviewRepository.deleteAll();
        userEducationRepository.deleteAll();
        userRepository.deleteAll();
        studyProgramRepository.deleteAll();
        facultyRepository.deleteAll();
        universityRepository.deleteAll();
        studyProgramVariantRepository.deleteAll();

        // Create test data
        University university = new University("Test University", "test.edu");
        university = universityRepository.save(university);

        Faculty faculty = new Faculty("Test Faculty", university);
        faculty = facultyRepository.save(faculty);

        testStudyProgram = new StudyProgram("Computer Science", faculty, "Computer Science");
        testStudyProgram = studyProgramRepository.save(testStudyProgram);

        testVariant = new StudyProgramVariant("English", sk.ucofeed.backend.persistence.dto.StudyForm.FULL_TIME, "Bc.");
        testVariant = studyProgramVariantRepository.save(testVariant);

        testUser = new User("user@test.com", "Test User", "password", User.Role.USER);
        testUser.setEnabled(true);
        testUser = userRepository.save(testUser);

        otherUser = new User("other@test.com", "Other User", "password", User.Role.USER);
        otherUser.setEnabled(true);
        otherUser = userRepository.save(otherUser);

        userEducation = new UserEducation(testUser, testStudyProgram, testVariant, UserEducation.Status.ENROLLED);
        userEducation = userEducationRepository.save(userEducation);
    }

    @Test
    void shouldCreateReviewSuccessfully() {
        CreateReviewRequest request = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great program!",
            false
        );

        ReviewResponse response = reviewService.createReview(testUser, request);

        assertNotNull(response);
        assertNotNull(response.getId());
        assertEquals(8, response.getRating());
        assertEquals("Great program!", response.getComment());
        assertFalse(response.getAnonymous());
        assertTrue(response.getIsOwner());

        List<Review> reviews = reviewRepository.findAll();
        assertEquals(1, reviews.size());
    }

    @Test
    void shouldThrowExceptionWhenStudyProgramNotFound() {
        CreateReviewRequest request = new CreateReviewRequest(999L, 8, "Great!", false);

        assertThrows(StudyProgramNotFoundException.class,
            () -> reviewService.createReview(testUser, request));
    }

    @Test
    void shouldThrowExceptionWhenUserNotEnrolled() {
        CreateReviewRequest request = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );

        assertThrows(UserNotEnrolledException.class,
            () -> reviewService.createReview(otherUser, request));
    }

    @Test
    void shouldUpdateReviewSuccessfully() {
        // Create a review first
        CreateReviewRequest createRequest = new CreateReviewRequest(
            testStudyProgram.getId(),
            7,
            "Good program",
            false
        );
        ReviewResponse created = reviewService.createReview(testUser, createRequest);

        // Update it
        UpdateReviewRequest updateRequest = new UpdateReviewRequest(9, "Excellent program!", true);
        ReviewResponse updated = reviewService.updateReview(testUser, created.getId(), updateRequest);

        assertNotNull(updated);
        assertEquals(9, updated.getRating());
        assertEquals("Excellent program!", updated.getComment());
        assertTrue(updated.getAnonymous());

        Review savedReview = reviewRepository.findById(created.getId()).orElse(null);
        assertNotNull(savedReview);
        assertEquals(9, savedReview.getRating());
    }

    @Test
    void shouldThrowExceptionWhenUpdatingNonOwnedReview() {
        CreateReviewRequest createRequest = new CreateReviewRequest(
            testStudyProgram.getId(),
            7,
            "Good program",
            false
        );
        ReviewResponse created = reviewService.createReview(testUser, createRequest);

        UpdateReviewRequest updateRequest = new UpdateReviewRequest(9, "Updated", true);

        assertThrows(UnauthorizedReviewActionException.class,
            () -> reviewService.updateReview(otherUser, created.getId(), updateRequest));
    }

    @Test
    void shouldDeleteReviewSuccessfully() {
        CreateReviewRequest createRequest = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );
        ReviewResponse created = reviewService.createReview(testUser, createRequest);

        reviewService.deleteReview(testUser, created.getId());

        assertFalse(reviewRepository.existsById(created.getId()));
    }

    @Test
    void shouldThrowExceptionWhenDeletingNonExistentReview() {
        assertThrows(ReviewNotFoundException.class,
            () -> reviewService.deleteReview(testUser, 999L));
    }

    @Test
    void shouldThrowExceptionWhenDeletingNonOwnedReview() {
        CreateReviewRequest createRequest = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );
        ReviewResponse created = reviewService.createReview(testUser, createRequest);

        assertThrows(UnauthorizedReviewActionException.class,
            () -> reviewService.deleteReview(otherUser, created.getId()));
    }

    @Test
    void shouldCheckIfUserCanCreateReview() {
        assertTrue(reviewService.canCreateReview(testUser, testStudyProgram.getId()));
        assertFalse(reviewService.canCreateReview(otherUser, testStudyProgram.getId()));
    }

    @Test
    void shouldNotAllowMultipleReviewsForSameProgram() {
        CreateReviewRequest request = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );
        reviewService.createReview(testUser, request);

        assertFalse(reviewService.canCreateReview(testUser, testStudyProgram.getId()));
    }

    @Test
    void shouldGetReviewsByStudyProgram() {
        CreateReviewRequest request1 = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );
        reviewService.createReview(testUser, request1);

        List<ReviewResponse> reviews = reviewService.getReviewsByStudyProgram(
            testStudyProgram.getId(),
            testUser
        );

        assertNotNull(reviews);
        assertEquals(1, reviews.size());
        assertTrue(reviews.getFirst().getIsOwner());
    }

    @Test
    void shouldGetReviewsByUser() {
        CreateReviewRequest request = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great!",
            false
        );
        reviewService.createReview(testUser, request);

        List<ReviewResponse> reviews = reviewService.getReviewsByUser(testUser);

        assertNotNull(reviews);
        assertEquals(1, reviews.size());
        assertEquals(testUser.getEmail(), reviews.getFirst().getUserEmail());
    }

    @Test
    void shouldHideUserInfoForAnonymousReviews() {
        CreateReviewRequest request = new CreateReviewRequest(
            testStudyProgram.getId(),
            8,
            "Great program!",
            true
        );
        ReviewResponse response = reviewService.createReview(testUser, request);

        List<ReviewResponse> reviews = reviewService.getReviewsByStudyProgram(
            testStudyProgram.getId(),
            otherUser
        );

        assertEquals(1, reviews.size());
        assertNull(reviews.getFirst().getUserEmail());
        assertNull(reviews.getFirst().getUserFullName());
        assertFalse(reviews.getFirst().getIsOwner());
    }

    @Test
    void shouldCompleteFullReviewLifecycle() {
        // Create review
        CreateReviewRequest createRequest = new CreateReviewRequest(
            testStudyProgram.getId(),
            7,
            "Good program",
            false
        );
        ReviewResponse created = reviewService.createReview(testUser, createRequest);
        assertNotNull(created.getId());

        // Update review
        UpdateReviewRequest updateRequest = new UpdateReviewRequest(9, "Excellent!", false);
        ReviewResponse updated = reviewService.updateReview(testUser, created.getId(), updateRequest);
        assertEquals(9, updated.getRating());

        // Verify review exists
        List<ReviewResponse> reviews = reviewService.getReviewsByUser(testUser);
        assertEquals(1, reviews.size());

        // Delete review
        reviewService.deleteReview(testUser, created.getId());

        // Verify review is gone
        List<ReviewResponse> reviewsAfterDelete = reviewService.getReviewsByUser(testUser);
        assertEquals(0, reviewsAfterDelete.size());
    }
}