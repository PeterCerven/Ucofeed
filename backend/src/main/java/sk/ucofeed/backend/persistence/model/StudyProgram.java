package sk.ucofeed.backend.persistence.model;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
public class StudyProgram {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToOne(fetch = jakarta.persistence.FetchType.LAZY)
    private Faculty faculty;

    public StudyProgram(String name, Faculty faculty) {
        this.name = name;
        this.faculty = faculty;
    }



}
