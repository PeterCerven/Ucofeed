package sk.ucofeed.backend.persistence.dto;

import sk.ucofeed.backend.persistence.model.User;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UserResponseDTO {
    private String id;
    private String email;
    private String fullName;
    private List<UserEducationResponseDTO> educations;

    public static UserResponseDTO from(User user) {
        return UserResponseDTO.builder()
                .id(user.getId().toString())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .educations(user.getEducations().stream()
                        .map(UserEducationResponseDTO::from)
                        .toList())
                .build();
    }
}
