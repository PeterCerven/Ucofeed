import { Component, ViewChild } from '@angular/core';
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

export interface UniversityExcelData {
  programName: string;
  university: string;
  faculty: string;
  educationLevel: string;
  studyType: string;
  studyForm: string;
  studyGroupSubjects: string;
}

const ELEMENT_DATA: UniversityExcelData[] = [
  {
    programName: 'Bachelor of Science in Computer Science',
    university: 'University of Technology',
    faculty: 'Faculty of Engineering',
    educationLevel: 'Bachelor',
    studyType: 'Full-time',
    studyForm: 'On-campus',
    studyGroupSubjects: 'Programming, Data Structures, Algorithms'
  },
  {
    programName: 'Master of Arts in History',
    university: 'College of Humanities',
    faculty: 'Faculty of Arts',
    educationLevel: 'Master',
    studyType: 'Part-time',
    studyForm: 'Online',
    studyGroupSubjects: 'World History, Cultural Studies'
  },
  {
    programName: 'Doctor of Philosophy in Physics',
    university: 'Institute of Advanced Studies',
    faculty: 'Faculty of Science',
    educationLevel: 'PhD',
    studyType: 'Full-time',
    studyForm: 'On-campus',
    studyGroupSubjects: 'Quantum Mechanics, Relativity'
  },
  {
    programName: 'Bachelor of Arts in Psychology',
    university: 'University of Social Sciences',
    faculty: 'Faculty of Social Sciences',
    educationLevel: 'Bachelor',
    studyType: 'Full-time',
    studyForm: 'Hybrid',
    studyGroupSubjects: 'Cognitive Psychology, Behavioral Studies'
  }
];

@Component({
  selector: 'app-tables',
  imports: [
    MatTable, MatPaginator, MatCell, MatHeaderCell, MatHeaderRow, MatRow, MatCellDef,
    MatHeaderCellDef, MatHeaderRowDef, MatRowDef, MatColumnDef, MatSortHeader, MatSortModule, MatFormField, MatLabel, MatInput, MatLabel, MatFormField,
  ],
  templateUrl: './tables.html',
  styleUrl: './tables.scss'
})
export class Tables {
  displayedColumns: string[] = [
    'programName',
    'university',
    'faculty',
    'educationLevel',
    'studyType',
    'studyForm',
    'studyGroupSubjects'
  ];
  dataSource = new MatTableDataSource(ELEMENT_DATA);

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(event: Event) {
    let filterValue = (event.target as HTMLInputElement).value;
    filterValue = filterValue.trim().toLowerCase();
    this.dataSource.filter = filterValue;
  }
}
