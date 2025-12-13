export interface UniversityModel {
  id: number;
  name: string;
  image?: string;
  domain?: string;
  entityType?: 'university';
  rating?: number;     // 0-10
  description?: string;
}
