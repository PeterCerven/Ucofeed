import {Component, EventEmitter, Input, Output} from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'entity-card',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule],
  templateUrl: './entity-card.component.html',
  styleUrls: ['./entity-card.component.scss'],
})
export class EntityCardComponent {
  @Input() name = 'Unknown';
  @Input() image = '';
  @Input() review = 0;
  @Input() description = '';
  @Input() entityType: 'university' | 'faculty' | 'program' = 'program';
  @Input() id?: number;

  @Output() cardClick = new EventEmitter<number>();

  /** Array of 10 indices for stars */
  readonly starsArray = Array.from({ length: 10 }, (_, i) => i);

  /** Get image URL or default based on entity type */
  getImageUrl(): string {
    if (this.image) {
      return this.image;
    }

    // Return default images based on entity type
    switch (this.entityType) {
      case 'university':
      case 'faculty':
        return 'images/university-default.png';
      case 'program':
        return ''; // Programs don't show images
      default:
        return 'images/university-default.png';
    }
  }

  /** Helper to check star fill */
  isFilled(index: number) {
    return index < this.review;
  }

  /** Get the appropriate placeholder based on entity type */
  getPlaceholderIcon(): string {
    switch (this.entityType) {
      case 'university':
        return 'account_balance';
      case 'faculty':
        return 'business';
      case 'program':
        return 'school';
      default:
        return 'image';
    }
  }

  onCardClick() {
    if (this.id !== undefined) {
      this.cardClick.emit(this.id);
    }
  }
}
