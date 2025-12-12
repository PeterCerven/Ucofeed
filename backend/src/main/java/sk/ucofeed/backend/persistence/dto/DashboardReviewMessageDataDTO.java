package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Builder;
import lombok.Data;

import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.University;

import java.time.LocalDateTime;

import java.util.UUID;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class DashboardReviewMessageDataDTO {
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
        DashboardReviewMessageDataDTO dto = DashboardReviewMessageDataDTO.builder()
                .studyProgram(DashboardReviewMessageDataDTO.StudyProgramInfo.builder()
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
