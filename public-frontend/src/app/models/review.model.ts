export interface ReviewModel {
  id: number;
  userName: string;
  studyProgramId: number;
  studyProgramName?: string;
  studyProgramVariantId: number;
  semester?: number; // Semester number (1-8 or similar)
  rating: number; // Single rating 1-10
  comment: string;
  anonymous: boolean;
  createdAt: string;
  updatedAt: string;
  isEdited: boolean;
  commentsCount: number;
}

export interface CreateReviewDto {
  studyProgramId: number;
  studyProgramVariantId?: number; // Auto-selected if not provided
  semester?: number;
  comment: string;
  rating: number; // 1-10
  anonymous?: boolean;
}

export interface ReviewFilterOptions {
  sortBy: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited';
}