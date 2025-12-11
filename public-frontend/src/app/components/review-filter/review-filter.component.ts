import { Component, output, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
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
  ],
  templateUrl: './review-filter.component.html',
  styleUrl: './review-filter.component.scss',
})
export class ReviewFilterComponent {
  filterChange = output<ReviewFilterOptions>();

  selectedSort = signal<'newest' | 'oldest' | 'highest' | 'lowest' | 'edited'>('newest');

  sortOptions: Array<{
    value: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited';
    label: string;
    icon: string;
  }> = [
    { value: 'newest', label: 'Newest First', icon: 'schedule' },
    { value: 'oldest', label: 'Oldest First', icon: 'history' },
    { value: 'highest', label: 'Highest Rated', icon: 'arrow_upward' },
    { value: 'lowest', label: 'Lowest Rated', icon: 'arrow_downward' },
    { value: 'edited', label: 'Recently Edited', icon: 'edit' },
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