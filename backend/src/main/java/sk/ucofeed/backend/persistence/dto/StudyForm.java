package sk.ucofeed.backend.persistence.dto;

import lombok.Getter;

@Getter
public enum StudyForm {
    FULL_TIME("denná"),
    PART_TIME("externá");

    private final String displayName;

    StudyForm(String displayName) {
        this.displayName = displayName;
    }

    public static StudyForm fromDisplayName(String displayName) {
        if (displayName == null || displayName.isEmpty()) {
            throw new IllegalArgumentException("Study form display name cannot be null or empty");
        }

        String normalized = displayName.trim().toLowerCase();
        for (StudyForm form : values()) {
            if (form.displayName.equals(normalized)) {
                return form;
            }
        }

        throw new IllegalArgumentException("Unknown study form: " + displayName);
    }

}
