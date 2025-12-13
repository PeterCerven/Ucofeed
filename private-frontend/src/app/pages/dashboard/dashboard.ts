import { Component, DestroyRef, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
// import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { MatIcon } from '@angular/material/icon';
import { NotificationCardComponent } from '@components/notification-card/notification-card';
import { NotificationService } from '@services/notification.service';
import { Notification } from '@models/notification.model';

@Component({
  selector: 'app-dashboard',
  imports: [
    NotificationCardComponent,
    // MatPaginator, // Commented out - will be re-enabled when backend supports pagination
    MatProgressSpinner,
    MatIcon,
  ],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss'
})
export class Dashboard {
  private notificationService = inject(NotificationService);
  private destroyRef = inject(DestroyRef);

  // Signals for state management
  notifications = signal<Notification[]>([]);
  isLoading = signal(false);

  constructor() {
    // Load notifications on component initialization
    this.loadNotifications();
  }

  private loadNotifications(): void {
    this.isLoading.set(true);
    this.notificationService
      .getNotifications()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (notifications) => {
          this.notifications.set(notifications);
          this.isLoading.set(false);
        },
        error: (error) => {
          console.error('Failed to load notifications:', error);
          this.isLoading.set(false);
        }
      });
  }

  onNotificationClick(notification: Notification): void {
    console.log('Notification clicked:', notification);
    // Future: Navigate to detail view or open modal showing full review details
  }

  onDelete(notificationId: number): void {
    this.notificationService
      .deleteNotification(notificationId)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: () => {
          // Reload notifications after deletion
          this.loadNotifications();
        },
        error: (error) => {
          console.error('Failed to delete notification:', error);
        }
      });
  }
}
