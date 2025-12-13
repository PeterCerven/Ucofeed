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
  { value: 'ENROLLED', label: 'profileModel.statuses.enrolled' },
  { value: 'ON_HOLD', label: 'profileModel.statuses.onHold' },
  { value: 'COMPLETED', label: 'profileModel.statuses.completed' },
  { value: 'DROPPED_OUT', label: 'profileModel.statuses.droppedOut' }
];
