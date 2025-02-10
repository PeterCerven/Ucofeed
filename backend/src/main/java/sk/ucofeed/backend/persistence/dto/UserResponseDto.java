package sk.ucofeed.backend.persistence.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Builder;
import lombok.Data;
import sk.ucofeed.backend.persistence.model.User;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class UserResponseDto {

    String id;
    String fullName;
    String email;
    String phoneNumber;

    public static UserResponseDto from(User user) {
        return UserResponseDto.builder()
                .id(user.getId().toString())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .build();
    }
}
