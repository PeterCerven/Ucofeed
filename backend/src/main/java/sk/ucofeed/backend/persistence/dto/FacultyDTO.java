package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.Faculty;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class FacultyDTO {
    private Long id;
    private String name;
    private Long universityId;
    private String universityName;
    private Double rating;

    public static FacultyDTO from(Faculty faculty) {
        return FacultyDTO.builder()
                .id(faculty.getId())
                .name(faculty.getName())
                .universityId(faculty.getUniversity() != null ? faculty.getUniversity().getId() : null)
                .universityName(faculty.getUniversity() != null ? faculty.getUniversity().getName() : null)
                .build();
    }

    public static FacultyDTO from(Faculty faculty, Double rating) {
        return FacultyDTO.builder()
                .id(faculty.getId())
                .name(faculty.getName())
                .universityId(faculty.getUniversity() != null ? faculty.getUniversity().getId() : null)
                .universityName(faculty.getUniversity() != null ? faculty.getUniversity().getName() : null)
                .rating(rating)
                .build();
    }
}