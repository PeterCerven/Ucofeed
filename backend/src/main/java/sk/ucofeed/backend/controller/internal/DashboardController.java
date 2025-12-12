package sk.ucofeed.backend.controller.internal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import sk.ucofeed.backend.persistence.dto.DashboardMessageDataDTO;
import sk.ucofeed.backend.service.DashboardService;

import java.util.List;

@RestController
@RequestMapping("/api/private/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/message")
    public ResponseEntity<List<DashboardMessageDataDTO>> getAllDashboardMessages() {
        try {
            List<DashboardMessageDataDTO> data = dashboardService.getAllDashboardMessages();
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @DeleteMapping("/message/{id}")
    public ResponseEntity<Void> deleteDashboardMessage(@PathVariable Long id) {
        try {
            dashboardService.deleteDashboardMessage(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}
