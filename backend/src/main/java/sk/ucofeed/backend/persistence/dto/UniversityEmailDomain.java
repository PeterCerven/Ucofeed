package sk.ucofeed.backend.persistence.dto;

import lombok.Getter;

@Getter
public enum UniversityEmailDomain {
    TUKE("tuke.sk", "Technická univerzita v Košiciach"),
    UNIZA("uniza.sk", "Žilinská univerzita v Žiline"),
    UK("uniba.sk", "Univerzita Komenského v Bratislave"),
    EUBA("euba.sk", "Ekonomická univerzita v Bratislave"),
    STU("stuba.sk", "Slovenská technická univerzita v Bratislave"),
    UPJS("upjs.sk", "Univerzita Pavla Jozefa Šafárika v Košiciach"),
    ;

    private final String domain;
    private final String universityName;

    UniversityEmailDomain(String domain, String universityName) {
        this.domain = domain;
        this.universityName = universityName;
    }

    public static String getDomainByUniversityName(String universityName) {
        for (UniversityEmailDomain ued : values()) {
            if (ued.universityName.equalsIgnoreCase(universityName)) {
                return ued.domain;
            }
        }
        throw new IllegalArgumentException("Unknown university name: " + universityName);
    }

}
