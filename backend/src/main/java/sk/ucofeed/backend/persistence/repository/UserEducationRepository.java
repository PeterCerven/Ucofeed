package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.User;
import sk.ucofeed.backend.persistence.model.UserEducation;

import java.util.List;
import java.util.Optional;

public interface UserEducationRepository extends JpaRepository<UserEducation, Long> {
    List<UserEducation> findByUser(User user);
    Optional<UserEducation> findByUserAndId(User user, Long id);
}