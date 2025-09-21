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
                if (record.size() >= 7) {
                    result.add(new UniversityFileData(
                            record.get(0), // programName
                            record.get(1), // university
                            record.get(2), // faculty
                            record.get(3), // educationLevel
                            record.get(4), // studyType
                            record.get(5), // studyForm
                            record.get(6)  // studyGroupSubjects
                    ));
                }
            }
            return result;
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
                if (row != null && row.getLastCellNum() >= 7) {
                    result.add(new UniversityFileData(
                            getCellValueAsString(row.getCell(0)), // programName
                            getCellValueAsString(row.getCell(1)), // university
                            getCellValueAsString(row.getCell(2)), // faculty
                            getCellValueAsString(row.getCell(3)), // educationLevel
                            getCellValueAsString(row.getCell(4)), // studyType
                            getCellValueAsString(row.getCell(5)), // studyForm
                            getCellValueAsString(row.getCell(6))  // studyGroupSubjects
                    ));
                }
            }
            return result;
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse Excel file",
                    e);
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


}
