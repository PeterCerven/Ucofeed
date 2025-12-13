export interface ProgramModel {
  id: number;
  name: string;
  image?: string;
  rating?: number;
  description?: string;
  entityType?: 'program';
}
