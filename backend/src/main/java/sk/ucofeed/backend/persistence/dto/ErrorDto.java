package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Value;

import java.util.List;

@Value
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ErrorDto {

    ErrorType type;
    List<String> error;

    public enum ErrorType {
        VALIDATION_ERROR,
        USER_ALREADY_EXISTS,
        USER_NOT_ENROLLED,
        REVIEW_ALREADY_EXISTS,
        REVIEW_NOT_FOUND,
        UNAUTHORIZED_REVIEW_ACTION,
        STUDY_PROGRAM_NOT_FOUND,
        UNKNOWN
    }
}