import { Component, effect, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { CommonModule } from '@angular/common';
import { ReviewService } from '@services/review.service';
import { ProgramDetailsModel } from '@models/program-details.model';
import { ReviewModel, ReviewFilterOptions } from '@models/review.model';
import { ProgramDetailsHeaderComponent } from '@components/program-details-header/program-details-header.component';
import { ReviewFilterComponent } from '@components/review-filter/review-filter.component';
import { ReviewCardComponent } from '@components/review-card/review-card.component';

@Component({
  selector: 'app-reviews',
  standalone: true,
  imports: [
    CommonModule,
    ProgramDetailsHeaderComponent,
    ReviewFilterComponent,
    ReviewCardComponent,
  ],
  templateUrl: './reviews.component.html',
  styleUrl: './reviews.component.scss',
})
export class ReviewsComponent {
  private route = inject(ActivatedRoute);
  private reviewService = inject(ReviewService);

  private paramMap = toSignal(this.route.paramMap);

  programDetails = signal<ProgramDetailsModel | null>(null);
  reviews = signal<ReviewModel[]>([]);
  filters = signal<ReviewFilterOptions>({
    year: '',
    semester: 'ALL',
    sortBy: 'newest',
  });
  isLoadingDetails = signal(true);
  isLoadingReviews = signal(true);

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
}