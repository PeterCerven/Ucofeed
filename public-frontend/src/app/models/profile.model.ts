export interface ProfileData {
  universityId?: number;
  facultyId?: number;
  studyProgramId?: number;
  language: string;
  educationLevel: string;
  status: string;
  studyFormat: string;
}

export interface SelectOption {
  value: string;
  label: string;
}

export const LANGUAGES: SelectOption[] = [
  { value: 'sk', label: 'Slovak' },
  { value: 'en', label: 'English' }
];

export const DEGREE_LEVELS: SelectOption[] = [
  { value: '1', label: 'Bachelor\'s Degree' },
  { value: '2', label: 'Master\'s Degree' },
  { value: '3', label: 'Doctoral / PhD. Study' }
];

export const STATUSES: SelectOption[] = [
  { value: 'enrolled', label: 'Enrolled' },
  { value: 'onhold', label: 'On Hold' },
  { value: 'completed', label: 'Completed' },
  { value: 'droppedout', label: 'Dropped Out' }
];

export const STUDY_FORMATS: SelectOption[] = [
  { value: 'onsite', label: 'On-site study' },
  { value: 'external', label: 'Distance learning' }
];
