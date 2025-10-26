package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
@Table(
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"study_format", "study_degree", "study_duration,
            language_group_id"})
    }
)
public class StudyProgramVariant {
    public enum Title {
        BACHELOR("Bc"),
        MASTER("Mgr"),
        ENGINEER("Ing"),
        DOCTOR_MEDIC("MUDr"),
        DOCTOR("PhD");

        private final String abbreviation;

        Title(String abbreviation) {
            this.abbreviation = abbreviation;
        }

        public String getAbbreviation() {
            return abbreviation;
        }
    }

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

    @Enumerated(EnumType.STRING)
    private Title title;

    public StudyProgramVariant(LanguageGroup languageGroup, String studyFormat,
        int studyDegree, int studyDuration) {

        this(languageGroup, studyFormat, studyDegree, studyDuration, null);
    }

    public StudyProgramVariant(LanguageGroup languageGroup, String studyFormat,
        int studyDegree, int studyDuration, Title title) {

        this.languageGroup = languageGroup;
        this.studyFormat = studyFormat;
        this.studyDegree = studyDegree;
        this.studyDuration = studyDuration;
        this.title = title;
    }
}
