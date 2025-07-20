package sk.ucofeed.backend.controller.admin;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.ucofeed.backend.persistence.dto.UniversityFileData;
import sk.ucofeed.backend.service.FileService;

import java.util.List;

@RestController
@RequestMapping("/api/private")
public class FileDataFetchController {

    private final FileService fileService;

    public FileDataFetchController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload-data")
    public ResponseEntity<String> uploadFileData(@RequestBody List<UniversityFileData> data) {
        try {
            fileService.saveStudyProgramFromFile(data);
            return ResponseEntity.ok("File data uploaded successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error uploading file data: " + e.getMessage());
        }
    }
}
