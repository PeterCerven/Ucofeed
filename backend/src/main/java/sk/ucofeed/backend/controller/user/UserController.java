package sk.ucofeed.backend.controller.user;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import sk.ucofeed.backend.persistence.dto.UpdateUserDTO;
import sk.ucofeed.backend.persistence.dto.UserResponseDTO;
import sk.ucofeed.backend.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/user/public/user")
public class UserController {

    private static final Logger LOG = LoggerFactory.getLogger(UserController.class);


    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("")
    public ResponseEntity<List<UserResponseDTO>> getAllUsers() {
        List<UserResponseDTO> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponseDTO> getUserById(@PathVariable String id) {
        LOG.info("Fetching User ID {}", id);
        UserResponseDTO user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserResponseDTO> updateUser(
            @PathVariable String id,
            @Valid @RequestBody @NotNull UpdateUserDTO updateUserDto) {
        LOG.info("Updating User ID {} with data {}", id, updateUserDto);
        UserResponseDTO updatedUser = userService.updateUser(UUID.fromString(id), updateUserDto);
        return ResponseEntity.ok(updatedUser);
    }
}
