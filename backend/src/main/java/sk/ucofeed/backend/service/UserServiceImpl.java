package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.CreateUserDto;
import sk.ucofeed.backend.persistence.dto.ErrorDto;
import sk.ucofeed.backend.persistence.dto.UserResponseDto;
import sk.ucofeed.backend.exception.UserAlreadyExistsException;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger LOG = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User createUser(CreateUserDto userData) {
        if (userRepository.findByEmail(userData.getEmail()) != null) {
            throw userAlreadyExistsException("A user with this email already exists");
        }

        User user = new User(userData.getEmail(), userData.getFullName(),
                            userData.getPassword(), userData.getRole());
        user = userRepository.save(user);
        LOG.info("Data Saved Successfully : {}", user);
        return user;
    }

    @Override
    public List<UserResponseDto> getAllUsers() {
        return userRepository.findAll().stream().map(UserResponseDto::from).toList();
    }

    private UserAlreadyExistsException userAlreadyExistsException(String message) {
        return UserAlreadyExistsException
                .builder()
                .errorType(ErrorDto.ErrorType.USER_ALREADY_EXISTS)
                .message(message)
                .build();
    }
}
