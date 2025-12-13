package sk.ucofeed.backend.controller.external;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.ucofeed.backend.persistence.dto.FacultyDTO;
import sk.ucofeed.backend.persistence.dto.StudyProgramDTO;
import sk.ucofeed.backend.persistence.dto.StudyProgramDetailsDTO;
import sk.ucofeed.backend.persistence.dto.StudyProgramVariantDTO;
import sk.ucofeed.backend.persistence.dto.UniversityDTO;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.ReviewRepository;
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
    private final ReviewRepository reviewRepository;

    public UniversityController(UniversityRepository universityRepository,
                               FacultyRepository facultyRepository,
                               StudyProgramRepository studyProgramRepository,
                               ReviewRepository reviewRepository) {
        this.universityRepository = universityRepository;
        this.facultyRepository = facultyRepository;
        this.studyProgramRepository = studyProgramRepository;
        this.reviewRepository = reviewRepository;
    }

    @GetMapping("")
    public ResponseEntity<List<UniversityDTO>> getUniversities() {
        LOG.info("Fetching all universities");
        List<UniversityDTO> universities = universityRepository.findAll()
                .stream()
                .map(university -> {
                    Double rating = reviewRepository.findAverageRatingByUniversityId(university.getId());
                    return UniversityDTO.from(university, rating);
                })
                .toList();
        return ResponseEntity.ok(universities);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UniversityDTO> getUniversityById(@PathVariable Long id) {
        LOG.info("Fetching university with ID: {}", id);
        return universityRepository.findById(id)
                .map(university -> {
                    Double rating = reviewRepository.findAverageRatingByUniversityId(university.getId());
                    return UniversityDTO.from(university, rating);
                })
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/domain/{domain}")
    public ResponseEntity<UniversityDTO> getUniversityByDomain(@PathVariable String domain) {
        LOG.info("Fetching university with domain: {}", domain);
        return universityRepository.findByUniversityEmailDomain(domain)
                .map(university -> {
                    Double rating = reviewRepository.findAverageRatingByUniversityId(university.getId());
                    return UniversityDTO.from(university, rating);
                })
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{universityId}/faculties")
    public ResponseEntity<List<FacultyDTO>> getFacultiesByUniversity(@PathVariable Long universityId) {
        LOG.info("Fetching faculties for university ID: {}", universityId);
        List<FacultyDTO> faculties = facultyRepository.findByUniversityId(universityId)
                .stream()
                .map(faculty -> {
                    Double rating = reviewRepository.findAverageRatingByFacultyId(faculty.getId());
                    return FacultyDTO.from(faculty, rating);
                })
                .toList();
        return ResponseEntity.ok(faculties);
    }

    @GetMapping("/faculty/{id}")
    public ResponseEntity<FacultyDTO> getFacultyById(@PathVariable Long id) {
        LOG.info("Fetching faculty with ID: {}", id);
        return facultyRepository.findById(id)
                .map(faculty -> {
                    Double rating = reviewRepository.findAverageRatingByFacultyId(faculty.getId());
                    return FacultyDTO.from(faculty, rating);
                })
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/faculty/{facultyId}/programs")
    public ResponseEntity<List<StudyProgramDTO>> getProgramsByFaculty(@PathVariable Long facultyId) {
        LOG.info("Fetching programs for faculty ID: {}", facultyId);
        List<StudyProgramDTO> programs = studyProgramRepository.findByFacultyId(facultyId)
                .stream()
                .map(program -> {
                    Double rating = reviewRepository.findAverageRatingByStudyProgram(program);
                    return StudyProgramDTO.from(program, rating);
                })
                .toList();
        return ResponseEntity.ok(programs);
    }

    @GetMapping("/program/{id}")
    public ResponseEntity<StudyProgramDetailsDTO> getStudyProgramById(@PathVariable Long id) {
        LOG.info("Fetching study program with ID: {}", id);
        return studyProgramRepository.findById(id)
                .map(program -> {
                    Double rating = reviewRepository.findAverageRatingByStudyProgram(program);
                    return StudyProgramDetailsDTO.from(program, rating);
                })
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
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
