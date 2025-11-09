package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.StudyProgram;

import java.util.Optional;
import java.util.UUID;

public interface StudyProgramRepository extends JpaRepository<StudyProgram, UUID> {
    Optional<StudyProgram> findByNameAndFaculty(String s, Faculty faculty);
}
