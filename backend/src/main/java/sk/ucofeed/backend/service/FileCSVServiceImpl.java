package sk.ucofeed.backend.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.CSVFileUniversityData;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

@Service
public class FileCSVServiceImpl implements FileCSVService {

    private final FacultyRepository facultyRepository;
    private final UniversityRepository universityRepository;
    private final StudyProgramRepository studyProgramRepository;

    public FileCSVServiceImpl(FacultyRepository facultyRepository,
                              UniversityRepository universityRepository,
                              StudyProgramRepository studyProgramRepository) {
        this.facultyRepository = facultyRepository;
        this.universityRepository = universityRepository;
        this.studyProgramRepository = studyProgramRepository;
    }

    @Override
    public void saveStudyProgramDataFromCSV(MultipartFile file) {
        List<CSVFileUniversityData> csvData = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] values = line.split(",");
                if (values.length == 7) {
                    CSVFileUniversityData data = new CSVFileUniversityData(
                        values[0].trim(), // Program Name
                        values[1].trim(), // University Name
                        values[2].trim(), // Faculty Name
                        values[3].trim(), // Education Level
                        values[4].trim(), // Study Type
                        values[5].trim(), // Study Form
                        values[6].trim()  // Study Group Subject
                    );
                    csvData.add(data);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Error reading CSV file", e);
        }
    }

}
