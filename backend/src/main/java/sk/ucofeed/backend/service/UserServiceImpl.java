package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.UpdateUserDTO;
import sk.ucofeed.backend.persistence.dto.UserResponseDTO;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.model.UserEducation;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramVariantRepository;
import sk.ucofeed.backend.persistence.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger LOG = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserRepository userRepository;
    private final StudyProgramRepository studyProgramRepository;
    private final StudyProgramVariantRepository studyProgramVariantRepository;

    public UserServiceImpl(UserRepository userRepository,
                          StudyProgramRepository studyProgramRepository,
                          StudyProgramVariantRepository studyProgramVariantRepository) {
        this.userRepository = userRepository;
        this.studyProgramRepository = studyProgramRepository;
        this.studyProgramVariantRepository = studyProgramVariantRepository;
    }


    @Override
    public List<UserResponseDTO> getAllUsers() {
        return userRepository.findAll().stream().map(UserResponseDTO::from).toList();
    }

    @Override
    public UserResponseDTO getUserById(String id) {
        User user = userRepository.findById(UUID.fromString(id))
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        return UserResponseDTO.from(user);
    }

    @Override
    @Transactional
    public UserResponseDTO updateUser(UUID userId, UpdateUserDTO updateUserDto) {
        LOG.info("Updating user {} with data {}", userId, updateUserDto);

        // Find user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        // Update basic user info if provided
        if (updateUserDto.getFullName() != null && !updateUserDto.getFullName().isEmpty()) {
            user.setFullName(updateUserDto.getFullName());
        }

        // Find study program and variant
        StudyProgram studyProgram = studyProgramRepository.findById(updateUserDto.getStudyProgramId())
                .orElseThrow(() -> new RuntimeException("Study program not found with id: " + updateUserDto.getStudyProgramId()));

        StudyProgramVariant studyProgramVariant = studyProgramVariantRepository.findById(updateUserDto.getStudyProgramVariantId())
                .orElseThrow(() -> new RuntimeException("Study program variant not found with id: " + updateUserDto.getStudyProgramVariantId()));

        // Parse status
        UserEducation.Status status;
        try {
            status = UserEducation.Status.valueOf(updateUserDto.getStatus().toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid status: " + updateUserDto.getStatus());
        }

        // Check if user education already exists for this study program
        UserEducation userEducation = user.getEducations().stream()
                .filter(ed -> ed.getStudyProgram().getId().equals(studyProgram.getId()))
                .findFirst()
                .orElse(null);

        if (userEducation == null) {
            // Create new user education
            userEducation = new UserEducation(user, studyProgram, studyProgramVariant, status);
            user.getEducations().add(userEducation);
        } else {
            // Update existing user education
            userEducation.setStudyProgramVariant(studyProgramVariant);
            userEducation.setStatus(status);
        }

        // Save user (cascades to user education)
        user = userRepository.save(user);
        LOG.info("User updated successfully: {}", user.getId());

        return UserResponseDTO.from(user);
    }
}
