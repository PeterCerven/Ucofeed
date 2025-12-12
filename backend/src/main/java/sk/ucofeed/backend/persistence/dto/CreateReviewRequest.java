package sk.ucofeed.backend.persistence.dto;

import jakarta.validation.constraints.*;

public record CreateReviewRequest(
        @NotNull(message = "Study program ID is required")
        @Positive(message = "Study program ID must be positive")
        Long studyProgramId,

        @NotNull(message = "Study program variant ID is required")
        @Positive(message = "Study program variant ID must be positive")
        Long studyProgramVariantId,

        @NotNull(message = "Rating is required")
        @Min(value = 1, message = "Rating must be at least 1")
        @Max(value = 10, message = "Rating must be at most 10")
        Integer rating,

        @Size(max = 5000, message = "Comment cannot exceed 5000 characters")
        String comment,

        @NotNull(message = "Anonymous flag is required")
        Boolean anonymous
) {
}
