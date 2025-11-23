package sk.ucofeed.backend.controller.admin;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.UniversityFileDataDTO;
import sk.ucofeed.backend.service.FileService;

import java.util.List;

@RestController
@RequestMapping("/api/private")
public class FileDataFetchController {

    private final FileService fileService;

    public FileDataFetchController(FileService fileService) {
        this.fileService = fileService;
    }

    @GetMapping("/data")
    public ResponseEntity<List<UniversityFileDataDTO>> getAllUniversityData() {
        try {
            List<UniversityFileDataDTO> data = fileService.getAllUniversityData();
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @PostMapping("/parse-file")
    public ResponseEntity<List<UniversityFileDataDTO>> parseFile(@RequestParam("file") MultipartFile file) {
        try {
            List<UniversityFileDataDTO> parsedData = fileService.parseFile(file);
            return ResponseEntity.ok(parsedData);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @PostMapping("/upload-data")
    public ResponseEntity<String> uploadFileData(@RequestBody List<UniversityFileDataDTO> data) {
        try {
            fileService.saveStudyProgramFromFile(data);
            return ResponseEntity.ok("File data uploaded successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error uploading file data: " + e.getMessage());
        }
    }
}
