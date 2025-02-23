package sk.ucofeed.backend.controller.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.ucofeed.backend.persistence.model.University;

import java.util.List;

@RestController
@RequestMapping("/api/public")
public class UniversityController {

    private static final Logger LOG = LoggerFactory.getLogger(UniversityController.class);

    @GetMapping("/university")
    public ResponseEntity<List<University>> getUniversities() {
        LOG.info("Fetching University Data");
        List<University> data = List.of(
                new University(1L, "STU"),
                new University(2L, "EUBA")
        );
        return ResponseEntity.ok(data);
    }

}
