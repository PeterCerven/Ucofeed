package sk.ucofeed.backend.persistence.dto;


public record UniversityFileData(
    String programmeCode,
    String programmeName,
    String academyTitle,
    String studyForm,
    String universityName,
    String facultyName,
    String studyField,
    String language
) {

}
