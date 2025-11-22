import { Component, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatCardModule } from '@angular/material/card';
import { MatSnackBar } from '@angular/material/snack-bar';
import { UniversityService } from '@services/university.service';
import { UniversityModel } from '@models/university.model';
import { FacultyModel } from '@models/faculty.model';
import { ProgramModel } from '@models/program.model';
import {
  ProfileData,
  LANGUAGES,
  DEGREE_LEVELS,
  STATUSES,
  STUDY_FORMATS
} from '@models/profile.model';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSelectModule,
    MatCardModule
  ],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss'
})
export class ProfileComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly universityService = inject(UniversityService);
  private readonly snackBar = inject(MatSnackBar);

  readonly profileForm: FormGroup;
  readonly universities = signal<UniversityModel[]>([]);
  readonly faculties = signal<FacultyModel[]>([]);
  readonly programs = signal<ProgramModel[]>([]);

  readonly languages = LANGUAGES;
  readonly degreeLevels = DEGREE_LEVELS;
  readonly statuses = STATUSES;
  readonly studyFormats = STUDY_FORMATS;

  constructor() {
    this.profileForm = this.fb.group({
      universityId: [null],
      facultyId: [null],
      studyProgramId: [null],
      language: ['sk', Validators.required],
      degreeLevel: ['', Validators.required],
      status: ['', Validators.required],
      studyFormat: ['', Validators.required]
    });

    // Watch for university changes to load faculties
    this.profileForm.get('universityId')?.valueChanges.subscribe(universityId => {
      this.profileForm.patchValue({ facultyId: null, studyProgramId: null });
      this.faculties.set([]);
      this.programs.set([]);
      if (universityId) {
        this.loadFaculties(universityId);
      }
    });

    // Watch for faculty changes to load programs
    this.profileForm.get('facultyId')?.valueChanges.subscribe(facultyId => {
      this.profileForm.patchValue({ studyProgramId: null });
      this.programs.set([]);
      if (facultyId) {
        this.loadPrograms(facultyId);
      }
    });
  }

  ngOnInit(): void {
    this.loadUniversities();
    this.loadSavedProfile();
  }

  private loadUniversities(): void {
    this.universityService.getUniversities().subscribe({
      next: (universities) => this.universities.set(universities),
      error: (error) => console.error('Failed to load universities:', error)
    });
  }

  private loadFaculties(universityId: number): void {
    this.universityService.getFacultiesByUniversity(universityId).subscribe({
      next: (faculties) => this.faculties.set(faculties),
      error: (error) => console.error('Failed to load faculties:', error)
    });
  }

  private loadPrograms(facultyId: number): void {
    this.universityService.getProgramsByFaculty(facultyId).subscribe({
      next: (programs) => this.programs.set(programs),
      error: (error) => console.error('Failed to load programs:', error)
    });
  }

  private loadSavedProfile(): void {
    // TODO: Load saved profile from backend/localStorage
    const savedProfile = localStorage.getItem('userProfile');
    if (savedProfile) {
      try {
        const profileData = JSON.parse(savedProfile);
        this.profileForm.patchValue(profileData);
      } catch (error) {
        console.error('Failed to load saved profile:', error);
      }
    }
  }

  onSave(): void {
    if (this.profileForm.valid) {
      const profileData: ProfileData = this.profileForm.value;

      // TODO: Save to backend
      localStorage.setItem('userProfile', JSON.stringify(profileData));

      this.snackBar.open('Profile saved successfully!', 'Close', {
        duration: 3000,
        horizontalPosition: 'end',
        verticalPosition: 'top'
      });
    } else {
      this.profileForm.markAllAsTouched();
      this.snackBar.open('Please fill in all required fields', 'Close', {
        duration: 3000,
        horizontalPosition: 'end',
        verticalPosition: 'top'
      });
    }
  }

  onReset(): void {
    this.profileForm.reset({
      language: 'sk'
    });
    this.faculties.set([]);
    this.programs.set([]);
  }

  getErrorMessage(field: string): string {
    const control = this.profileForm.get(field);

    if (control?.hasError('required')) {
      return 'This field is required';
    }

    if (control?.hasError('min')) {
      const min = control.errors?.['min'].min;
      return `Must be at least ${min}`;
    }

    if (control?.hasError('max')) {
      const max = control.errors?.['max'].max;
      return `Must be at most ${max}`;
    }

    return '';
  }
}
