package sk.ucofeed.backend.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import sk.ucofeed.backend.exception.UserNotVerifiedException;
import sk.ucofeed.backend.persistence.dto.UpdateUserDTO;
import sk.ucofeed.backend.persistence.dto.UserResponseDTO;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.*;
import sk.ucofeed.backend.service.UserService;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UniversityRepository universityRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudyProgramRepository studyProgramRepository;

    @Autowired
    private StudyProgramVariantRepository studyProgramVariantRepository;

    private User testUser;
    private StudyProgram testStudyProgram;
    private StudyProgramVariant testVariant;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        studyProgramRepository.deleteAll();
        facultyRepository.deleteAll();
        universityRepository.deleteAll();
        studyProgramVariantRepository.deleteAll();

        // Create test data
        University university = new University("Test University", "test.edu");
        university = universityRepository.save(university);

        Faculty faculty = new Faculty("Test Faculty", university);
        faculty = facultyRepository.save(faculty);

        testStudyProgram = new StudyProgram("Computer Science", faculty, "Computer Science");
        testStudyProgram = studyProgramRepository.save(testStudyProgram);

        testVariant = new StudyProgramVariant("English", sk.ucofeed.backend.persistence.dto.StudyForm.FULL_TIME, "Bc.");
        testVariant = studyProgramVariantRepository.save(testVariant);

        testUser = new User("user@test.com", "Test User", "password", User.Role.USER);
        testUser.setEnabled(true);
        testUser = userRepository.save(testUser);
    }

    @Test
    void shouldGetAllUsers() {
        User user2 = new User("user2@test.com", "Test User 2", "password", User.Role.USER);
        user2.setEnabled(true);
        userRepository.save(user2);

        List<UserResponseDTO> users = userService.getAllUsers();

        assertNotNull(users);
        assertEquals(2, users.size());
    }

    @Test
    void shouldGetUserById() {
        UserResponseDTO userDTO = userService.getUserById(testUser.getId().toString());

        assertNotNull(userDTO);
        assertEquals(testUser.getEmail(), userDTO.getEmail());
        assertEquals(testUser.getFullName(), userDTO.getFullName());
    }

    @Test
    void shouldThrowExceptionWhenUserNotFound() {
        UUID randomId = UUID.randomUUID();

        assertThrows(RuntimeException.class,
            () -> userService.getUserById(randomId.toString()));
    }

    @Test
    void shouldUpdateUserWithNewEducation() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(testStudyProgram.getId());
        updateDTO.setStudyProgramVariantId(testVariant.getId());
        updateDTO.setStatus("ENROLLED");

        UserResponseDTO result = userService.updateUser(testUser.getId(), updateDTO);

        assertNotNull(result);
        assertEquals(1, result.getEducations().size());
        assertEquals("ENROLLED", result.getEducations().getFirst().getStatus());

        User savedUser = userRepository.findById(testUser.getId()).orElse(null);
        assertNotNull(savedUser);
        assertEquals(1, savedUser.getEducations().size());
    }

    @Test
    void shouldUpdateExistingEducation() {
        // First add an education
        UserEducation education = new UserEducation(testUser, testStudyProgram, testVariant, UserEducation.Status.ENROLLED);
        testUser.getEducations().add(education);
        testUser = userRepository.save(testUser);

        // Now update it
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(testStudyProgram.getId());
        updateDTO.setStudyProgramVariantId(testVariant.getId());
        updateDTO.setStatus("COMPLETED");

        UserResponseDTO result = userService.updateUser(testUser.getId(), updateDTO);

        assertNotNull(result);
        assertEquals(1, result.getEducations().size());
        assertEquals("COMPLETED", result.getEducations().getFirst().getStatus());

        User savedUser = userRepository.findById(testUser.getId()).orElse(null);
        assertNotNull(savedUser);
        assertEquals(1, savedUser.getEducations().size());
        assertEquals(UserEducation.Status.COMPLETED, savedUser.getEducations().getFirst().getStatus());
    }

    @Test
    void shouldRejectUpdateForUnverifiedUser() {
        testUser.setEnabled(false);
        testUser = userRepository.save(testUser);

        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(testStudyProgram.getId());
        updateDTO.setStudyProgramVariantId(testVariant.getId());
        updateDTO.setStatus("ENROLLED");

        assertThrows(UserNotVerifiedException.class,
            () -> userService.updateUser(testUser.getId(), updateDTO));
    }

    @Test
    void shouldThrowExceptionWhenStudyProgramNotFound() {
        UpdateUserDTO updateDTO = new UpdateUserDTO();
        updateDTO.setStudyProgramId(999L);
        updateDTO.setStudyProgramVariantId(testVariant.getId());
        updateDTO.setStatus("ENROLLED");

        assertThrows(RuntimeException.class,
            () -> userService.updateUser(testUser.getId(), updateDTO));
    }

    @Test
    void shouldHandleMultipleEducationsForSameUser() {
        // Create another study program
        University university2 = universityRepository.findAll().getFirst();
        Faculty faculty2 = new Faculty("Another Faculty", university2);
        faculty2 = facultyRepository.save(faculty2);

        StudyProgram program2 = new StudyProgram("Mathematics", faculty2, "Mathematics");
        program2 = studyProgramRepository.save(program2);

        // Add first education
        UpdateUserDTO updateDTO1 = new UpdateUserDTO();
        updateDTO1.setStudyProgramId(testStudyProgram.getId());
        updateDTO1.setStudyProgramVariantId(testVariant.getId());
        updateDTO1.setStatus("ENROLLED");
        userService.updateUser(testUser.getId(), updateDTO1);

        // Add second education
        UpdateUserDTO updateDTO2 = new UpdateUserDTO();
        updateDTO2.setStudyProgramId(program2.getId());
        updateDTO2.setStudyProgramVariantId(testVariant.getId());
        updateDTO2.setStatus("COMPLETED");
        UserResponseDTO result = userService.updateUser(testUser.getId(), updateDTO2);

        assertNotNull(result);
        assertEquals(2, result.getEducations().size());

        User savedUser = userRepository.findById(testUser.getId()).orElse(null);
        assertNotNull(savedUser);
        assertEquals(2, savedUser.getEducations().size());
    }
}