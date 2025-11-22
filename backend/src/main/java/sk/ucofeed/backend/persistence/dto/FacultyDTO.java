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

    public static FacultyDTO from(Faculty faculty) {
        return FacultyDTO.builder()
                .id(faculty.getId())
                .name(faculty.getName())
                .build();
    }
}