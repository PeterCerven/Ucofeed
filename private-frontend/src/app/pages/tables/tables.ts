import { AfterViewInit, Component, ViewChild } from '@angular/core';
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
import { UniversityExcelData } from '../../models/csv-uni-data.model';
import { FileParseService } from '../../services/parse.service';

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
export class Tables implements AfterViewInit {
  constructor(private fileParseService: FileParseService) {
  }

  displayedColumns: string[] = [
    'programName',
    'university',
    'faculty',
    'educationLevel',
    'studyType',
    'studyForm',
    'studyGroupSubjects',
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

  async onFileSelected(event: Event) {
    const files = (event.target as HTMLInputElement).files;
    if (!files || files.length === 0) {
      console.error('No file selected');
      return;
    }

    const file = files[0];
    try {
      this.dataSource.data = await this.fileParseService.parseFile(file);
      console.log(this.dataSource.data);

      if (this.dataSource.paginator) {
        this.dataSource.paginator.firstPage();
      }
      console.log('Excel file parsed and data loaded successfully.');

    } catch (error) {
      console.error('Error while parsing the Excel file:', error);
    }


  }


}
