import { Component, input, signal, effect, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CommentModel } from '@models/comment.model';
import { ReviewService } from '@services/review.service';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';

@Component({
  selector: 'app-comments-section',
  standalone: true,
  imports: [CommonModule, MatIconModule, MatButtonModule, MatChipsModule],
  templateUrl: './comments-section.component.html',
  styleUrl: './comments-section.component.scss',
})
export class CommentsSectionComponent {
  reviewId = input.required<number>();

  private reviewService = inject(ReviewService);

  comments = signal<CommentModel[]>([]);
  isLoading = signal(true);

  constructor() {
    effect(() => {
      const id = this.reviewId();
      if (id) {
        this.loadComments(id);
      }
    });
  }

  private loadComments(reviewId: number): void {
    this.isLoading.set(true);
    this.reviewService.getComments(reviewId).subscribe({
      next: (comments) => {
        this.comments.set(comments);
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Error loading comments:', error);
        this.isLoading.set(false);
      },
    });
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  }
}