package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.model.User;

public interface AuthService {
    User registerUser(String email, String password);

    User verifyCode(String email, String verificationCode);

    User login(String email, String password);
}
