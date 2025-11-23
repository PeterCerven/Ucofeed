package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;
import sk.ucofeed.backend.persistence.model.UserEducation;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UserEducationResponseDTO {
    private Long id;
    private Long studyProgramId;
    private String studyProgramName;
    private Long facultyId;
    private String facultyName;
    private Long universityId;
    private String universityName;
    private Long studyProgramVariantId;
    private String studyFormat;
    private String language;
    private String title;
    private String status;

    public static UserEducationResponseDTO from(UserEducation userEducation) {
        StudyProgramVariant variant = userEducation.getStudyProgramVariant();

        return UserEducationResponseDTO.builder()
                .id(userEducation.getId())
                .studyProgramId(userEducation.getStudyProgram().getId())
                .studyProgramName(userEducation.getStudyProgram().getName())
                .facultyId(userEducation.getStudyProgram().getFaculty().getId())
                .facultyName(userEducation.getStudyProgram().getFaculty().getName())
                .universityId(userEducation.getStudyProgram().getFaculty().getUniversity().getId())
                .universityName(userEducation.getStudyProgram().getFaculty().getUniversity().getName())
                .studyProgramVariantId(variant.getId())
                .studyFormat(variant.getStudyForm() != null ? variant.getStudyForm().getDisplayName() : null)
                .language(variant.getLanguage())
                .title(variant.getTitle())
                .status(userEducation.getStatus().toString())
                .build();
    }
}