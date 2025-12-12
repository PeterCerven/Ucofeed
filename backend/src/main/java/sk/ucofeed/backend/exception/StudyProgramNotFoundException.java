package sk.ucofeed.backend.exception;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import sk.ucofeed.backend.persistence.dto.ErrorDto;

@Builder
@ToString
@Setter
@Getter
public class StudyProgramNotFoundException extends RuntimeException {
    ErrorDto.ErrorType errorType;
    String message;
}
