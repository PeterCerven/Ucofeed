export interface ProfileData {
  studyProgramId: number;
  studyProgramVariantId: number;
  status: string;
}

export interface SelectOption {
  value: string;
  label: string;
}

export const STATUSES: SelectOption[] = [
  { value: 'ENROLLED', label: 'Enrolled' },
  { value: 'ON_HOLD', label: 'On Hold' },
  { value: 'COMPLETED', label: 'Completed' },
  { value: 'DROPPED_OUT', label: 'Dropped Out' }
];
