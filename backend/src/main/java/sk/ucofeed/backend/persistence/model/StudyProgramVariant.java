package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import sk.ucofeed.backend.persistence.dto.StudyForm;

@Data
@NoArgsConstructor
@Entity
@Table(uniqueConstraints = {
    @UniqueConstraint(columnNames = {"language", "study_form", "title"})
})
public class StudyProgramVariant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "language", nullable = false)
    private String language;

    @Enumerated(EnumType.STRING)
    @Column(name = "study_form")
    private StudyForm studyForm;

    @Column(name = "title")
    private String title;

    public StudyProgramVariant(String language, StudyForm studyForm, String title) {
        this.language = language;
        this.studyForm = studyForm == null ? null : StudyForm.FULL_TIME;
        this.title = title;
    }
}
