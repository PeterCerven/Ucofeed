package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.StudyProgram;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class StudyProgramDetailsDTO {
    private Long id;
    private String name;
    private String studyField;
    private Long facultyId;
    private String facultyName;
    private Long universityId;
    private String universityName;

    public static StudyProgramDetailsDTO from(StudyProgram studyProgram) {
        return StudyProgramDetailsDTO.builder()
                .id(studyProgram.getId())
                .name(studyProgram.getName())
                .studyField(studyProgram.getStudyField())
                .facultyId(studyProgram.getFaculty() != null ? studyProgram.getFaculty().getId() : null)
                .facultyName(studyProgram.getFaculty() != null ? studyProgram.getFaculty().getName() : null)
                .universityId(studyProgram.getFaculty() != null && studyProgram.getFaculty().getUniversity() != null
                        ? studyProgram.getFaculty().getUniversity().getId() : null)
                .universityName(studyProgram.getFaculty() != null && studyProgram.getFaculty().getUniversity() != null
                        ? studyProgram.getFaculty().getUniversity().getName() : null)
                .build();
    }
}
