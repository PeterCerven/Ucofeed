import { Component, output, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
import { TranslocoDirective } from '@jsverse/transloco';
import { ReviewFilterOptions } from '@models/review.model';

@Component({
  selector: 'app-review-filter',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatFormFieldModule,
    MatSelectModule,
    MatIconModule,
    TranslocoDirective,
  ],
  templateUrl: './review-filter.component.html',
  styleUrl: './review-filter.component.scss',
})
export class ReviewFilterComponent {
  filterChange = output<ReviewFilterOptions>();

  selectedSort = signal<'newest' | 'oldest' | 'highest' | 'lowest' | 'edited'>('newest');

  sortOptions: Array<{
    value: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited';
    icon: string;
  }> = [
    { value: 'newest', icon: 'schedule' },
    { value: 'oldest', icon: 'history' },
    { value: 'highest', icon: 'arrow_upward' },
    { value: 'lowest', icon: 'arrow_downward' },
    { value: 'edited', icon: 'edit' },
  ];

  onSortChange(sortBy: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited'): void {
    this.selectedSort.set(sortBy);
    this.emitFilters();
  }

  private emitFilters(): void {
    this.filterChange.emit({
      sortBy: this.selectedSort(),
    });
  }
}