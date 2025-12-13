// Backend API response structure
export interface DashboardMessageDTO {
  id: number;
  message: string;        // JSON string that needs parsing
  created_at: string;     // ISO datetime string
}

// Parsed message payload for ReviewCreated events
export interface ReviewCreatedPayload {
  event_type: 'ReviewCreated';
  study_program: {
    universityName: string;
    facultyName: string;
    programName: string;
  };
  program_id: number;
  user_id: string;        // UUID
}

// Frontend notification model (parsed and enriched)
export interface Notification {
  id: number;
  userId: string;         // UUID from message payload
  eventType: 'ReviewCreated';
  studyProgram: {
    universityName: string;
    facultyName: string;
    programName: string;
  };
  programId: number;
  createdAt: Date;
}