export type Semester = 'WINTER' | 'SUMMER' | 'FULL_YEAR';

export interface ReviewModel {
  id: number;
  userName: string;
  academicYear: string;
  semester: Semester;
  overallRating: number;
  teachingQualityRating: number;
  difficultyRating: number;
  resourcesRating: number;
  careerProspectsRating: number;
  reviewText: string;
  createdAt: string;
  updatedAt: string;
  isEdited: boolean;
  commentsCount: number;
}

export interface ReviewFilterOptions {
  sortBy: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited';
}

export interface CreateReviewDto {
  studyProgramId: number;
  studyProgramVariantId: number;
  comment: string;
  rating: number;
  anonymous: boolean;
}