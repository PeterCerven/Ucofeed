package sk.ucofeed.backend.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import sk.ucofeed.backend.exception.ReviewNotFoundException;
import sk.ucofeed.backend.exception.StudyProgramNotFoundException;
import sk.ucofeed.backend.exception.UnauthorizedReviewActionException;
import sk.ucofeed.backend.exception.UserNotEnrolledException;
import sk.ucofeed.backend.persistence.dto.CreateReviewRequest;
import sk.ucofeed.backend.persistence.dto.ReviewResponse;
import sk.ucofeed.backend.persistence.dto.UpdateReviewRequest;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.ReviewRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UserEducationRepository;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReviewServiceImplTest {

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private StudyProgramRepository studyProgramRepository;

    @Mock
    private UserEducationRepository userEducationRepository;

    @Mock
    private DashboardNotifier dashboardNotifier;

    @InjectMocks
    private ReviewServiceImpl reviewService;

    private User testUser;
    private StudyProgram testStudyProgram;
    private StudyProgramVariant testVariant;
    private UserEducation testEducation;
    private Review testReview;

    @BeforeEach
    void setUp() {
        testUser = new User("test@example.com", "Test User", "password", User.Role.USER);
        testUser.setId(UUID.randomUUID());

        University university = new University("Test University", "test.edu");
        Faculty faculty = new Faculty("Test Faculty", university);
        testStudyProgram = new StudyProgram("Test Program", faculty, "Test Field");
        testStudyProgram.setId(1L);

        testVariant = new StudyProgramVariant("Slovak", sk.ucofeed.backend.persistence.dto.StudyForm.FULL_TIME, "Bc.");
        testVariant.setId(1L);

        testEducation = new UserEducation(
            testUser, testStudyProgram, testVariant, UserEducation.Status.ENROLLED
        );
        testEducation.setId(1L);

        testReview = Review.builder()
            .id(1L)
            .studyProgram(testStudyProgram)
            .studyProgramVariant(testVariant)
            .user(testUser)
            .rating(8)
            .comment("Great program!")
            .anonymous(false)
            .build();
    }

    @Test
    void createReview_WhenUserIsEnrolled_ShouldCreateReview() {
        CreateReviewRequest request = new CreateReviewRequest(1L, 8, "Great program!", false);

        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(userEducationRepository.findByUser(testUser)).thenReturn(List.of(testEducation));
        when(reviewRepository.save(any(Review.class))).thenReturn(testReview);
        doNothing().when(dashboardNotifier).reviewCreated(any(), any());

        ReviewResponse result = reviewService.createReview(testUser, request);

        assertNotNull(result);
        verify(reviewRepository, times(1)).save(any(Review.class));
        verify(dashboardNotifier, times(1)).reviewCreated(testStudyProgram, testUser.getId());
    }

    @Test
    void createReview_WhenStudyProgramNotFound_ShouldThrowException() {
        CreateReviewRequest request = new CreateReviewRequest(999L, 8, "Great program!", false);

        when(studyProgramRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(StudyProgramNotFoundException.class,
            () -> reviewService.createReview(testUser, request));

        verify(reviewRepository, never()).save(any());
        verify(dashboardNotifier, never()).reviewCreated(any(), any());
    }

    @Test
    void createReview_WhenUserNotEnrolled_ShouldThrowException() {
        CreateReviewRequest request = new CreateReviewRequest(1L, 8, "Great program!", false);

        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(userEducationRepository.findByUser(testUser)).thenReturn(List.of());

        assertThrows(UserNotEnrolledException.class,
            () -> reviewService.createReview(testUser, request));

        verify(reviewRepository, never()).save(any());
    }

    @Test
    void createReview_WhenUserDroppedOut_ShouldThrowException() {
        testEducation.setStatus(UserEducation.Status.DROPPED_OUT);
        CreateReviewRequest request = new CreateReviewRequest(1L, 8, "Great program!", false);

        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(userEducationRepository.findByUser(testUser)).thenReturn(List.of(testEducation));

        assertThrows(UserNotEnrolledException.class,
            () -> reviewService.createReview(testUser, request));

        verify(reviewRepository, never()).save(any());
    }

    @Test
    void updateReview_WhenUserOwnsReview_ShouldUpdateReview() {
        UpdateReviewRequest request = new UpdateReviewRequest(9, "Updated comment", true);

        when(reviewRepository.findByIdAndUser(1L, testUser)).thenReturn(Optional.of(testReview));
        when(reviewRepository.save(any(Review.class))).thenReturn(testReview);

        ReviewResponse result = reviewService.updateReview(testUser, 1L, request);

        assertNotNull(result);
        assertEquals(9, testReview.getRating());
        assertEquals("Updated comment", testReview.getComment());
        assertTrue(testReview.isAnonymous());

        verify(reviewRepository, times(1)).save(testReview);
    }

    @Test
    void updateReview_WhenReviewNotFound_ShouldThrowException() {
        UpdateReviewRequest request = new UpdateReviewRequest(9, "Updated comment", true);

        when(reviewRepository.findByIdAndUser(999L, testUser)).thenReturn(Optional.empty());
        when(reviewRepository.existsById(999L)).thenReturn(false);

        assertThrows(ReviewNotFoundException.class,
            () -> reviewService.updateReview(testUser, 999L, request));

        verify(reviewRepository, never()).save(any());
    }

    @Test
    void updateReview_WhenUserDoesNotOwnReview_ShouldThrowException() {
        UpdateReviewRequest request = new UpdateReviewRequest(9, "Updated comment", true);

        when(reviewRepository.findByIdAndUser(1L, testUser)).thenReturn(Optional.empty());
        when(reviewRepository.existsById(1L)).thenReturn(true);

        assertThrows(UnauthorizedReviewActionException.class,
            () -> reviewService.updateReview(testUser, 1L, request));

        verify(reviewRepository, never()).save(any());
    }

    @Test
    void deleteReview_WhenUserOwnsReview_ShouldDeleteReview() {
        when(reviewRepository.findByIdAndUser(1L, testUser)).thenReturn(Optional.of(testReview));

        reviewService.deleteReview(testUser, 1L);

        verify(reviewRepository, times(1)).delete(testReview);
    }

    @Test
    void deleteReview_WhenReviewNotFound_ShouldThrowException() {
        when(reviewRepository.findByIdAndUser(999L, testUser)).thenReturn(Optional.empty());
        when(reviewRepository.existsById(999L)).thenReturn(false);

        assertThrows(ReviewNotFoundException.class,
            () -> reviewService.deleteReview(testUser, 999L));

        verify(reviewRepository, never()).delete(any());
    }

    @Test
    void deleteReview_WhenUserDoesNotOwnReview_ShouldThrowException() {
        when(reviewRepository.findByIdAndUser(1L, testUser)).thenReturn(Optional.empty());
        when(reviewRepository.existsById(1L)).thenReturn(true);

        assertThrows(UnauthorizedReviewActionException.class,
            () -> reviewService.deleteReview(testUser, 1L));

        verify(reviewRepository, never()).delete(any());
    }

    @Test
    void canCreateReview_WhenUserIsEnrolledAndHasNoReview_ShouldReturnTrue() {
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(reviewRepository.existsByUserAndStudyProgram(testUser, testStudyProgram)).thenReturn(false);
        when(userEducationRepository.findByUser(testUser)).thenReturn(List.of(testEducation));

        boolean result = reviewService.canCreateReview(testUser, 1L);

        assertTrue(result);
    }

    @Test
    void canCreateReview_WhenStudyProgramNotFound_ShouldReturnFalse() {
        when(studyProgramRepository.findById(999L)).thenReturn(Optional.empty());

        boolean result = reviewService.canCreateReview(testUser, 999L);

        assertFalse(result);
    }

    @Test
    void canCreateReview_WhenUserAlreadyHasReview_ShouldReturnFalse() {
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(reviewRepository.existsByUserAndStudyProgram(testUser, testStudyProgram)).thenReturn(true);

        boolean result = reviewService.canCreateReview(testUser, 1L);

        assertFalse(result);
    }

    @Test
    void canCreateReview_WhenUserNotEnrolled_ShouldReturnFalse() {
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(reviewRepository.existsByUserAndStudyProgram(testUser, testStudyProgram)).thenReturn(false);
        when(userEducationRepository.findByUser(testUser)).thenReturn(List.of());

        boolean result = reviewService.canCreateReview(testUser, 1L);

        assertFalse(result);
    }

    @Test
    void getReviewsByStudyProgram_ShouldReturnListOfReviews() {
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(reviewRepository.findByStudyProgramOrderByCreatedAtDesc(testStudyProgram))
            .thenReturn(List.of(testReview));

        List<ReviewResponse> result = reviewService.getReviewsByStudyProgram(1L, testUser);

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(reviewRepository, times(1)).findByStudyProgramOrderByCreatedAtDesc(testStudyProgram);
    }

    @Test
    void getReviewsByStudyProgram_WhenProgramNotFound_ShouldThrowException() {
        when(studyProgramRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(StudyProgramNotFoundException.class,
            () -> reviewService.getReviewsByStudyProgram(999L, testUser));
    }

    @Test
    void getReviewsByUser_ShouldReturnUserReviews() {
        when(reviewRepository.findByUser(testUser)).thenReturn(List.of(testReview));

        List<ReviewResponse> result = reviewService.getReviewsByUser(testUser);

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(reviewRepository, times(1)).findByUser(testUser);
    }
}