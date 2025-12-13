export interface FacultyModel {
  id: number;
  name: string;
  image?: string;
  rating?: number;
  description?: string;
  entityType?: 'faculty';
  university_id?: number;
  university_name?: string;
}
