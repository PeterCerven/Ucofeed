package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
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
    private Integer degreeLevel;
    private String language;
    private String status;

    public static UserEducationResponseDTO from(UserEducation userEducation) {
        // Get language from LanguageGroup - use the group name or first language
        String language = userEducation.getStudyProgramVariant().getLanguageGroup().getName();
        if (!userEducation.getStudyProgramVariant().getLanguageGroup().getLanguages().isEmpty()) {
            language = userEducation.getStudyProgramVariant().getLanguageGroup()
                    .getLanguages().getFirst().getName();
        }

        return UserEducationResponseDTO.builder()
                .id(userEducation.getId())
                .studyProgramId(userEducation.getStudyProgram().getId())
                .studyProgramName(userEducation.getStudyProgram().getName())
                .facultyId(userEducation.getStudyProgram().getFaculty().getId())
                .facultyName(userEducation.getStudyProgram().getFaculty().getName())
                .universityId(userEducation.getStudyProgram().getFaculty().getUniversity().getId())
                .universityName(userEducation.getStudyProgram().getFaculty().getUniversity().getName())
                .studyProgramVariantId(userEducation.getStudyProgramVariant().getId())
                .studyFormat(userEducation.getStudyProgramVariant().getStudyFormat())
                .degreeLevel(userEducation.getStudyProgramVariant().getStudyDegree())
                .language(language)
                .status(userEducation.getStatus().toString())
                .build();
    }
}