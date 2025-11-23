package sk.ucofeed.backend.service;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.StudyForm;
import sk.ucofeed.backend.persistence.dto.UniversityFileDataDTO;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.StudyProgramVariant;
import sk.ucofeed.backend.persistence.model.University;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramVariantRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import org.apache.commons.io.FilenameUtils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static sk.ucofeed.backend.persistence.dto.SelectedUniversities.*;

@Service
public class FileServiceImpl implements FileService {

    private static final Logger LOG = LoggerFactory.getLogger(FileServiceImpl.class);

    private final FacultyRepository facultyRepository;
    private final UniversityRepository universityRepository;
    private final StudyProgramRepository studyProgramRepository;
    private final StudyProgramVariantRepository studyProgramVariantRepository;

    public FileServiceImpl(FacultyRepository facultyRepository, UniversityRepository universityRepository, StudyProgramRepository studyProgramRepository, StudyProgramVariantRepository studyProgramVariantRepository) {
        this.facultyRepository = facultyRepository;
        this.universityRepository = universityRepository;
        this.studyProgramRepository = studyProgramRepository;
        this.studyProgramVariantRepository = studyProgramVariantRepository;
    }

    @Override
    public void saveStudyProgramFromFile(List<UniversityFileDataDTO> fileData) {
        for (UniversityFileDataDTO data : fileData) {
            // Check if the university exists, if not, create it
            University university = universityRepository.findByName(data.universityName()).orElseGet(() -> universityRepository.save(new University(data.universityName())));

            if (data.facultyName().trim().isEmpty()) {
                LOG.warn("Skipping entry with empty faculty name for university: {}", data.universityName());
                continue;
            }

            // Check if the faculty exists, if not, create it
            Faculty faculty = facultyRepository.findByNameAndUniversity(data.facultyName(), university).orElseGet(() -> facultyRepository.save(new Faculty(data.facultyName(), university)));


            // Get or create the variant (reuse existing variants to prevent duplicates)
            String language = data.language();
            StudyForm studyForm = StudyForm.fromDisplayName(data.studyForm());
            String title = data.academyTitle();

            StudyProgramVariant variant = studyProgramVariantRepository.findByLanguageAndStudyFormAndTitle(language, studyForm, title).orElseGet(() -> studyProgramVariantRepository.save(new StudyProgramVariant(language, studyForm, title)));

            // Check if the study program already exists, if not, create it
            Optional<StudyProgram> studyProgram = studyProgramRepository.findByNameAndFaculty(data.programmeName(), faculty);
            if (studyProgram.isEmpty()) {
                StudyProgram newProgram = new StudyProgram(data.programmeName(), faculty, data.studyField());
                newProgram.getStudyProgramVariants().add(variant);
                studyProgramRepository.save(newProgram);
            } else {
                StudyProgram existingProgram = studyProgram.get();
                // Check if the variant is already linked to this study program
                boolean variantLinked = existingProgram.getStudyProgramVariants().stream().anyMatch(v -> v.getId().equals(variant.getId()));
                if (!variantLinked) {
                    existingProgram.getStudyProgramVariants().add(variant);
                    studyProgramRepository.save(existingProgram);
                }
            }
        }
    }


    @Override
    public List<UniversityFileDataDTO> parseFile(MultipartFile file) {
        String fileExtension = FilenameUtils.getExtension(file.getOriginalFilename());
        return switch (fileExtension) {
            case "csv" -> parseCSVFile(file);
            case "xlsx" -> parseExcelFile(file);
            case null, default -> throw new IllegalArgumentException("Unsupported file format: " + fileExtension);
        };
    }

    @Override
    public List<UniversityFileDataDTO> getAllUniversityData() {
        List<University> universities = universityRepository.findAll();
        List<UniversityFileDataDTO> result = new ArrayList<>();

        for (University university : universities) {
            for (Faculty faculty : university.getFaculties()) {
                for (StudyProgram studyProgram : faculty.getStudyPrograms()) {
                    for (StudyProgramVariant variant : studyProgram.getStudyProgramVariants()) {
                        UniversityFileDataDTO data = new UniversityFileDataDTO(studyProgram.getName(), variant.getTitle(), variant.getStudyForm().getDisplayName(), university.getName(), faculty.getName(), studyProgram.getStudyField(), variant.getLanguage());
                        result.add(data);
                    }
                }
            }
        }
        return result;
    }

    private List<UniversityFileDataDTO> parseCSVFile(MultipartFile file) {
        try (InputStreamReader reader = new InputStreamReader(file.getInputStream())) {
            CSVFormat format = CSVFormat.DEFAULT.builder().setHeader().setSkipHeaderRecord(true).build();
            CSVParser parser = format.parse(reader);

            List<UniversityFileDataDTO> result = new ArrayList<>();
            for (CSVRecord record : parser) {
                if (record.size() >= 12) {
                    UniversityFileDataDTO data = new UniversityFileDataDTO(
//                          record.get(0),  // Kôd programu
                            record.get(1),  // Názov programu
//                          record.get(2),  // Stupeň štúdia
                            record.get(3),  // Udelený akademický titul
                            record.get(4),  // Forma štúdia
//                          record.get(5),  // Štandardná dĺžka štúdia
                            record.get(6),  // Vysoká škola
                            record.get(7),  // Fakulta
//                          record.get(8),  // Miesto štúdia
                            record.get(9),  // Študijný odbor
//                          record.get(10), // Študijný odbor (2)
                            record.get(11)  // Jazyk poskytovania
                    );
                    result.add(data);
                }
            }
            return transformData(filterUniversities(result));
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse CSV file", e);
        }
    }


    private List<UniversityFileDataDTO> parseExcelFile(MultipartFile file) {
        try (InputStream inputStream = file.getInputStream(); Workbook workbook = new XSSFWorkbook(inputStream)) {

            Sheet sheet = workbook.getSheetAt(0);
            List<UniversityFileDataDTO> result = new ArrayList<>();

            // Skip header row
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row != null && row.getLastCellNum() >= 12) {
                    UniversityFileDataDTO data = new UniversityFileDataDTO(
//                          getCellValueAsString(row.getCell(0)), // Kôd programu
                            getCellValueAsString(row.getCell(1)), // Názov programu
//                          getCellValueAsString(row.getCell(2)),    // Stupeň štúdia
                            getCellValueAsString(row.getCell(3)), // Udelený akademický titul
                            getCellValueAsString(row.getCell(4)), // Forma štúdia
//                          getCellValueAsString(row.getCell(5)),    // Štandardná dĺžka štúdia
                            getCellValueAsString(row.getCell(6)), // Vysoká škola
                            getCellValueAsString(row.getCell(7)), // Fakulta
//                          getCellValueAsString(row.getCell(8)),    // Miesto štúdia
                            getCellValueAsString(row.getCell(9)), // Študijný odbor
//                          getCellValueAsString(row.getCell(10)),   // Študijný odbor (2)
                            getCellValueAsString(row.getCell(11)) // Jazyk poskytovania
                    );
                    result.add(data);
                }
            }
            return transformData(filterUniversities(result));
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse Excel file", e);
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            default -> "";
        };
    }

    private List<UniversityFileDataDTO> transformData(List<UniversityFileDataDTO> data) {
        return data.stream().map(d -> new UniversityFileDataDTO(d.programmeName(), extractAcademicTitleAbbreviation(d.academyTitle()), d.studyForm(), d.universityName(), d.facultyName(), d.studyField(), d.language())).toList();
    }

    private List<UniversityFileDataDTO> filterUniversities(List<UniversityFileDataDTO> data) {
        return data.stream().filter(u -> u.universityName().trim().equals(UK.getFullName()) || u.universityName().trim().equals(STU.getFullName()) || u.universityName().trim().equals(UNIZA.getFullName()) || u.universityName().trim().equals(EUBA.getFullName()) || u.universityName().trim().equals(TUKE.getFullName()) || u.universityName().trim().equals(UPJS.getFullName())).toList();
    }

    private String extractAcademicTitleAbbreviation(String fullTitle) {
        if (fullTitle == null || fullTitle.isEmpty()) {
            return fullTitle;
        }
        return fullTitle.replaceAll(".+,\\s*(.+)", "$1");
    }


}
