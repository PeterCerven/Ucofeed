package sk.ucofeed.backend.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private EmailServiceImpl emailService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private AuthServiceImpl authService;

    private User testUser;
    private static final String TEST_EMAIL = "test@example.com";
    private static final String TEST_NAME = "Test User";
    private static final String TEST_PASSWORD = "password123";
    private static final String ENCODED_PASSWORD = "encodedPassword";

    @BeforeEach
    void setUp() {
        testUser = new User(TEST_EMAIL, TEST_NAME, ENCODED_PASSWORD, User.Role.USER);
        testUser.setEnabled(true);
    }

    @Test
    void registerUser_WhenUserDoesNotExist_ShouldCreateAndReturnUser() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.empty());
        when(passwordEncoder.encode(TEST_PASSWORD)).thenReturn(ENCODED_PASSWORD);
        when(userRepository.save(any(User.class))).thenReturn(testUser);
        doNothing().when(emailService).sendVerificationCode(anyString(), anyString());

        User result = authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD);

        assertNotNull(result);
        assertEquals(TEST_EMAIL, result.getEmail());
        assertFalse(result.isEnabled());
        assertNotNull(result.getVerificationCode());
        assertNotNull(result.getVerificationCodeExpiresAt());

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(passwordEncoder, times(1)).encode(TEST_PASSWORD);
        verify(userRepository, times(1)).save(any(User.class));
        verify(emailService, times(1)).sendVerificationCode(eq(TEST_EMAIL), anyString());
    }

    @Test
    void registerUser_WhenUserAlreadyExists_ShouldThrowException() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));

        assertThrows(IllegalArgumentException.class,
            () -> authService.registerUser(TEST_EMAIL, TEST_NAME, TEST_PASSWORD));

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(userRepository, never()).save(any());
        verify(emailService, never()).sendVerificationCode(anyString(), anyString());
    }

    @Test
    void verifyCode_WhenCodeIsValid_ShouldEnableUserAndClearCode() {
        String validCode = "123456";
        testUser.setVerificationCode(validCode);
        testUser.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(5));
        testUser.setEnabled(false);

        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User result = authService.verifyCode(TEST_EMAIL, validCode);

        assertNotNull(result);
        assertTrue(result.isEnabled());
        assertNull(result.getVerificationCode());
        assertNull(result.getVerificationCodeExpiresAt());

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(userRepository, times(1)).save(testUser);
    }

    @Test
    void verifyCode_WhenUserNotFound_ShouldThrowException() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, "123456"));

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(userRepository, never()).save(any());
    }

    @Test
    void verifyCode_WhenNoVerificationCode_ShouldThrowException() {
        testUser.setVerificationCode(null);
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, "123456"));

        verify(userRepository, never()).save(any());
    }

    @Test
    void verifyCode_WhenCodeIsInvalid_ShouldThrowException() {
        testUser.setVerificationCode("123456");
        testUser.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(5));

        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, "999999"));

        verify(userRepository, never()).save(any());
    }

    @Test
    void verifyCode_WhenCodeIsExpired_ShouldThrowException() {
        String validCode = "123456";
        testUser.setVerificationCode(validCode);
        testUser.setVerificationCodeExpiresAt(LocalDateTime.now().minusMinutes(1));

        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));

        assertThrows(IllegalArgumentException.class,
            () -> authService.verifyCode(TEST_EMAIL, validCode));

        verify(userRepository, never()).save(any());
    }

    @Test
    void refreshVerificationCode_WhenUserExists_ShouldGenerateNewCode() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));
        when(userRepository.save(any(User.class))).thenReturn(testUser);
        doNothing().when(emailService).sendVerificationCode(anyString(), anyString());

        authService.refreshVerificationCode(TEST_EMAIL);

        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userRepository, times(1)).save(userCaptor.capture());

        User savedUser = userCaptor.getValue();
        assertNotNull(savedUser.getVerificationCode());
        assertNotNull(savedUser.getVerificationCodeExpiresAt());
        assertTrue(savedUser.getVerificationCodeExpiresAt().isAfter(LocalDateTime.now()));

        verify(emailService, times(1)).sendVerificationCode(eq(TEST_EMAIL), anyString());
    }

    @Test
    void refreshVerificationCode_WhenUserNotFound_ShouldThrowException() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class,
            () -> authService.refreshVerificationCode(TEST_EMAIL));

        verify(userRepository, never()).save(any());
        verify(emailService, never()).sendVerificationCode(anyString(), anyString());
    }

    @Test
    void login_WhenCredentialsAreValid_ShouldReturnUserAndUpdateLastLogin() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));
        when(passwordEncoder.matches(TEST_PASSWORD, ENCODED_PASSWORD)).thenReturn(true);
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User result = authService.login(TEST_EMAIL, TEST_PASSWORD);

        assertNotNull(result);
        assertEquals(TEST_EMAIL, result.getEmail());
        assertNotNull(result.getLastLogin());

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(passwordEncoder, times(1)).matches(TEST_PASSWORD, ENCODED_PASSWORD);
        verify(userRepository, times(1)).save(testUser);
    }

    @Test
    void login_WhenUserNotFound_ShouldThrowBadCredentialsException() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.empty());

        assertThrows(BadCredentialsException.class,
            () -> authService.login(TEST_EMAIL, TEST_PASSWORD));

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(passwordEncoder, never()).matches(anyString(), anyString());
        verify(userRepository, never()).save(any());
    }

    @Test
    void login_WhenPasswordIsIncorrect_ShouldThrowBadCredentialsException() {
        when(userRepository.findByEmail(TEST_EMAIL)).thenReturn(Optional.of(testUser));
        when(passwordEncoder.matches(TEST_PASSWORD, ENCODED_PASSWORD)).thenReturn(false);

        assertThrows(BadCredentialsException.class,
            () -> authService.login(TEST_EMAIL, TEST_PASSWORD));

        verify(userRepository, times(1)).findByEmail(TEST_EMAIL);
        verify(passwordEncoder, times(1)).matches(TEST_PASSWORD, ENCODED_PASSWORD);
        verify(userRepository, never()).save(any());
    }
}