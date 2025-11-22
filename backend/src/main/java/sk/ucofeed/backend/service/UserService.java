package sk.ucofeed.backend.service;
import sk.ucofeed.backend.persistence.dto.UpdateUserDTO;
import sk.ucofeed.backend.persistence.dto.UserResponseDTO;


import java.util.List;
import java.util.UUID;

public interface UserService {
    List<UserResponseDTO> getAllUsers();

    UserResponseDTO getUserById(String id);

    UserResponseDTO updateUser(UUID userId, UpdateUserDTO updateUserDto);
}
