package sk.ucofeed.backend.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/health")
public class HealthCheckController {

    private static final Logger LOG = LoggerFactory.getLogger(HealthCheckController.class);

    @GetMapping("")
    public ResponseEntity<String> handlePing() {
        LOG.debug("Health Check Endpoint Called");
        return ResponseEntity.ok("good");
    }
}