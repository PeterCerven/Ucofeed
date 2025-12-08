package sk.ucofeed.backend.controller.external;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.web.bind.annotation.*;
import sk.ucofeed.backend.persistence.dto.LoginRequest;
import sk.ucofeed.backend.persistence.dto.VerifyCodeRequest;
import sk.ucofeed.backend.persistence.dto.SignUpRequest;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.service.AuthService;

import java.util.Map;

@RestController
@RequestMapping("/api/public/auth")
public class AuthController {

    private static final Logger LOG = LoggerFactory.getLogger(AuthController.class);

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(
            @Valid @RequestBody @NotNull SignUpRequest request
    ) {
        LOG.info("Registering user with email: {}", request.email());
        try {
            User user = authService.registerUser(request.email(), request.password());
            return ResponseEntity.ok(Map.of(
                    "message", "Account verified successfully",
                    "id", user.getId().toString(),
                    "email", user.getEmail(),
                    "role", user.getRole().toString()
            ));
        } catch (IllegalArgumentException e) {
            LOG.warn("Registration failed for email: {} - {}", request.email(), e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            LOG.error("Error registering user with email: {}", request.email(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to register user");
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verify(
            @Valid @RequestBody @NotNull VerifyCodeRequest request,
            HttpServletRequest httpRequest
    ) {
        LOG.info("Verifying code for email: {}", request.email());
        try {
            User user = authService.verifyCode(
                    request.email(),
                    request.verificationCode()
            );

            authenticateUser(user, httpRequest);

            return ResponseEntity.ok(Map.of(
                    "message", "Account verified successfully",
                    "id", user.getId().toString(),
                    "email", user.getEmail(),
                    "role", user.getRole().toString()
            ));
        } catch (IllegalArgumentException e) {
            LOG.warn("Verification failed for email: {} - {}", request.email(), e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            LOG.error("Error during verification for email: {}", request.email(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An error occurred during verification");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(
            @Valid @RequestBody @NotNull LoginRequest request,
            HttpServletRequest httpRequest
    ) {
        LOG.info("Login attempt for email: {}", request.email());
        try {
            User user = authService.login(request.email(), request.password());

            authenticateUser(user, httpRequest);

            return ResponseEntity.ok(Map.of(
                    "message", "Login successful",
                    "id", user.getId().toString(),
                    "email", user.getEmail(),
                    "role", user.getRole().toString()
            ));
        } catch (BadCredentialsException e) {
            LOG.warn("Login failed for email: {} - {}", request.email(), e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        } catch (Exception e) {
            LOG.error("Error during login for email: {}", request.email(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An error occurred during login");
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok("Logged out successfully");
    }

    private void authenticateUser(User user, HttpServletRequest request) {
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());

        SecurityContext securityContext = SecurityContextHolder.getContext();
        securityContext.setAuthentication(authentication);

        HttpSession session = request.getSession(true);
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, securityContext);
    }
}
