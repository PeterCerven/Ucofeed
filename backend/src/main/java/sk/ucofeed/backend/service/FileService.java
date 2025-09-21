package sk.ucofeed.backend.service;

import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.UniversityFileData;

import java.util.List;

public interface FileService {
    void saveStudyProgramFromFile(List<UniversityFileData> data);

    List<UniversityFileData> parseFile(MultipartFile file);
}
