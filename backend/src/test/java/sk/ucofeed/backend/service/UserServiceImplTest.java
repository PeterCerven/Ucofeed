package sk.ucofeed.backend.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import sk.ucofeed.backend.exception.UserNotVerifiedException;
import sk.ucofeed.backend.persistence.dto.UpdateUserDTO;
import sk.ucofeed.backend.persistence.dto.UserResponseDTO;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramVariantRepository;
import sk.ucofeed.backend.persistence.repository.UserRepository;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyProgramRepository studyProgramRepository;

    @Mock
    private StudyProgramVariantRepository studyProgramVariantRepository;

    @InjectMocks
    private UserServiceImpl userService;

    private User testUser;
    private StudyProgram testStudyProgram;
    private StudyProgramVariant testVariant;
    private UUID testUserId;

    @BeforeEach
    void setUp() {
        testUserId = UUID.randomUUID();
        testUser = new User("test@example.com", "Test User", "password", User.Role.USER);
        testUser.setId(testUserId);
        testUser.setEnabled(true);

        University university = new University("Test University", "test.edu");
        Faculty faculty = new Faculty("Test Faculty", university);
        testStudyProgram = new StudyProgram("Test Program", faculty, "Test Field");
        testStudyProgram.setId(1L);

        testVariant = new StudyProgramVariant("Slovak", sk.ucofeed.backend.persistence.dto.StudyForm.FULL_TIME, "Bc.");
        testVariant.setId(1L);
    }

    @Test
    void getAllUsers_ShouldReturnListOfUsers() {
        List<User> users = Collections.singletonList(testUser);
        when(userRepository.findAll()).thenReturn(users);

        List<UserResponseDTO> result = userService.getAllUsers();

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(userRepository, times(1)).findAll();
    }

    @Test
    void getUserById_WhenUserExists_ShouldReturnUser() {
        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));

        UserResponseDTO result = userService.getUserById(testUserId.toString());

        assertNotNull(result);
        assertEquals(testUser.getEmail(), result.getEmail());
        verify(userRepository, times(1)).findById(testUserId);
    }

    @Test
    void getUserById_WhenUserNotFound_ShouldThrowException() {
        UUID nonExistentId = UUID.randomUUID();
        when(userRepository.findById(nonExistentId)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> userService.getUserById(nonExistentId.toString()));
        verify(userRepository, times(1)).findById(nonExistentId);
    }

    @Test
    void updateUser_WhenUserNotVerified_ShouldThrowUserNotVerifiedException() {
        testUser.setEnabled(false);
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(1L);
        updateDTO.setStudyProgramVariantId(1L);
        updateDTO.setStatus("ENROLLED");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));

        assertThrows(UserNotVerifiedException.class,
            () -> userService.updateUser(testUserId, updateDTO));
        verify(userRepository, times(1)).findById(testUserId);
        verify(userRepository, never()).save(any());
    }

    @Test
    void updateUser_WhenCreatingNewEducation_ShouldAddEducation() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(1L);
        updateDTO.setStudyProgramVariantId(1L);
        updateDTO.setStatus("ENROLLED");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(studyProgramVariantRepository.findById(1L)).thenReturn(Optional.of(testVariant));
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        UserResponseDTO result = userService.updateUser(testUserId, updateDTO);

        assertNotNull(result);
        verify(userRepository, times(1)).save(testUser);
        assertEquals(1, testUser.getEducations().size());
    }

    @Test
    void updateUser_WhenUpdatingExistingEducation_ShouldUpdateEducation() {
        UserEducation existingEducation = new UserEducation(
            testUser, testStudyProgram, testVariant, UserEducation.Status.ENROLLED
        );
        testUser.getEducations().add(existingEducation);

        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(1L);
        updateDTO.setStudyProgramVariantId(1L);
        updateDTO.setStatus("COMPLETED");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(studyProgramVariantRepository.findById(1L)).thenReturn(Optional.of(testVariant));
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        UserResponseDTO result = userService.updateUser(testUserId, updateDTO);

        assertNotNull(result);
        verify(userRepository, times(1)).save(testUser);
        assertEquals(UserEducation.Status.COMPLETED, testUser.getEducations().getFirst().getStatus());
    }

    @Test
    void updateUser_WhenStudyProgramNotFound_ShouldThrowException() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(999L);
        updateDTO.setStudyProgramVariantId(1L);
        updateDTO.setStatus("ENROLLED");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
        when(studyProgramRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class,
            () -> userService.updateUser(testUserId, updateDTO));
    }

    @Test
    void updateUser_WhenStudyProgramVariantNotFound_ShouldThrowException() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(1L);
        updateDTO.setStudyProgramVariantId(999L);
        updateDTO.setStatus("ENROLLED");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(studyProgramVariantRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class,
            () -> userService.updateUser(testUserId, updateDTO));
    }

    @Test
    void updateUser_WhenInvalidStatus_ShouldThrowException() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(1L);
        updateDTO.setStudyProgramVariantId(1L);
        updateDTO.setStatus("INVALID_STATUS");

        when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
        when(studyProgramRepository.findById(1L)).thenReturn(Optional.of(testStudyProgram));
        when(studyProgramVariantRepository.findById(1L)).thenReturn(Optional.of(testVariant));

        assertThrows(RuntimeException.class,
            () -> userService.updateUser(testUserId, updateDTO));
    }
}