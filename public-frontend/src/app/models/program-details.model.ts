export interface ProgramDetailsModel {
  id: number;
  name: string;
  description: string;
  facultyName: string;
  universityName: string;
  averageRating: number;
  totalReviews: number;
  ratingDistribution: { [key: number]: number }; // rating (1-10) -> count
  tags: {
    degreeLevel?: string;
    studyForm?: string;
    studyType?: string;
  };
}