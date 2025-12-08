package sk.ucofeed.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Random;

@Service
public class AuthServiceImpl implements AuthService {

    private static final Logger LOG = LoggerFactory.getLogger(AuthServiceImpl.class);
    private static final int CODE_EXPIRATION_MINUTES = 15;
    private static final int VERIFICATION_CODE_LENGTH = 6;

    private final UserRepository userRepository;
    private final EmailServiceImpl emailService;
    private final PasswordEncoder passwordEncoder;

    public AuthServiceImpl(
            UserRepository userRepository,
            EmailServiceImpl emailService,
            PasswordEncoder passwordEncoder
    ) {
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public User registerUser(String email, String password) {
        LOG.info("Registering user with email: {}", email);

        // Check if user already exists
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("User with this email already exists");
        }

        // Create new user with encoded password
        User user = new User(email, passwordEncoder.encode(password), User.Role.USER);
        user.setEnabled(false); // User is disabled until email is verified

        // Generate and set verification code
        String verificationCode = generateVerificationCode();
        user.setVerificationCode(verificationCode);
        user.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(CODE_EXPIRATION_MINUTES));

        userRepository.save(user);

        // Send verification email
        emailService.sendVerificationCode(email, verificationCode);
        LOG.info("User registered and verification code sent successfully to: {}", email);
        return user;
    }

    @Override
    @Transactional
    public User verifyCode(String email, String verificationCode) {
        LOG.info("Verifying code for email: {}", email);

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (user.getVerificationCode() == null) {
            throw new IllegalArgumentException("No verification code found. Please request a new code.");
        }

        if (!user.getVerificationCode().equals(verificationCode)) {
            throw new IllegalArgumentException("Invalid verification code");
        }

        if (user.getVerificationCodeExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Verification code has expired. Please request a new code.");
        }

        // Enable user and clear verification code
        user.setEnabled(true);
        user.setVerificationCode(null);
        user.setVerificationCodeExpiresAt(null);

        userRepository.save(user);
        LOG.info("User verified successfully: {}", email);

        return user;
    }

    @Override
    @Transactional
    public User login(String email, String password) {
        LOG.info("Login attempt for email: {}", email);

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BadCredentialsException("Invalid email or password"));

        if (!user.isEnabled()) {
            throw new BadCredentialsException("Account not verified. Please verify your email first.");
        }

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BadCredentialsException("Invalid email or password");
        }

        user.markLoggedIn();
        userRepository.save(user);

        LOG.info("User logged in successfully: {}", email);
        return user;
    }

    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < VERIFICATION_CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }
}
