package sk.ucofeed.backend.persistence.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@Entity
public class LanguageGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Name should be set carefully and correctly reflect languages
     * it contains. It is possible to use more sophisticated approach via
     * hash, but for now we keep it simple as this
     */
    @Column(unique = true, nullable = false)
    @Comment("Unique language group identifier (must reflect contained languages)")
    private String name;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(
        name = "language_group_language",
        joinColumns = @JoinColumn(name = "language_group_id"),
        inverseJoinColumns = @JoinColumn(name = "language_id")
    )
    private List<Language> languages = new ArrayList<>();

    public LanguageGroup(String name) {
        this.name = name;
    }
}
