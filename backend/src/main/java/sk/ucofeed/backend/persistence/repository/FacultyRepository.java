package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.University;

import java.util.Optional;
import java.util.UUID;

public interface FacultyRepository extends JpaRepository<Faculty, UUID> {
    Optional<Faculty> findByNameAndUniversity(String faculty, University university);
}
