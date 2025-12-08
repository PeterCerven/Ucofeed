package sk.ucofeed.backend.persistence.dto;

import lombok.Data;

@Data
public class UpdateUserDTO {
    private Long studyProgramId;
    private Long studyProgramVariantId;
    private String status;
}