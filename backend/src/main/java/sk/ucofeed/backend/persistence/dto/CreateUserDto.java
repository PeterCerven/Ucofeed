package sk.ucofeed.backend.persistence.dto;

import sk.ucofeed.backend.persistence.model.User;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class CreateUserDto {
    String fullName;

    @NotEmpty(message = "Email cannot be empty") @Email(message = "Malformed Email")
    String email;

    @NotEmpty(message = "Password cannot be empty")
    String password;

    @NotEmpty(message = "Role cannot be empty")
    User.Role role;
}
