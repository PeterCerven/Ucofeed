export interface ReviewModel {
  id: number;
  studyProgramId: number;
  studyProgramName?: string;
  studyProgramVariantId: number;

  // Variant tags from backend
  language?: string; // Instruction language
  studyForm?: string; // Study form (e.g., "denná")
  title?: string; // Academic degree (e.g., "Bc.")

  rating: number; // Single rating 1-10
  comment: string;
  anonymous: boolean;
  createdAt: string;
  updatedAt: string;
  isEdited?: boolean; // Optional, will be calculated from timestamps
  commentsCount?: number;

  user_id?: string;
  user_email?: string;
  user_full_name?: string;

}

export interface CreateReviewDto {
  studyProgramId: number;
  comment: string;
  rating: number; // 1-10
  anonymous?: boolean;
}

export interface UpdateReviewDto {
  rating: number; // 1-10
  comment: string;
  anonymous: boolean;
}

export interface ReviewFilterOptions {
  sortBy: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited';
}
