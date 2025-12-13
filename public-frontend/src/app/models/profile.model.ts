export interface ProfileData {
  universityId?: number;
  facultyId?: number;
  studyProgramId: number;
  studyProgramVariantId: number;
  status: string;
}

export interface SelectOption {
  value: string;
  label: string;
}

export const STATUSES: SelectOption[] = [
  { value: 'ENROLLED', label: 'pages.profile.statuses.enrolled' },
  { value: 'ON_HOLD', label: 'pages.profile.statuses.onHold' },
  { value: 'COMPLETED', label: 'pages.profile.statuses.completed' },
  { value: 'DROPPED_OUT', label: 'pages.profile.statuses.droppedOut' }
];
