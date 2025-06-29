package sk.ucofeed.backend.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileCSVService {
    void saveStudyProgramDataFromCSV(MultipartFile file);
}
