package sk.ucofeed.backend.exception;

import sk.ucofeed.backend.persistence.dto.ErrorDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.List;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GenericExceptionHandler extends ResponseEntityExceptionHandler {

    private static final Logger LOG = LoggerFactory.getLogger(GenericExceptionHandler.class);

    @Override
    @Nullable
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex,
            @Nullable HttpHeaders headers,
            @Nullable HttpStatusCode status,
            @Nullable WebRequest request) {
        ErrorDto errorBody = ErrorDto.builder()
                .error(ex
                        .getFieldErrors()
                        .stream()
                        .map(DefaultMessageSourceResolvable::getDefaultMessage)
                        .collect(Collectors.toList()))
                .type(ErrorDto.ErrorType.VALIDATION_ERROR)
                .build();
        LOG.info("Error DTO: {}", errorBody);
        if (headers == null) {
            headers = new HttpHeaders();
        }
        if (status == null) {
            status = HttpStatus.BAD_REQUEST;
        }
        if (request == null) {
            throw new IllegalArgumentException("Request cannot be null");
        }
        return handleExceptionInternal(ex, errorBody, headers, status, request);
    }

    @ExceptionHandler({RuntimeException.class})
    protected ResponseEntity<ErrorDto> handleGeneralException(RuntimeException ex) {
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(
                        ErrorDto.builder()
                                .type(ErrorDto.ErrorType.UNKNOWN)
                                .error(List.of("Unknown Error Occurred"))
                                .build()
                );

    }

    @ExceptionHandler({UserAlreadyExistsException.class})
    protected ResponseEntity<ErrorDto> handleUserAlreadyExistsException(UserAlreadyExistsException ex) {
        LOG.error(ex.toString());
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(
                        ErrorDto.builder()
                                .type(ErrorDto.ErrorType.USER_ALREADY_EXISTS)
                                .error(List.of(ex.getMessage()))
                                .build()
                );

    }

    @ExceptionHandler({UserNotEnrolledException.class})
    protected ResponseEntity<ErrorDto> handleUserNotEnrolledException(UserNotEnrolledException ex) {
        LOG.error(ex.toString());
        return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(
                        ErrorDto.builder()
                                .type(ErrorDto.ErrorType.USER_NOT_ENROLLED)
                                .error(List.of(ex.getMessage()))
                                .build()
                );
    }

    @ExceptionHandler({ReviewAlreadyExistsException.class})
    protected ResponseEntity<ErrorDto> handleReviewAlreadyExistsException(ReviewAlreadyExistsException ex) {
        LOG.error(ex.toString());
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(
                        ErrorDto.builder()
                                .type(ErrorDto.ErrorType.REVIEW_ALREADY_EXISTS)
                                .error(List.of(ex.getMessage()))
                                .build()
                );
    }

    @ExceptionHandler({StudyProgramNotFoundException.class})
    protected ResponseEntity<ErrorDto> handleStudyProgramNotFoundException(StudyProgramNotFoundException ex) {
        LOG.error(ex.toString());
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(
                        ErrorDto.builder()
                                .type(ErrorDto.ErrorType.STUDY_PROGRAM_NOT_FOUND)
                                .error(List.of(ex.getMessage()))
                                .build()
                );
    }
}
