import { Component, effect, inject, signal, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { CommonModule } from '@angular/common';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { catchError, of } from 'rxjs';
import { TranslocoService, TranslocoDirective } from '@jsverse/transloco';
import { ReviewService } from '@services/review.service';
import { UniversityService } from '@services/university.service';
import { AuthStateService } from '@services/auth-state.service';
import { ProgramDetailsModel, StudyProgramDetailsModel } from '@models/program-details.model';
import { ReviewModel, ReviewFilterOptions, CreateReviewDto } from '@models/review.model';
import { VariantModel } from '@models/variant.model';
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
    TranslocoDirective,
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
  private universityService = inject(UniversityService);
  private authState = inject(AuthStateService);
  private snackBar = inject(MatSnackBar);
  private translocoService = inject(TranslocoService);

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

  // Check if user can create a review
  get canCreateReview(): boolean {
    return this.authState.isVerified();
  }

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

    // Fetch study program from backend (with fallback)
    this.universityService.getStudyProgramById(programId).pipe(
      catchError(error => {
        console.error('Study program endpoint not implemented:', error);
        // Fallback to mock data for now
        return of({
          id: programId,
          name: 'Computer Science',
          study_field: 'Informatics',
          faculty_name: 'Faculty of Informatics',
          university_name: 'Slovak University of Technology'
        } as StudyProgramDetailsModel);
      })
    ).subscribe({
      next: (program) => {
        // Fetch variants
        this.universityService.getVariantsByProgram(programId).subscribe({
          next: (variants) => {
            // Map to ProgramDetailsModel format
            const programDetails: ProgramDetailsModel = {
              id: program.id,
              name: program.name,
              description: '', // Not available from backend
              faculty_id: program.faculty_id,
              faculty_name: program.faculty_name || '',
              university_id: program.university_id,
              university_name: program.university_name || '',
              rating: 0, // Will be calculated from reviews
              totalReviews: 0,  // Will be counted from reviews
              ratingDistribution: {},
              tags: {
                // Extract from variants
                languageGroup: this.extractLanguages(variants),
                studyFormat: this.extractFormats(variants),
                title: this.extractTitles(variants),
              }
            };
            this.programDetails.set(programDetails);
            this.isLoadingDetails.set(false);
          },
          error: (error) => {
            console.error('Error loading variants:', error);
            this.isLoadingDetails.set(false);
          }
        });
      }
    });
  }

  private loadReviews(programId: number): void {
    this.isLoadingReviews.set(true);
    this.reviewService.getReviews(programId, this.filters()).subscribe({
      next: (reviews) => {
        this.reviews.set(reviews);
        this.isLoadingReviews.set(false);

        // Update program details with review stats
        this.updateReviewStats(reviews);
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
    // Verify auth state
    if (!this.authState.isLoggedIn()) {
      console.error('User must be logged in to create review');
      this.snackBar.open(
        this.translocoService.translate('app.snackbar.reviewSubmitErrorRequireLogin'),
        this.translocoService.translate('app.snackbar.close'),
        {
          duration: 3000,
          horizontalPosition: 'center',
          verticalPosition: 'top',
          panelClass: ['error-snackbar'],
        }
      );
      return;
    }

    // Add user ID and program ID to review DTO
    const reviewWithAuth = {
      ...reviewDto,
      userId: this.authState.userId(),
      studyProgramId: this.programDetails()?.id || 0,
    };

    this.reviewService.createReview(reviewWithAuth).subscribe({
      next: (newReview) => {
        // Add new review to the list
        this.reviews.update(reviews => [newReview, ...reviews]);

        // Show success message
        this.snackBar.open(
          this.translocoService.translate('app.snackbar.reviewSubmitSuccess'),
          this.translocoService.translate('app.snackbar.close'),
          {
            duration: 3000,
            horizontalPosition: 'center',
            verticalPosition: 'top',
            panelClass: ['success-snackbar'],
          }
        );

        // Hide form and reset
        this.showReviewForm.set(false);
        this.reviewFormComponent?.resetForm();

        // Reload reviews to get updated stats
        const programId = this.programDetails()?.id;
        if (programId) {
          this.loadReviews(programId);
        }
      },
      error: (error) => {
        console.error('Error submitting review:', error);

        let errorMessage = this.translocoService.translate('app.snackbar.reviewSubmitError');
        if (error.status === 403) {
          errorMessage = this.translocoService.translate('app.snackbar.reviewSubmitErrorNotEnrolled');
        } else if (error.status === 401) {
          errorMessage = this.translocoService.translate('app.snackbar.reviewSubmitErrorNotVerified');
        } else if (error.status === 404) {
          errorMessage = this.translocoService.translate('app.snackbar.reviewSubmitErrorNotImplemented');
        }

        this.snackBar.open(
          errorMessage,
          this.translocoService.translate('app.snackbar.close'),
          {
            duration: 5000,
            horizontalPosition: 'center',
            verticalPosition: 'top',
            panelClass: ['error-snackbar'],
          }
        );
        this.reviewFormComponent?.resetForm();
      },
    });
  }

  onCancelReview(): void {
    this.showReviewForm.set(false);
  }

  private extractLanguages(variants: VariantModel[]): string {
    const languages = [...new Set(variants.map(v => v.language))];
    return languages.join(' / ');
  }

  private extractFormats(variants: VariantModel[]): string {
    const formats = [...new Set(variants.map(v => v.study_form))];
    return formats.join(' / ');
  }

  private extractTitles(variants: VariantModel[]): string {
    const titles = [...new Set(variants.map(v => v.title))];
    return titles.join(', ');
  }

  private updateReviewStats(reviews: ReviewModel[]): void {
    if (reviews.length === 0) return;

    const avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    const distribution: { [key: number]: number } = {};
    reviews.forEach(r => {
      distribution[r.rating] = (distribution[r.rating] || 0) + 1;
    });

    this.programDetails.update(details => details ? {
      ...details,
      rating: avgRating,
      totalReviews: reviews.length,
      ratingDistribution: distribution
    } : details);
  }
}
