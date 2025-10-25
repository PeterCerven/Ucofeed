package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"study_format", "study_degree", "study_duration,
            language_group_id"})
    }
)
public class StudyProgramVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_group_id", nullable = false)
    private LanguageGroup languageGroup;

    @Column(name = "study_format", nullable = false)
    private String studyFormat;

    @Column(name = "study_degree", nullable = false)
    private int studyDegree;

    @Column(name = "study_duration", nullable = false)
    private int studyDuration;

    private String title;

    public StudyProgramVariant(LanguageGroup languageGroup, String studyFormat,
        int studyDegree, int studyDuration, String title) {

        this.languageGroup = languageGroup;
        this.studyFormat = studyFormat;
        this.studyDegree = studyDegree;
        this.studyDuration = studyDuration;
        this.title = title;
    }
}
