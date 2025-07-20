package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.UniversityFileData;

import java.util.List;

public interface FileService {
    void saveStudyProgramFromFile(List<UniversityFileData> data);
}
