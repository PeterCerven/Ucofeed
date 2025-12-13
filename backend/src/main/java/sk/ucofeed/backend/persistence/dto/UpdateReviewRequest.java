package sk.ucofeed.backend.persistence.dto;

import jakarta.validation.constraints.*;

public record UpdateReviewRequest(
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
