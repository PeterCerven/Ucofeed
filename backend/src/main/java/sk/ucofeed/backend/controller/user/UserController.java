package sk.ucofeed.backend.controller.user;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import sk.ucofeed.backend.persistence.dto.CreateUserDto;
import sk.ucofeed.backend.persistence.dto.SuccessResponseDto;
import sk.ucofeed.backend.persistence.dto.UserResponseDto;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user/public")
public class UserController {

    private static final Logger LOG = LoggerFactory.getLogger(UserController.class);


    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }



    @PostMapping("")
    public ResponseEntity<SuccessResponseDto> submitUserDetails(@Valid @RequestBody @NotNull CreateUserDto userData) {
        LOG.info("Received User Data {}", userData);
        User user = userService.createUser(userData);
        return new ResponseEntity<>(
                SuccessResponseDto.builder()
                .message("Success. User ID : " + user.getId())
                .operation(SuccessResponseDto.Operation.CREATE_USER)
                .build(),
                HttpStatus.CREATED);
    }


    @GetMapping("")
    public ResponseEntity<List<UserResponseDto>> getAllUsers() {
        List<UserResponseDto> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }





}
