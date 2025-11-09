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
        @UniqueConstraint(columnNames = {"user_id", "study_program_id, study_program_variant_id"})
    }
)
public class UserEducation {
    public enum Status {
        ENROLLED,
        ON_HOLD,
        COMPLETED,
        DROPPED_OUT
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_program_id", nullable = false)
    private StudyProgram studyProgram;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_program_variant_id", nullable = false)
    private StudyProgramVariant studyProgramVariant;

    @Enumerated(EnumType.STRING)
    private Status status;

    public UserEducation(User user, StudyProgram studyProgram, StudyProgramVariant studyProgramVariant, Status status) {
        this.user = user;
        this.studyProgram = studyProgram;
        this.studyProgramVariant = studyProgramVariant;
        this.status = status;
    }
}
