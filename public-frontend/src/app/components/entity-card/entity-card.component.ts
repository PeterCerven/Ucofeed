import { Component, EventEmitter, output, input } from '@angular/core';
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
  // Modern signal inputs
  name = input<string>('Unknown');
  image = input<string>('');
  review = input<number>(0);
  description = input<string>('');
  entityType = input<'university' | 'faculty' | 'program'>('university');
  id = input<number>();

  // Modern signal output
  cardClick = output<number>();

  /** Array of 10 indices for stars */
  readonly starsArray = Array.from({ length: 10 }, (_, i) => i);

  /** Get image URL or default based on entity type */
  getImageUrl(): string {
    const img = this.image();
    if (img) return img;

    switch (this.entityType()) {
      case 'university':
      case 'faculty':
        return 'images/university-default.png';
      case 'program':
        return '';
      default:
        return 'images/university-default.png';
    }
  }

  /** Helper to check star fill */
  isFilled(index: number) {
    return index < this.review();
  }

  /** Get the appropriate placeholder based on entity type */
  getPlaceholderIcon(): string {
    switch (this.entityType()) {
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
    const cardId = this.id();
    if (cardId !== undefined) {
      this.cardClick.emit(cardId);
    }
  }
}
