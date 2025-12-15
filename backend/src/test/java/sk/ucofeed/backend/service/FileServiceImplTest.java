package sk.ucofeed.backend.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.UniversityFileDataDTO;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramVariantRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class FileServiceImplTest {

    @Mock
    private FacultyRepository facultyRepository;

    @Mock
    private UniversityRepository universityRepository;

    @Mock
    private StudyProgramRepository studyProgramRepository;

    @Mock
    private StudyProgramVariantRepository studyProgramVariantRepository;

    @InjectMocks
    private FileServiceImpl fileService;

    private University testUniversity;
    private Faculty testFaculty;
    private StudyProgram testStudyProgram;
    private StudyProgramVariant testVariant;

    @BeforeEach
    void setUp() {
        testUniversity = new University("Univerzita Komenského v Bratislave", "uniba.sk");
        testFaculty = new Faculty("Fakulta matematiky, fyziky a informatiky", testUniversity);
        testStudyProgram = new StudyProgram("Informatika", testFaculty, "Informatika");
        testStudyProgram.setId(1L);

        testVariant = new StudyProgramVariant("Slovak", sk.ucofeed.backend.persistence.dto.StudyForm.FULL_TIME, "Bc.");
        testVariant.setId(1L);
    }

    @Test
    void saveStudyProgramFromFile_WhenUniversityDoesNotExist_ShouldCreateUniversity() {
        UniversityFileDataDTO fileData = new UniversityFileDataDTO(
            "Informatika",
            "Bc.",
            "Denná",
            "Univerzita Komenského v Bratislave",
            "Fakulta matematiky, fyziky a informatiky",
            "Informatika",
            "slovenský jazyk"
        );

        when(universityRepository.findByName(fileData.universityName())).thenReturn(Optional.empty());
        when(universityRepository.save(any(University.class))).thenReturn(testUniversity);
        when(facultyRepository.findByNameAndUniversity(any(), any())).thenReturn(Optional.empty());
        when(facultyRepository.save(any(Faculty.class))).thenReturn(testFaculty);
        when(studyProgramVariantRepository.findByLanguageAndStudyFormAndTitle(any(), any(), any()))
            .thenReturn(Optional.empty());
        when(studyProgramVariantRepository.save(any(StudyProgramVariant.class))).thenReturn(testVariant);
        when(studyProgramRepository.findByNameAndFaculty(any(), any())).thenReturn(Optional.empty());
        when(studyProgramRepository.save(any(StudyProgram.class))).thenReturn(testStudyProgram);

        fileService.saveStudyProgramFromFile(List.of(fileData));

        verify(universityRepository, times(1)).save(any(University.class));
        verify(facultyRepository, times(1)).save(any(Faculty.class));
        verify(studyProgramRepository, times(1)).save(any(StudyProgram.class));
    }

    @Test
    void saveStudyProgramFromFile_WhenUniversityExists_ShouldReuseUniversity() {
        UniversityFileDataDTO fileData = new UniversityFileDataDTO(
            "Informatika",
            "Bc.",
            "Denná",
            "Univerzita Komenského v Bratislave",
            "Fakulta matematiky, fyziky a informatiky",
            "Informatika",
            "slovenský jazyk"
        );

        when(universityRepository.findByName(fileData.universityName())).thenReturn(Optional.of(testUniversity));
        when(facultyRepository.findByNameAndUniversity(any(), any())).thenReturn(Optional.empty());
        when(facultyRepository.save(any(Faculty.class))).thenReturn(testFaculty);
        when(studyProgramVariantRepository.findByLanguageAndStudyFormAndTitle(any(), any(), any()))
            .thenReturn(Optional.empty());
        when(studyProgramVariantRepository.save(any(StudyProgramVariant.class))).thenReturn(testVariant);
        when(studyProgramRepository.findByNameAndFaculty(any(), any())).thenReturn(Optional.empty());
        when(studyProgramRepository.save(any(StudyProgram.class))).thenReturn(testStudyProgram);

        fileService.saveStudyProgramFromFile(List.of(fileData));

        verify(universityRepository, never()).save(any(University.class));
        verify(studyProgramRepository, times(1)).save(any(StudyProgram.class));
    }

    @Test
    void saveStudyProgramFromFile_WhenFacultyNameEmpty_ShouldSkipEntry() {
        UniversityFileDataDTO fileData = new UniversityFileDataDTO(
            "Informatika",
            "Bc.",
            "Denná",
            "Univerzita Komenského v Bratislave",
            "",
            "Informatika",
            "slovenský jazyk"
        );

        when(universityRepository.findByName(fileData.universityName())).thenReturn(Optional.of(testUniversity));

        fileService.saveStudyProgramFromFile(List.of(fileData));

        verify(facultyRepository, never()).save(any());
        verify(studyProgramRepository, never()).save(any());
    }

    @Test
    void saveStudyProgramFromFile_WhenStudyProgramExists_ShouldAddVariant() {
        testStudyProgram.setStudyProgramVariants(new ArrayList<>());

        UniversityFileDataDTO fileData = new UniversityFileDataDTO(
            "Informatika",
            "Ing.",
            "Denná",
            "Univerzita Komenského v Bratislave",
            "Fakulta matematiky, fyziky a informatiky",
            "Informatika",
            "slovenský jazyk"
        );

        when(universityRepository.findByName(fileData.universityName())).thenReturn(Optional.of(testUniversity));
        when(facultyRepository.findByNameAndUniversity(any(), any())).thenReturn(Optional.of(testFaculty));
        when(studyProgramVariantRepository.findByLanguageAndStudyFormAndTitle(any(), any(), any()))
            .thenReturn(Optional.of(testVariant));
        when(studyProgramRepository.findByNameAndFaculty(any(), any()))
            .thenReturn(Optional.of(testStudyProgram));
        when(studyProgramRepository.save(any(StudyProgram.class))).thenReturn(testStudyProgram);

        fileService.saveStudyProgramFromFile(List.of(fileData));

        verify(studyProgramRepository, times(1)).save(testStudyProgram);
        assertEquals(1, testStudyProgram.getStudyProgramVariants().size());
    }

    @Test
    void parseFile_WhenUnsupportedFormat_ShouldThrowException() {
        MultipartFile file = new MockMultipartFile(
            "file",
            "test.txt",
            "text/plain",
            "test content".getBytes()
        );

        assertThrows(IllegalArgumentException.class, () -> fileService.parseFile(file));
    }

    @Test
    void parseFile_WhenCSVFormat_ShouldParseSuccessfully() {
        String csvContent = """
            Kôd programu,Názov programu,Stupeň štúdia,Udelený akademický titul,Forma štúdia,Štandardná dĺžka štúdia,Vysoká škola,Fakulta,Miesto štúdia,Študijný odbor,Študijný odbor 2,Jazyk poskytovania
            1234,Informatika,bakalársky,bakalár (Bc.),denná,3,Univerzita Komenského v Bratislave,Fakulta matematiky fyziky a informatiky,Bratislava,Informatika,Informatika,slovenský jazyk
            """;

        MultipartFile file = new MockMultipartFile(
            "file",
            "test.csv",
            "text/csv",
            csvContent.getBytes()
        );

        List<UniversityFileDataDTO> result = fileService.parseFile(file);

        assertNotNull(result);
    }

    @Test
    void getAllUniversityData_ShouldReturnAllData() {
        testStudyProgram.setStudyProgramVariants(List.of(testVariant));
        testFaculty.setStudyPrograms(List.of(testStudyProgram));
        testUniversity.setFaculties(List.of(testFaculty));

        when(universityRepository.findAll()).thenReturn(List.of(testUniversity));

        List<UniversityFileDataDTO> result = fileService.getAllUniversityData();

        assertNotNull(result);
        verify(universityRepository, times(1)).findAll();
    }

    @Test
    void getAllUniversityData_WhenNoData_ShouldReturnEmptyList() {
        when(universityRepository.findAll()).thenReturn(List.of());

        List<UniversityFileDataDTO> result = fileService.getAllUniversityData();

        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(universityRepository, times(1)).findAll();
    }
}