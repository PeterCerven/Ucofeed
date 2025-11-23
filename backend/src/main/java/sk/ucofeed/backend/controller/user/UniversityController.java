package sk.ucofeed.backend.controller.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.ucofeed.backend.persistence.dto.FacultyDTO;
import sk.ucofeed.backend.persistence.dto.StudyProgramDTO;
import sk.ucofeed.backend.persistence.dto.StudyProgramVariantDTO;
import sk.ucofeed.backend.persistence.dto.UniversityDTO;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import java.util.List;

@RestController
@RequestMapping("/api/public/university")
public class UniversityController {

    private static final Logger LOG = LoggerFactory.getLogger(UniversityController.class);

    private final UniversityRepository universityRepository;
    private final FacultyRepository facultyRepository;
    private final StudyProgramRepository studyProgramRepository;

    public UniversityController(UniversityRepository universityRepository,
                               FacultyRepository facultyRepository,
                               StudyProgramRepository studyProgramRepository) {
        this.universityRepository = universityRepository;
        this.facultyRepository = facultyRepository;
        this.studyProgramRepository = studyProgramRepository;
    }

    @GetMapping("")
    public ResponseEntity<List<UniversityDTO>> getUniversities() {
        LOG.info("Fetching all universities");
        List<UniversityDTO> universities = universityRepository.findAll()
                .stream()
                .map(UniversityDTO::from)
                .toList();
        return ResponseEntity.ok(universities);
    }

    @GetMapping("/{universityId}/faculties")
    public ResponseEntity<List<FacultyDTO>> getFacultiesByUniversity(@PathVariable Long universityId) {
        LOG.info("Fetching faculties for university ID: {}", universityId);
        List<FacultyDTO> faculties = facultyRepository.findByUniversityId(universityId)
                .stream()
                .map(FacultyDTO::from)
                .toList();
        return ResponseEntity.ok(faculties);
    }

    @GetMapping("/faculty/{facultyId}/programs")
    public ResponseEntity<List<StudyProgramDTO>> getProgramsByFaculty(@PathVariable Long facultyId) {
        LOG.info("Fetching programs for faculty ID: {}", facultyId);
        List<StudyProgramDTO> programs = studyProgramRepository.findByFacultyId(facultyId)
                .stream()
                .map(StudyProgramDTO::from)
                .toList();
        return ResponseEntity.ok(programs);
    }

    @GetMapping("/program/{programId}/variants")
    public ResponseEntity<List<StudyProgramVariantDTO>> getVariantsByProgram(@PathVariable Long programId) {
        LOG.info("Fetching variants for program ID: {}", programId);
        List<StudyProgramVariantDTO> variants = studyProgramRepository.findById(programId)
                .map(program -> program.getStudyProgramVariants().stream()
                        .map(StudyProgramVariantDTO::from)
                        .toList())
                .orElse(List.of());
        return ResponseEntity.ok(variants);
    }
}
