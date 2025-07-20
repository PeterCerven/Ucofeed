package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.University;

import java.util.Optional;
import java.util.UUID;

public interface UniversityRepository extends JpaRepository<University, UUID> {
    Optional<University> findByName(String university);
}
