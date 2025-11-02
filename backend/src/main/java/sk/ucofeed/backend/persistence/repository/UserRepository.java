package sk.ucofeed.backend.persistence.repository;


import sk.ucofeed.backend.persistence.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    User findByEmail(String email);
}
