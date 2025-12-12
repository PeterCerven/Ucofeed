import { Component, input, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReviewModel } from '@models/review.model';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { CommentsSectionComponent } from '@components/comments-section/comments-section.component';

@Component({
  selector: 'app-review-card',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatIconModule,
    MatButtonModule,
    MatChipsModule,
    CommentsSectionComponent,
  ],
  templateUrl: './review-card.component.html',
  styleUrl: './review-card.component.scss',
})
export class ReviewCardComponent {
  review = input.required<ReviewModel>();
  showActions = input<boolean>(false);

  isExpanded = signal(false);

  /** Toggle comments section */
  toggleComments(): void {
    this.isExpanded.set(!this.isExpanded());
  }

  /** Format date to readable string */
  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  }

  /** Get rating color based on value */
  getRatingColor(rating: number): string {
    if (rating >= 8) return '#4caf50'; // Green
    if (rating >= 6) return '#ff9800'; // Orange
    return '#f44336'; // Red
  }

  /** Get array for star display (1-10) */
  getStarsArray(rating: number): boolean[] {
    return Array.from({ length: 10 }, (_, i) => i < rating);
  }
}
