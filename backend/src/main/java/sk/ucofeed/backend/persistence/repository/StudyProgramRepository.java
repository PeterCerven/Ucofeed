package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.StudyProgram;

import java.util.List;
import java.util.Optional;

public interface StudyProgramRepository extends JpaRepository<StudyProgram, Long> {
    Optional<StudyProgram> findByNameAndFaculty(String s, Faculty faculty);
    List<StudyProgram> findByFacultyId(Long facultyId);
}
