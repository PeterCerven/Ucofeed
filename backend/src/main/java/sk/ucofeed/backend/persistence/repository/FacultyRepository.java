package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.Faculty;

import java.util.UUID;

public interface FacultyRepository extends JpaRepository<Faculty, UUID> {
}
