import { TestBed } from '@angular/core/testing';
import { HttpTestingController } from '@angular/common/http/testing';
import { NotificationService } from './notification.service';
import { DashboardMessageDTO, Notification } from '@models/notification.model';
import { environment } from '@env/environment.production';
import { globalTestProviders } from '../../test-setup';

describe('NotificationService', () => {
  let service: NotificationService;
  let httpMock: HttpTestingController;
  const apiUrl = `${environment.apiUrl}/private/dashboard`;

  const mockDashboardMessageDTO: DashboardMessageDTO = {
    id: 1,
    message: JSON.stringify({
      event_type: 'ReviewCreated',
      study_program: {
        universityName: 'Test University',
        facultyName: 'Test Faculty',
        programName: 'Computer Science'
      },
      program_id: 123,
      user_id: 'test-user-uuid-123'
    }),
    created_at: '2025-12-15T10:00:00Z'
  };

  const expectedNotification: Notification = {
    id: 1,
    userId: 'test-user-uuid-123',
    eventType: 'ReviewCreated',
    studyProgram: {
      universityName: 'Test University',
      facultyName: 'Test Faculty',
      programName: 'Computer Science'
    },
    programId: 123,
    createdAt: new Date('2025-12-15T10:00:00Z')
  };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [...globalTestProviders]
    });
    service = TestBed.inject(NotificationService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getNotifications', () => {
    it('should retrieve and parse notifications from backend', () => {
      const mockDTOs = [mockDashboardMessageDTO];

      service.getNotifications().subscribe(notifications => {
        expect(notifications.length).toBe(1);
        expect(notifications[0]).toEqual(expectedNotification);
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      expect(req.request.method).toBe('GET');
      req.flush(mockDTOs);
    });

    it('should handle multiple notifications', () => {
      const mockDTOs: DashboardMessageDTO[] = [
        mockDashboardMessageDTO,
        {
          id: 2,
          message: JSON.stringify({
            event_type: 'ReviewCreated',
            study_program: {
              universityName: 'Another University',
              facultyName: 'Another Faculty',
              programName: 'Mathematics'
            },
            program_id: 456,
            user_id: 'another-user-uuid'
          }),
          created_at: '2025-12-15T11:00:00Z'
        }
      ];

      service.getNotifications().subscribe(notifications => {
        expect(notifications.length).toBe(2);
        expect(notifications[0].studyProgram.programName).toBe('Computer Science');
        expect(notifications[1].studyProgram.programName).toBe('Mathematics');
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush(mockDTOs);
    });

    it('should handle empty notifications array', () => {
      service.getNotifications().subscribe(notifications => {
        expect(notifications).toEqual([]);
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush([]);
    });

    it('should handle malformed JSON in message field gracefully', () => {
      const malformedDTO: DashboardMessageDTO = {
        id: 3,
        message: 'invalid-json',
        created_at: '2025-12-15T12:00:00Z'
      };

      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});

      service.getNotifications().subscribe(notifications => {
        expect(notifications.length).toBe(1);
        expect(notifications[0].userId).toBe('unknown');
        expect(notifications[0].studyProgram.universityName).toBe('Unknown');
        expect(consoleSpy).toHaveBeenCalled();
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush([malformedDTO]);

      consoleSpy.mockRestore();
    });

    it('should handle missing fields in parsed JSON gracefully', () => {
      const incompleteDTO: DashboardMessageDTO = {
        id: 4,
        message: JSON.stringify({
          event_type: 'ReviewCreated'
          // Missing other required fields
        }),
        created_at: '2025-12-15T13:00:00Z'
      };

      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});

      service.getNotifications().subscribe(notifications => {
        expect(notifications.length).toBe(1);
        expect(notifications[0].id).toBe(4);
        expect(notifications[0].userId).toBe('unknown');
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush([incompleteDTO]);

      consoleSpy.mockRestore();
    });

    it('should handle HTTP error', () => {
      service.getNotifications().subscribe({
        next: () => expect.fail('should have failed with error'),
        error: (error) => {
          expect(error.status).toBe(500);
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush('Server error', { status: 500, statusText: 'Internal Server Error' });
    });
  });

  describe('deleteNotification', () => {
    it('should send delete request with correct notification id', () => {
      const notificationId = 1;

      service.deleteNotification(notificationId).subscribe(response => {
        expect(response).toBeNull();
      });

      const req = httpMock.expectOne(`${apiUrl}/message/${notificationId}`);
      expect(req.request.method).toBe('DELETE');
      req.flush(null);
    });

    it('should handle deletion of different notification ids', () => {
      const notificationId = 999;

      service.deleteNotification(notificationId).subscribe();

      const req = httpMock.expectOne(`${apiUrl}/message/${notificationId}`);
      expect(req.request.method).toBe('DELETE');
      expect(req.request.url).toContain('999');
      req.flush(null);
    });

    it('should handle error when deleting notification', () => {
      const notificationId = 1;

      service.deleteNotification(notificationId).subscribe({
        next: () => expect.fail('should have failed with error'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/message/${notificationId}`);
      req.flush('Not found', { status: 404, statusText: 'Not Found' });
    });

    it('should handle network error during deletion', () => {
      const notificationId = 1;
      const errorEvent = new ProgressEvent('error');

      service.deleteNotification(notificationId).subscribe({
        next: () => expect.fail('should have failed with network error'),
        error: (error) => {
          expect(error.error).toBeTruthy();
        }
      });

      const req = httpMock.expectOne(`${apiUrl}/message/${notificationId}`);
      req.error(errorEvent);
    });
  });

  describe('parseNotification (integration)', () => {
    it('should correctly parse date from ISO string', () => {
      const dto: DashboardMessageDTO = {
        ...mockDashboardMessageDTO,
        created_at: '2025-12-15T15:30:45.123Z'
      };

      service.getNotifications().subscribe(notifications => {
        const date = notifications[0].createdAt;
        expect(date.toISOString()).toBe('2025-12-15T15:30:45.123Z');
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush([dto]);
    });

    it('should preserve all study program details', () => {
      const dto: DashboardMessageDTO = {
        id: 5,
        message: JSON.stringify({
          event_type: 'ReviewCreated',
          study_program: {
            universityName: 'Slovak University of Technology',
            facultyName: 'Faculty of Electrical Engineering and Information Technology',
            programName: 'Applied Informatics'
          },
          program_id: 789,
          user_id: 'complex-uuid-123-456'
        }),
        created_at: '2025-12-15T16:00:00Z'
      };

      service.getNotifications().subscribe(notifications => {
        const notification = notifications[0];
        expect(notification.studyProgram.universityName).toBe('Slovak University of Technology');
        expect(notification.studyProgram.facultyName).toBe('Faculty of Electrical Engineering and Information Technology');
        expect(notification.studyProgram.programName).toBe('Applied Informatics');
        expect(notification.programId).toBe(789);
        expect(notification.userId).toBe('complex-uuid-123-456');
      });

      const req = httpMock.expectOne(`${apiUrl}/message`);
      req.flush([dto]);
    });
  });
});
