// Simplified model matching backend StudyProgram entity
export interface StudyProgramDetailsModel {
  id: number;
  name: string;
  study_field: string;
  faculty_id?: number;
  faculty_name?: string;
  university_id?: number;
  university_name?: string;
}

// Full model with calculated stats and tags (used by frontend)
export interface ProgramDetailsModel {
  id: number;
  name: string;
  description: string;
  faculty_id?: number;
  faculty_name: string;
  university_id?: number;
  university_name: string;
  averageRating: number;
  totalReviews: number;
  ratingDistribution: { [key: number]: number }; // rating (1-10) -> count

  // Study program variant tags (from backend StudyProgramVariant)
  tags: {
    title?: string; // e.g., "Bc", "Mgr", "Ing", "MUDr", "PhD"
    languageGroup?: string; // e.g., "Slovak", "English", "Slovak/English"
    studyFormat?: string; // e.g., "Full-time", "Part-time", "External"
    studyDegree?: number; // e.g., 1 (Bachelor), 2 (Master), 3 (Doctoral)
    studyDuration?: number; // Duration in years (e.g., 3, 2, 4)
  };
}
