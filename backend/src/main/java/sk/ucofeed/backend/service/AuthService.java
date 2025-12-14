package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.model.User;

public interface AuthService {
    User registerUser(String email, String fullName, String password);

    User verifyCode(String email, String verificationCode);

    void refreshVerificationCode(String email);

    User login(String email, String password);
}
