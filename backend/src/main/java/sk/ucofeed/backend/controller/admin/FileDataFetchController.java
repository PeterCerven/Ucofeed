package sk.ucofeed.backend.controller.admin;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.service.FileCSVService;

import java.util.List;

@RestController
@RequestMapping("/api/private")
public class FileDataFetchController {

    private final FileCSVService fileCSVService;

    public FileDataFetchController(FileCSVService fileCSVService) {
        this.fileCSVService = fileCSVService;
    }

    @PostMapping("/upload-csv")
    public ResponseEntity<String> uploadCSV(@RequestParam("file") MultipartFile file) {
        try {
            fileCSVService.saveStudyProgramDataFromCSV(file);
            return ResponseEntity.ok("CSV file uploaded successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error uploading CSV file: " + e.getMessage());
        }
    }
}
