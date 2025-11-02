package sk.ucofeed.backend.service;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import sk.ucofeed.backend.persistence.dto.UniversityFileData;
import sk.ucofeed.backend.persistence.model.Faculty;
import sk.ucofeed.backend.persistence.model.StudyProgram;
import sk.ucofeed.backend.persistence.model.University;
import sk.ucofeed.backend.persistence.repository.FacultyRepository;
import sk.ucofeed.backend.persistence.repository.StudyProgramRepository;
import sk.ucofeed.backend.persistence.repository.UniversityRepository;

import org.apache.commons.io.FilenameUtils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
                    .orElseGet(() -> studyProgramRepository.save(new StudyProgram(data.programName(), "A Plug", faculty)));
            // TODO when orm is ready save the data
        }
    }

    @Override
    public List<UniversityFileData> parseFile(MultipartFile file) {
        String fileExtension = FilenameUtils.getExtension(file.getOriginalFilename());
        return switch (fileExtension) {
            case "csv" -> parseCSVFile(file);
            case "xlsx" -> parseExcelFile(file);
            case null, default -> throw new IllegalArgumentException("Unsupported file format: " + fileExtension);
        };
    }

    private List<UniversityFileData> parseCSVFile(MultipartFile file) {
        try (InputStreamReader reader = new InputStreamReader(file.getInputStream())) {
            CSVFormat format = CSVFormat.DEFAULT.builder().setHeader().setSkipHeaderRecord(true).build();
            CSVParser parser = format.parse(reader);

            List<UniversityFileData> result = new ArrayList<>();
            for (CSVRecord record : parser) {
                if (record.size() >= 12) {
                    UniversityFileData data = new UniversityFileData(
                            record.get(0),  // Kôd programu
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
            return transformData(result);
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse CSV file", e);
        }
    }


    private List<UniversityFileData> parseExcelFile(MultipartFile
                                                            file) {
        try (InputStream inputStream = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(inputStream)) {

            Sheet sheet = workbook.getSheetAt(0);
            List<UniversityFileData> result = new ArrayList<>();

            // Skip header row
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row != null && row.getLastCellNum() >= 12) {
                    UniversityFileData data = new UniversityFileData(
                            getCellValueAsString(row.getCell(0)), // Kôd programu
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
            return transformData(result);
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse Excel file", e);
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf((long)
                    cell.getNumericCellValue());
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            default -> "";
        };
    }

    private List<UniversityFileData> transformData(List<UniversityFileData> data) {
        Map<String, List<UniversityFileData>> groupedByProgramme = data.stream()
                .collect(Collectors.groupingBy(UniversityFileData::programmeName));

        return groupedByProgramme.entrySet().stream()
                .map(entry -> {
                    List<UniversityFileData> programmeGroup = entry.getValue();

                    String combinedProgrammeCodes = programmeGroup.stream()
                            .map(UniversityFileData::programmeCode)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedAcademyTitles = programmeGroup.stream()
                            .map(UniversityFileData::academyTitle)
                            .map(this::extractAcademicTitleAbbreviation)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedStudyForms = programmeGroup.stream()
                            .map(UniversityFileData::studyForm)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedUniversityNames = programmeGroup.stream()
                            .map(UniversityFileData::universityName)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedFacultyNames = programmeGroup.stream()
                            .map(UniversityFileData::facultyName)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedStudyFields = programmeGroup.stream()
                            .map(UniversityFileData::studyField)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    String combinedLanguages = programmeGroup.stream()
                            .map(UniversityFileData::language)
                            .distinct()
                            .collect(Collectors.joining(", "));

                    return new UniversityFileData(
                            combinedProgrammeCodes,
                            entry.getKey(), // programmeName
                            combinedAcademyTitles,
                            combinedStudyForms,
                            combinedUniversityNames,
                            combinedFacultyNames,
                            combinedStudyFields,
                            combinedLanguages
                    );
                })
                .collect(Collectors.toList());
    }

    private String extractAcademicTitleAbbreviation(String fullTitle) {
        if (fullTitle == null || fullTitle.isEmpty()) {
            return fullTitle;
        }
        return fullTitle.replaceAll(".+,\\s*(.+)", "$1");
    }


}
