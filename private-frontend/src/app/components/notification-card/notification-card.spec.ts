import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NotificationCardComponent } from './notification-card';
import { Notification } from '@models/notification.model';
import { globalTestProviders } from '../../../test-setup';

describe('NotificationCardComponent', () => {
  let component: NotificationCardComponent;
  let fixture: ComponentFixture<NotificationCardComponent>;

  const mockNotification: Notification = {
    id: 1,
    userId: 'test-user-id',
    eventType: 'ReviewCreated',
    studyProgram: {
      universityName: 'Test University',
      facultyName: 'Test Faculty',
      programName: 'Test Program'
    },
    programId: 123,
    createdAt: new Date('2025-12-15T10:00:00Z')
  };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NotificationCardComponent],
      providers: [...globalTestProviders]
    }).compileComponents();

    fixture = TestBed.createComponent(NotificationCardComponent);
    component = fixture.componentInstance;
    component.notification = mockNotification;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  describe('onCardClick', () => {
    it('should emit notification when card is clicked', () => {
      const emitSpy = vi.spyOn(component.notificationClicked, 'emit');

      component.onCardClick();

      expect(emitSpy).toHaveBeenCalledWith(mockNotification);
    });
  });

  describe('onDelete', () => {
    it('should emit notification id when delete is clicked', () => {
      const emitSpy = vi.spyOn(component.deleteClicked, 'emit');
      const mockEvent = new Event('click');
      const stopPropagationSpy = vi.spyOn(mockEvent, 'stopPropagation');

      component.onDelete(mockEvent);

      expect(stopPropagationSpy).toHaveBeenCalled();
      expect(emitSpy).toHaveBeenCalledWith(1);
    });
  });

  describe('getActionIcon', () => {
    it('should return rate_review icon', () => {
      expect(component.getActionIcon()).toBe('rate_review');
    });
  });

  describe('getActionText', () => {
    it('should return correct action text', () => {
      expect(component.getActionText()).toBe('created a review for');
    });
  });

  describe('getTimeAgo', () => {
    it('should return "Just now" for very recent notifications', () => {
      component.notification = {
        ...mockNotification,
        createdAt: new Date()
      };

      expect(component.getTimeAgo()).toBe('Just now');
    });

    it('should return minutes ago for notifications less than an hour old', () => {
      const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: fiveMinutesAgo
      };

      const result = component.getTimeAgo();
      expect(result).toContain('minutes ago');
    });

    it('should return "1 minute ago" for singular minute', () => {
      const oneMinuteAgo = new Date(Date.now() - 61 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: oneMinuteAgo
      };

      const result = component.getTimeAgo();
      expect(result).toBe('1 minute ago');
    });

    it('should return hours ago for notifications less than a day old', () => {
      const threeHoursAgo = new Date(Date.now() - 3 * 60 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: threeHoursAgo
      };

      const result = component.getTimeAgo();
      expect(result).toContain('hours ago');
    });

    it('should return "1 hour ago" for singular hour', () => {
      const oneHourAgo = new Date(Date.now() - 61 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: oneHourAgo
      };

      const result = component.getTimeAgo();
      expect(result).toBe('1 hour ago');
    });

    it('should return days ago for notifications less than a week old', () => {
      const twoDaysAgo = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: twoDaysAgo
      };

      const result = component.getTimeAgo();
      expect(result).toContain('days ago');
    });

    it('should return "1 day ago" for singular day', () => {
      const oneDayAgo = new Date(Date.now() - 25 * 60 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: oneDayAgo
      };

      const result = component.getTimeAgo();
      expect(result).toBe('1 day ago');
    });

    it('should return localized date for notifications older than a week', () => {
      const eightDaysAgo = new Date(Date.now() - 8 * 24 * 60 * 60 * 1000);
      component.notification = {
        ...mockNotification,
        createdAt: eightDaysAgo
      };

      const result = component.getTimeAgo();
      expect(result).toBe(eightDaysAgo.toLocaleDateString());
    });
  });
});