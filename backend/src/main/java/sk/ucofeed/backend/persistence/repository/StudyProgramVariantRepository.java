package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.dto.StudyForm;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;

import java.util.Optional;

public interface StudyProgramVariantRepository extends JpaRepository<StudyProgramVariant, Long> {
    Optional<StudyProgramVariant> findByLanguageAndStudyFormAndTitle(String language, StudyForm studyForm, String title);
}