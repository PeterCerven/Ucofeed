package sk.ucofeed.backend.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.ucofeed.backend.persistence.model.DashboardMessage;

public interface DashboardRepository extends JpaRepository<DashboardMessage, Long> {
    // CRUD Ops provided by JpaRepository are enough
}
