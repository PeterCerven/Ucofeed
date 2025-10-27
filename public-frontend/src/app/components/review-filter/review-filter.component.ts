import { Component, output, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
import { ReviewFilterOptions, Semester } from '@models/review.model';

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

  selectedYear = signal<string>('');
  selectedSemester = signal<Semester | 'ALL'>('ALL');
  selectedSort = signal<'newest' | 'oldest' | 'highest' | 'lowest' | 'edited'>('newest');

  academicYears: string[] = [
    '2024/2025',
    '2023/2024',
    '2022/2023',
    '2021/2022',
    '2020/2021',
  ];

  semesters: Array<{ value: Semester | 'ALL'; label: string }> = [
    { value: 'ALL', label: 'All Semesters' },
    { value: 'WINTER', label: 'Winter Semester' },
    { value: 'SUMMER', label: 'Summer Semester' },
    { value: 'FULL_YEAR', label: 'Full Year' },
  ];

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

  onYearChange(year: string): void {
    this.selectedYear.set(year);
    this.emitFilters();
  }

  onSemesterChange(semester: Semester | 'ALL'): void {
    this.selectedSemester.set(semester);
    this.emitFilters();
  }

  onSortChange(sortBy: 'newest' | 'oldest' | 'highest' | 'lowest' | 'edited'): void {
    this.selectedSort.set(sortBy);
    this.emitFilters();
  }

  private emitFilters(): void {
    this.filterChange.emit({
      year: this.selectedYear(),
      semester: this.selectedSemester(),
      sortBy: this.selectedSort(),
    });
  }
}