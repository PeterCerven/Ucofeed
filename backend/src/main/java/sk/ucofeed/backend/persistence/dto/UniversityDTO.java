package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.University;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UniversityDTO {
    private Long id;
    private String name;
    private Double rating;

    public static UniversityDTO from(University university) {
        return UniversityDTO.builder()
                .id(university.getId())
                .name(university.getName())
                .build();
    }

    public static UniversityDTO from(University university, Double rating) {
        return UniversityDTO.builder()
                .id(university.getId())
                .name(university.getName())
                .rating(rating)
                .build();
    }
}