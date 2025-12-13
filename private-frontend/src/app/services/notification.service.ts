import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '@env/environment.production';
import { DashboardMessageDTO, ReviewCreatedPayload, Notification } from '@models/notification.model';

@Injectable({
  providedIn: 'root',
})
export class NotificationService {
  private readonly apiUrl = `${environment.apiUrl}/private/dashboard`;
  private readonly http = inject(HttpClient);

  /**
   * Get all dashboard notifications from backend
   */
  getNotifications(): Observable<Notification[]> {
    return this.http.get<DashboardMessageDTO[]>(`${this.apiUrl}/message`).pipe(
      map(dtos => dtos.map(dto => this.parseNotification(dto)))
    );
  }

  /**
   * Delete notification by ID
   */
  deleteNotification(notificationId: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/message/${notificationId}`);
  }

  /**
   * Parse backend DashboardMessageDTO to frontend Notification model
   */
  private parseNotification(dto: DashboardMessageDTO): Notification {
    try {
      // Parse the JSON string in the message field
      const payload: ReviewCreatedPayload = JSON.parse(dto.message);

      return {
        id: dto.id,
        userId: payload.user_id,
        eventType: payload.event_type,
        studyProgram: {
          universityName: payload.study_program.universityName,
          facultyName: payload.study_program.facultyName,
          programName: payload.study_program.programName,
        },
        programId: payload.program_id,
        createdAt: new Date(dto.created_at),
      };
    } catch (error) {
      console.error('Failed to parse notification message:', dto.message, error);
      // Return a fallback notification if parsing fails
      return {
        id: dto.id,
        userId: 'unknown',
        eventType: 'ReviewCreated',
        studyProgram: {
          universityName: 'Unknown',
          facultyName: 'Unknown',
          programName: 'Unknown',
        },
        programId: 0,
        createdAt: new Date(dto.created_at),
      };
    }
  }
}