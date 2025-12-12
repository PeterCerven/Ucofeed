package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Builder;
import lombok.Data;

import sk.ucofeed.backend.persistence.model.DashboardMessage;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.University;

import java.time.LocalDateTime;

import java.util.UUID;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class DashboardMessageDTO {
    private Long id;
    private String message;
    private LocalDateTime createdAt;

    public static DashboardMessageDTO from(DashboardMessage dashboardMessage) {
        return DashboardMessageDTO.builder()
                .id(dashboardMessage.getId())
                .message(dashboardMessage.getMessage())
                .createdAt(dashboardMessage.getCreatedAt())
                .build();
    }

    // The following nested classes define the payload structures
    // for each type of dashboard event (message)

    @Data
    @Builder
    @JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
    public static class Review {
        @Builder.Default
        private String eventType = "ReviewCreated";

        private StudyProgramInfo studyProgram;
        private Long programId;
        private UUID userId;

        @Data
        @Builder
        public static class StudyProgramInfo {
            private String universityName;
            private String facultyName;
            private String programName;
        }

        public static String from(StudyProgram studyProgram, UUID userId) {
            Review dto = Review.builder()
                    .studyProgram(Review.StudyProgramInfo.builder()
                        .universityName(studyProgram.getFaculty().getUniversity().getName())
                        .facultyName(studyProgram.getFaculty().getName())
                        .programName(studyProgram.getName())
                        .build())
                    .programId(studyProgram.getId())
                    .userId(userId)
                    .build();

            ObjectMapper objectMapper = new ObjectMapper();
            try {
                return objectMapper.writeValueAsString(dto);
            } catch (JsonProcessingException e) {
                return "";
            }
        }
    }

}
