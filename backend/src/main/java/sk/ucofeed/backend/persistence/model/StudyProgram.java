package sk.ucofeed.backend.persistence.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@AllArgsConstructor
public class StudyProgram {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(unique = true)
    private String name;

    @ManyToOne(fetch = jakarta.persistence.FetchType.LAZY)
    private Faculty faculty;



}
