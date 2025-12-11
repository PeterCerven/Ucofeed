import { Component, output, input, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSliderModule } from '@angular/material/slider';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
import { CreateReviewDto } from '@models/review.model';

@Component({
  selector: 'app-review-form',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatSliderModule,
    MatCheckboxModule,
    MatSelectModule,
    MatIconModule,
  ],
  templateUrl: './review-form.component.html',
  styleUrl: './review-form.component.scss',
})
export class ReviewFormComponent {
  // Inputs
  studyProgramId = input.required<number>();
  studyProgramVariantId = input.required<number>(); // Auto-assigned from backend response

  // Outputs
  submitReview = output<CreateReviewDto>();
  cancelForm = output<void>();

  // Signals
  isSubmitting = signal(false);
  ratingStars = signal<boolean[]>([]);

  reviewForm: FormGroup;

  constructor(private fb: FormBuilder) {
    this.reviewForm = this.fb.group({
      comment: ['', [Validators.required, Validators.minLength(20)]],
      rating: [5, [Validators.required, Validators.min(1), Validators.max(10)]],
      anonymous: [false],
    });

    // Watch rating changes to update stars
    this.reviewForm.get('rating')?.valueChanges.subscribe((rating) => {
      this.updateStars(rating);
    });

    // Initialize stars
    this.updateStars(5);
  }

  updateStars(rating: number) {
    const stars = Array(10).fill(false);
    for (let i = 0; i < rating; i++) {
      stars[i] = true;
    }
    this.ratingStars.set(stars);
  }

  onSubmit() {
    if (this.reviewForm.valid) {
      this.isSubmitting.set(true);

      const reviewData: CreateReviewDto = {
        studyProgramId: this.studyProgramId(),
        studyProgramVariantId: this.studyProgramVariantId(),
        comment: this.reviewForm.value.comment,
        rating: this.reviewForm.value.rating,
        anonymous: this.reviewForm.value.anonymous || false,
      };

      this.submitReview.emit(reviewData);
    }
  }

  onCancel() {
    this.reviewForm.reset({
      rating: 5,
      anonymous: false,
    });
    this.cancelForm.emit();
  }

  resetForm() {
    this.isSubmitting.set(false);
    this.reviewForm.reset({
      rating: 5,
      anonymous: false,
    });
  }
}
