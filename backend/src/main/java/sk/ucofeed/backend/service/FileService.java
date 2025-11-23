package sk.ucofeed.backend.service;

import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.UniversityFileDataDTO;

import java.util.List;

public interface FileService {
    void saveStudyProgramFromFile(List<UniversityFileDataDTO> data);

    List<UniversityFileDataDTO> parseFile(MultipartFile file);


    List<UniversityFileDataDTO> getAllUniversityData();
}
