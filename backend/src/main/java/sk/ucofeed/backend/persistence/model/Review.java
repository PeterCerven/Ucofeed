package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uk_review_user_program_semester",
            columnNames = {"user_id", "study_program_id", "semester"}
        )
    }
)
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_program_id", nullable = false)
    private StudyProgram studyProgram;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_program_variant_id", nullable = false)
    private StudyProgramVariant studyProgramVariant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Min(value = 1, message = "Semester must be at least 1")
    private int semester;

    private String comment;

    @Min(value = 1, message = "Rating must be at least 1")
    @Max(value = 10, message = "Rating must be at most 10")
    @Column(nullable = false)
    private int rating;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    private boolean anonymous;
}
