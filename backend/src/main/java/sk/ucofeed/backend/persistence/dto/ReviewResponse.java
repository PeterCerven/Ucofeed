package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Value;
import sk.ucofeed.backend.persistence.model.Review;
import sk.ucofeed.backend.persistence.model.User;

import java.time.LocalDateTime;

@Value
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ReviewResponse {
    Long id;
    Long studyProgramId;
    String studyProgramName;
    Long studyProgramVariantId;
    Integer rating;
    String comment;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
    Boolean anonymous;
    Boolean isOwner;  // Server-calculated ownership flag

    // Auto-populated tags from StudyProgramVariant
    String language;
    String studyForm;  // Will be enum display name (e.g., "denná")
    String title;      // Academic degree title

    // User info (conditionally included based on anonymous flag)
    String userEmail;    // null if anonymous
    String userFullName; // null if anonymous

    public static ReviewResponse from(Review review, User currentUser) {
        // Calculate ownership: current user must match review author
        boolean isOwner = currentUser != null
                && review.getUser() != null
                && review.getUser().getId().equals(currentUser.getId());

        return ReviewResponse.builder()
                .id(review.getId())
                .studyProgramId(review.getStudyProgram().getId())
                .studyProgramName(review.getStudyProgram().getName())
                .studyProgramVariantId(review.getStudyProgramVariant().getId())
                .rating(review.getRating())
                .comment(review.getComment())
                .createdAt(review.getCreatedAt())
                .updatedAt(review.getUpdatedAt())
                .anonymous(review.isAnonymous())
                .isOwner(isOwner)
                .language(review.getStudyProgramVariant().getLanguage())
                .studyForm(review.getStudyProgramVariant().getStudyForm().getDisplayName())
                .title(review.getStudyProgramVariant().getTitle())
                .userEmail(review.isAnonymous() ? null : review.getUser().getEmail())
                .userFullName(review.isAnonymous() ? null : review.getUser().getFullName())
                .build();
    }
}
