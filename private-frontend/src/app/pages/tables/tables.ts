import { AfterViewInit, Component, ViewChild } from '@angular/core';
import {
  MatCell,
  MatCellDef, MatColumnDef,
  MatHeaderCell, MatHeaderCellDef,
  MatHeaderRow, MatHeaderRowDef,
  MatRow, MatRowDef,
  MatTable,
  MatTableDataSource,
} from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort, MatSortHeader, MatSortModule } from '@angular/material/sort';
import { MatFormField, MatInput, MatLabel } from '@angular/material/input';
import { MatFabButton } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { UniversityExcelData } from '../../models/csv-uni-data.model';

@Component({
  selector: 'app-tables',
  imports: [
    MatTable, MatPaginator, MatCell, MatHeaderCell, MatHeaderRow, MatRow, MatCellDef,
    MatHeaderCellDef, MatHeaderRowDef, MatRowDef, MatColumnDef, MatSortHeader, MatSortModule,
    MatFormField, MatLabel, MatInput, MatLabel, MatFormField, MatFabButton, MatIconModule
  ],
  templateUrl: './tables.html',
  styleUrl: './tables.scss'
})
export class Tables implements AfterViewInit {
  displayedColumns: string[] = [
    'programName',
    'university',
    'faculty',
    'educationLevel',
    'studyType',
    'studyForm',
    'studyGroupSubjects'
  ];
  dataSource = new MatTableDataSource<UniversityExcelData>();

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }
}
