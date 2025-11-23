package sk.ucofeed.backend.persistence.dto;

import lombok.Getter;

@Getter
public enum SelectedUniversities {
    STU("Slovenská technická univerzita v Bratislave"),
    UK("Univerzita Komenského v Bratislave"),
    UNIZA("Žilinská univerzita v Žiline"),
    EUBA("Ekonomická univerzita v Bratislave"),
    TUKE("Technická univerzita v Košiciach"),
    UPJS("Univerzita Pavla Jozefa Šafárika v Košiciach"),
    ;

    private final String fullName;

    SelectedUniversities(String fullName) {
        this.fullName = fullName;
    }

}
