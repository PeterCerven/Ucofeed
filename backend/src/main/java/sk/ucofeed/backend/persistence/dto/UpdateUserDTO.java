package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UpdateUserDTO {
    private String fullName;

    @NotNull(message = "Study program ID cannot be null")
    private Long studyProgramId;

    @NotNull(message = "Study program variant ID cannot be null")
    private Long studyProgramVariantId;

    @NotNull(message = "Status cannot be null")
    private String status;
}