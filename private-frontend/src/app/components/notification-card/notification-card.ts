import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCard, MatCardContent, MatCardActions } from '@angular/material/card';
import { MatIcon } from '@angular/material/icon';
import { MatButton, MatIconButton } from '@angular/material/button';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';
import { Notification } from '@models/notification.model';

@Component({
  selector: 'app-notification-card',
  imports: [
    CommonModule,
    MatCard,
    MatCardContent,
    MatCardActions,
    MatIcon,
    MatButton,
    MatIconButton,
    MatMenu,
    MatMenuItem,
    MatMenuTrigger,
  ],
  templateUrl: './notification-card.html',
  styleUrl: './notification-card.scss'
})
export class NotificationCardComponent {
  @Input() notification!: Notification;
  @Output() notificationClicked = new EventEmitter<Notification>();
  @Output() deleteClicked = new EventEmitter<number>();

  onCardClick(): void {
    this.notificationClicked.emit(this.notification);
  }

  onDelete(event: Event): void {
    event.stopPropagation();
    this.deleteClicked.emit(this.notification.id);
  }

  getActionIcon(): string {
    return 'rate_review'; // Currently only ReviewCreated events
  }

  getActionText(): string {
    return 'created a review for';
  }

  getTimeAgo(): string {
    const now = new Date();
    const created = new Date(this.notification.createdAt);
    const diffMs = now.getTime() - created.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) {
      return 'Just now';
    } else if (diffMins < 60) {
      return `${diffMins} ${diffMins === 1 ? 'minute' : 'minutes'} ago`;
    } else if (diffHours < 24) {
      return `${diffHours} ${diffHours === 1 ? 'hour' : 'hours'} ago`;
    } else if (diffDays < 7) {
      return `${diffDays} ${diffDays === 1 ? 'day' : 'days'} ago`;
    } else {
      return created.toLocaleDateString();
    }
  }
}