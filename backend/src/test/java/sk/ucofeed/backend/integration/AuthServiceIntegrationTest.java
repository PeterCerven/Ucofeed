package sk.ucofeed.backend.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.transaction.annotation.Transactional;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.repository.UserRepository;
import sk.ucofeed.backend.service.AuthService;
import sk.ucofeed.backend.service.EmailServiceImpl;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AuthServiceIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @MockitoBean
    private EmailServiceImpl emailService;

    private static final String TEST_EMAIL = "integration@test.com";
    private static final String TEST_NAME = "Integration Test User";
    private static final String TEST_PASSWORD = "password123";

    @BeforeEach
    void setUp() {
        doNothing().when(emailService).sendVerificationCode(anyString(), anyString());
        userRepository.deleteAll();
    }

    @Test
    void shouldRegisterUserSuccessfully() {
        User registeredUser = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);

        assertNotNull(registeredUser);
        assertNotNull(registeredUser.getId());
        assertEquals(TEST_EMAIL, registeredUser.getEmail());
        assertEquals(TEST_NAME, registeredUser.getFullName());
        assertFalse(registeredUser.isEnabled());
        assertNotNull(registeredUser.getVerificationCode());
        assertNotNull(registeredUser.getVerificationCodeExpiresAt());

        User savedUser = userRepository.findByEmail(TEST_EMAIL).orElse(null);
        assertNotNull(savedUser);
        assertEquals(registeredUser.getId(), savedUser.getId());
    }

    @Test
    void shouldNotRegisterDuplicateUser() {
        authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);

        assertThrows(IllegalArgumentException.class,
            () -> authService.registerUser(TEST_EMAIL, "Another Name", "password456"));
    }

    @Test
    void shouldVerifyCodeAndEnableUser() {
        User user = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);
        String verificationCode = user.getVerificationCode();

        User verifiedUser = authService.verifyCode(TEST_EMAIL, verificationCode);

        assertTrue(verifiedUser.isEnabled());
        assertNull(verifiedUser.getVerificationCode());
        assertNull(verifiedUser.getVerificationCodeExpiresAt());

        User savedUser = userRepository.findByEmail(TEST_EMAIL).orElse(null);
        assertNotNull(savedUser);
        assertTrue(savedUser.isEnabled());
    }

    @Test
    void shouldRejectInvalidVerificationCode() {
        authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, "000000"));
    }

    @Test
    void shouldRejectExpiredVerificationCode() {
        User user = new User(TEST_EMAIL, TEST_NAME, "encodedPassword", User.Role.USER);
        user.setEnabled(false);
        user.setVerificationCode("123456");
        user.setVerificationCodeExpiresAt(LocalDateTime.now().minusMinutes(1));
        userRepository.save(user);

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, "123456"));
    }

    @Test
    void shouldRefreshVerificationCode() {
        User user = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);
        String originalCode = user.getVerificationCode();
        LocalDateTime originalExpiry = user.getVerificationCodeExpiresAt();

        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        authService.refreshVerificationCode(TEST_EMAIL);

        User refreshedUser = userRepository.findByEmail(TEST_EMAIL).orElse(null);
        assertNotNull(refreshedUser);
        assertNotEquals(originalCode, refreshedUser.getVerificationCode());
        assertTrue(refreshedUser.getVerificationCodeExpiresAt().isAfter(originalExpiry));
    }

    @Test
    void shouldLoginWithValidCredentials() {
        User user = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);
        authService.verifyCode(TEST_EMAIL, user.getVerificationCode());

        User loggedInUser = authService.login(TEST_EMAIL, TEST_PASSWORD);

        assertNotNull(loggedInUser);
        assertEquals(TEST_EMAIL, loggedInUser.getEmail());
        assertNotNull(loggedInUser.getLastLogin());

        User savedUser = userRepository.findByEmail(TEST_EMAIL).orElse(null);
        assertNotNull(savedUser);
        assertNotNull(savedUser.getLastLogin());
    }

    @Test
    void shouldRejectLoginWithInvalidPassword() {
        User user = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);
        authService.verifyCode(TEST_EMAIL, user.getVerificationCode());

        assertThrows(BadCredentialsException.class,
            () -> authService.login(TEST_EMAIL, "wrongpassword"));
    }

    @Test
    void shouldRejectLoginForNonExistentUser() {
        assertThrows(BadCredentialsException.class,
            () -> authService.login("nonexistent@test.com", TEST_PASSWORD));
    }

    @Test
    void shouldCompleteFullAuthenticationFlow() {
        // Register
        User registeredUser = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);
        assertFalse(registeredUser.isEnabled());

        // Verify
        User verifiedUser = authService.verifyCode(TEST_EMAIL, registeredUser.getVerificationCode());
        assertTrue(verifiedUser.isEnabled());

        // Login
        User loggedInUser = authService.login(TEST_EMAIL, TEST_PASSWORD);
        assertNotNull(loggedInUser.getLastLogin());

        // Verify persistence
        User finalUser = userRepository.findByEmail(TEST_EMAIL).orElse(null);
        assertNotNull(finalUser);
        assertTrue(finalUser.isEnabled());
        assertNotNull(finalUser.getLastLogin());
    }
}