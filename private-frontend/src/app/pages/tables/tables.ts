import { Component, DestroyRef, effect, inject, viewChild } from '@angular/core';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
  MatTableDataSource,
} from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort, MatSortHeader, MatSortModule } from '@angular/material/sort';
import { MatFormField, MatInput, MatLabel } from '@angular/material/input';
import { MatFabButton } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { UniversityData } from '@models/csv-uni-data.model';
import { DataService } from '@services/data.service';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-tables',
  imports: [
    MatTable, MatPaginator, MatCell, MatHeaderCell, MatHeaderRow, MatRow, MatCellDef,
    MatHeaderCellDef, MatHeaderRowDef, MatRowDef, MatColumnDef, MatSortHeader, MatSortModule,
    MatFormField, MatLabel, MatInput, MatLabel, MatFormField, MatFabButton, MatIconModule,
  ],
  templateUrl: './tables.html',
  styleUrl: './tables.scss',
})
export class Tables {
  private dataService = inject(DataService);
  private destroyRef = inject(DestroyRef);

  paginator = viewChild<MatPaginator>(MatPaginator);
  sort = viewChild<MatSort>(MatSort);

  displayedColumns: string[] = [
    'programName',
    'university',
    'faculty',
    'educationLevel',
    'studyType',
    'studyForm',
    'studyGroupSubjects',
  ];
  dataSource = new MatTableDataSource<UniversityData>();

  constructor() {
    effect(() => {
      const paginatorInstance = this.paginator();
      const sortInstance = this.sort();

      if (paginatorInstance) {
        this.dataSource.paginator = paginatorInstance;
      }

      if (sortInstance) {
        this.dataSource.sort = sortInstance;
      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  parseData(event: Event) {
    const files = (event.target as HTMLInputElement).files;
    if (!files || files.length === 0) {
      console.error('No file selected');
      return;
    }

    const file = files[0];
    this.dataService.parseFile(file)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
          next: (data) => {
            this.dataSource.data = data;
            if (this.dataSource.paginator) {
              this.dataSource.paginator.firstPage();
            }
            console.log('Data parsed successfully.');
          },
          error: (error) => {
            console.error('Error while parsing the data:', error);
          }
        }
      )
  }

  saveData() {
    this.dataService.saveData(this.dataSource.data)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          console.log('Data saved successfully:', data);
        },
        error: (error) => {
          console.error('Error saving data:', error);
        }
      });
  }

  showData() {
    this.dataService.showData()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          this.dataSource.data = data;
          if (this.dataSource.paginator) {
            this.dataSource.paginator.firstPage();
          }
          console.log('Data fetched successfully:', data);
        },
        error: (error) => {
          console.error('Error fetching data:', error);
        }
      })
  }

  onRowClicked(row: UniversityData) {
    console.log('Row clicked: ', row);
  }
}
