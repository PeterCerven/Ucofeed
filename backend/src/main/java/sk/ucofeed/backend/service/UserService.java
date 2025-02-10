package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.CreateUserDto;
import sk.ucofeed.backend.persistence.dto.UserResponseDto;
import sk.ucofeed.backend.persistence.model.User;

import java.util.List;

public interface UserService {
    User createUser(CreateUserDto userData);

    List<UserResponseDto> getAllUsers();
}
