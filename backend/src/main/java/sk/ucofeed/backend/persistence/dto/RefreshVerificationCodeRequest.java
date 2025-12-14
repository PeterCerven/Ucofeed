package sk.ucofeed.backend.persistence.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record RefreshVerificationCodeRequest(
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    String email
) {}
