import { Component, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProgramDetailsModel } from '@models/program-details.model';
import { MatChipsModule } from '@angular/material/chips';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-program-details-header',
  standalone: true,
  imports: [CommonModule, MatChipsModule, MatIconModule],
  templateUrl: './program-details-header.component.html',
  styleUrl: './program-details-header.component.scss'
})
export class ProgramDetailsHeaderComponent {
  programDetails = input.required<ProgramDetailsModel>();

  /** Get array of rating keys for distribution display */
  get ratingKeys(): number[] {
    return Object.keys(this.programDetails().ratingDistribution)
      .map(Number)
      .sort((a, b) => b - a);
  }

  /** Calculate percentage for rating distribution bar */
  getRatingPercentage(rating: number): number {
    const distribution = this.programDetails().ratingDistribution;
    const total = this.programDetails().totalReviews;
    return total > 0 ? (distribution[rating] / total) * 100 : 0;
  }

  /** Get stars array for average rating display */
  get starsArray(): number[] {
    return Array.from({ length: 10 }, (_, i) => i);
  }

  /** Check if star should be filled */
  isStarFilled(index: number): boolean {
    return index < Math.round(this.programDetails().averageRating);
  }

  /** Get degree label from degree number */
  getDegreeLabel(degree: number): string {
    switch (degree) {
      case 1:
        return '1st degree (Bachelor)';
      case 2:
        return '2nd degree (Master)';
      case 3:
        return '3rd degree (Doctoral)';
      default:
        return `${degree}° degree`;
    }
  }
}