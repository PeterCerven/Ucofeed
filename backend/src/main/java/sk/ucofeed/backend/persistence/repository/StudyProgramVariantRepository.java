package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;

public interface StudyProgramVariantRepository extends JpaRepository<StudyProgramVariant, Long> {
}