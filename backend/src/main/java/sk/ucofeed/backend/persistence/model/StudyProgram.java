package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"faculty_id", "code"})
    }
)
public class StudyProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable=false)
    private String name;

    @Column(nullable=false)
    private String code;

    private String note;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "faculty_id", nullable = false)
    private Faculty faculty;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(
        name = "study_program_study_field",
        joinColumns = @JoinColumn(name = "study_program_id"),
        inverseJoinColumns = @JoinColumn(name = "study_field_id")
    )
    private List<StudyField> studyFields = new ArrayList<>();

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(
        name = "study_program_study_program_variant",
        joinColumns = @JoinColumn(name = "study_program_id"),
        inverseJoinColumns = @JoinColumn(name = "study_program_variant_id")
    )
    private List<StudyProgramVariant> studyProgramVariants = new ArrayList<>();

    @OneToMany(mappedBy = "studyProgram",
               cascade = CascadeType.ALL,
               fetch = FetchType.LAZY,
               orphanRemoval = true)
    private List<Review> reviews = new ArrayList<>();

    public StudyProgram(String name, String code, Faculty faculty) {
        this(name, code, faculty, "");
    }

    public StudyProgram(String name, String code, Faculty faculty, String note) {
        this.name = name;
        this.code = code;
        this.faculty = faculty;
        this.note = note;
    }
}
