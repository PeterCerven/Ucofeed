package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Builder;
import lombok.Data;

import sk.ucofeed.backend.persistence.model.DashboardMessage;

import java.time.LocalDateTime;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class DashboardMessageDataDTO {
    private Long id;
    private String message;
    private LocalDateTime createdAt;

    public static DashboardMessageDataDTO from(DashboardMessage dashboardMessage) {
        return DashboardMessageDataDTO.builder()
                .id(dashboardMessage.getId())
                .message(dashboardMessage.getMessage())
                .createdAt(dashboardMessage.getCreatedAt())
                .build();
    }
}
