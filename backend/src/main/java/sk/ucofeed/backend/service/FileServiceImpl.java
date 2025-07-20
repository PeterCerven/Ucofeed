package sk.ucofeed.backend.service;

import org.springframework.stereotype.Service;
import sk.ucofeed.backend.persistence.dto.UniversityFileData;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.University;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import java.util.List;

@Service
public class FileServiceImpl implements FileService {

    private final FacultyRepository facultyRepository;
    private final UniversityRepository universityRepository;
    private final StudyProgramRepository studyProgramRepository;

    public FileServiceImpl(FacultyRepository facultyRepository, UniversityRepository universityRepository, StudyProgramRepository studyProgramRepository) {
        this.facultyRepository = facultyRepository;
        this.universityRepository = universityRepository;
        this.studyProgramRepository = studyProgramRepository;
    }

    @Override
    public void saveStudyProgramFromFile(List<UniversityFileData> fileData) {
        for (UniversityFileData data : fileData) {
            // Check if the university exists, if not, create it
            University university = universityRepository.findByName(data.university())
                    .orElseGet(() -> universityRepository.save(new University(data.university())));

            // Check if the faculty exists, if not, create it
            Faculty faculty = facultyRepository.findByNameAndUniversity(data.faculty(), university)
                    .orElseGet(() -> facultyRepository.save(new Faculty(data.faculty(), university)));

            // Check if the study program already exists, if not, create it
            StudyProgram studyProgram = studyProgramRepository.findByNameAndFaculty(data.programName(), faculty)
                    .orElseGet(() -> studyProgramRepository.save(new StudyProgram(data.programName(), faculty)));
        }
    }

}
