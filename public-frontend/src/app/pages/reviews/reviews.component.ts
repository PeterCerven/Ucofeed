import { Component, effect, inject, signal, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { CommonModule } from '@angular/common';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ReviewService } from '@services/review.service';
import { ProgramDetailsModel } from '@models/program-details.model';
import { ReviewModel, ReviewFilterOptions, CreateReviewDto } from '@models/review.model';
import { ProgramDetailsHeaderComponent } from '@components/program-details-header/program-details-header.component';
import { ReviewFilterComponent } from '@components/review-filter/review-filter.component';
import { ReviewCardComponent } from '@components/review-card/review-card.component';
import { ReviewFormComponent } from '@components/review-form/review-form.component';

@Component({
  selector: 'app-reviews',
  standalone: true,
  imports: [
    CommonModule,
    MatSnackBarModule,
    MatButtonModule,
    MatIconModule,
    ProgramDetailsHeaderComponent,
    ReviewFilterComponent,
    ReviewCardComponent,
    ReviewFormComponent,
  ],
  templateUrl: './reviews.component.html',
  styleUrl: './reviews.component.scss',
})
export class ReviewsComponent {
  private route = inject(ActivatedRoute);
  private reviewService = inject(ReviewService);
  private snackBar = inject(MatSnackBar);

  @ViewChild(ReviewFormComponent) reviewFormComponent?: ReviewFormComponent;

  private paramMap = toSignal(this.route.paramMap);

  programDetails = signal<ProgramDetailsModel | null>(null);
  reviews = signal<ReviewModel[]>([]);
  filters = signal<ReviewFilterOptions>({
    sortBy: 'newest',
  });
  isLoadingDetails = signal(true);
  isLoadingReviews = signal(true);
  showReviewForm = signal(false);

  // Study program variant ID - will come from backend/user enrollment
  studyProgramVariantId = signal<number>(1); // Will be auto-assigned from backend response

  constructor() {
    effect(() => {
      const id = Number(this.paramMap()?.get('id'));
      if (id) {
        this.loadProgramDetails(id);
        this.loadReviews(id);
      }
    });
  }

  private loadProgramDetails(programId: number): void {
    this.isLoadingDetails.set(true);
    this.reviewService.getProgramDetails(programId).subscribe({
      next: (details) => {
        this.programDetails.set(details);
        this.isLoadingDetails.set(false);
      },
      error: (error) => {
        console.error('Error loading program details:', error);
        this.isLoadingDetails.set(false);
      },
    });
  }

  private loadReviews(programId: number): void {
    this.isLoadingReviews.set(true);
    this.reviewService.getReviews(programId, this.filters()).subscribe({
      next: (reviews) => {
        this.reviews.set(reviews);
        this.isLoadingReviews.set(false);
      },
      error: (error) => {
        console.error('Error loading reviews:', error);
        this.isLoadingReviews.set(false);
      },
    });
  }

  onFilterChange(newFilters: ReviewFilterOptions): void {
    this.filters.set(newFilters);
    const id = Number(this.paramMap()?.get('id'));
    if (id) {
      this.loadReviews(id);
    }
  }

  toggleReviewForm(): void {
    this.showReviewForm.set(!this.showReviewForm());
  }

  onSubmitReview(reviewDto: CreateReviewDto): void {
    this.reviewService.createReview(reviewDto).subscribe({
      next: (newReview) => {
        // Add new review to the list
        this.reviews.update(reviews => [newReview, ...reviews]);

        // Show success message
        this.snackBar.open('Review submitted successfully!', 'Close', {
          duration: 3000,
          horizontalPosition: 'center',
          verticalPosition: 'top',
          panelClass: ['success-snackbar'],
        });

        // Hide form and reset
        this.showReviewForm.set(false);
        this.reviewFormComponent?.resetForm();
      },
      error: (error) => {
        console.error('Error submitting review:', error);
        this.snackBar.open('Failed to submit review. Please try again.', 'Close', {
          duration: 5000,
          horizontalPosition: 'center',
          verticalPosition: 'top',
          panelClass: ['error-snackbar'],
        });
        this.reviewFormComponent?.resetForm();
      },
    });
  }

  onCancelReview(): void {
    this.showReviewForm.set(false);
  }
}