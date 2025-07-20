package sk.ucofeed.backend.persistence.dto;


public record UniversityFileData(
    String programName,
    String university,
    String faculty,
    String educationLevel,
    String studyType,
    String studyForm,
    String studyGroupSubjects
) {

}
