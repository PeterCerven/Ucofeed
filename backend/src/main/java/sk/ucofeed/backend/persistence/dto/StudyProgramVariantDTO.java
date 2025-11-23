package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class StudyProgramVariantDTO {
    private Long id;
    private String language;
    private String studyForm;
    private String title;

    public static StudyProgramVariantDTO from(StudyProgramVariant variant) {
        return StudyProgramVariantDTO.builder()
                .id(variant.getId())
                .language(variant.getLanguage())
                .studyForm(variant.getStudyForm() != null ? variant.getStudyForm().getDisplayName() : null)
                .title(variant.getTitle())
                .build();
    }
}