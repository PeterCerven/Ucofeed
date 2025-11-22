package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.StudyProgram;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class StudyProgramDTO {
    private Long id;
    private String name;

    public static StudyProgramDTO from(StudyProgram studyProgram) {
        return StudyProgramDTO.builder()
                .id(studyProgram.getId())
                .name(studyProgram.getName())
                .build();
    }
}