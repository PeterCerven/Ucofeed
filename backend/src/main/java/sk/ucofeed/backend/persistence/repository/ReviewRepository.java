package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.ucofeed.backend.persistence.model.Review;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.User;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    /**
     * Check if a review already exists for the given user, study program, and semester.
     * Used to prevent duplicate reviews.
     */
    boolean existsByUserAndStudyProgramAndSemester(
            User user,
            StudyProgram studyProgram,
            int semester
    );

    /**
     * Find existing review for duplicate detection with detailed info.
     */
    Optional<Review> findByUserAndStudyProgramAndSemester(
            User user,
            StudyProgram studyProgram,
            int semester
    );

    /**
     * Find all reviews by a specific user.
     */
    List<Review> findByUser(User user);

    /**
     * Find all reviews for a specific study program.
     */
    List<Review> findByStudyProgram(StudyProgram studyProgram);

    /**
     * Find all reviews for a study program ordered by creation date (newest first).
     */
    List<Review> findByStudyProgramOrderByCreatedAtDesc(StudyProgram studyProgram);

    /**
     * Count total reviews for a study program.
     */
    long countByStudyProgram(StudyProgram studyProgram);

    /**
     * Calculate average rating for a study program.
     */
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.studyProgram = :studyProgram")
    Double findAverageRatingByStudyProgram(@Param("studyProgram") StudyProgram studyProgram);
}
