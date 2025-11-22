export interface ProgramModel {
  id: number;
  name: string;
  code?: string;
  image?: string;
  review?: number;
  description?: string;
  entityType?: 'program';
}
