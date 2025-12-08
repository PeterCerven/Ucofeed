import { Component, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatCardModule } from '@angular/material/card';
import { MatSnackBar } from '@angular/material/snack-bar';
import { UniversityService } from '@services/university.service';
import { AuthService } from '@services/auth.service';
import { UserService, UpdateUserRequest } from '@services/user.service';
import { UniversityModel } from '@models/university.model';
import { FacultyModel } from '@models/faculty.model';
import { ProgramModel } from '@models/program.model';
import { VariantModel } from '@models/variant.model';
import {
  ProfileData,
  STATUSES
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
  private readonly authService = inject(AuthService);
  private readonly userService = inject(UserService);
  private readonly snackBar = inject(MatSnackBar);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  readonly profileForm: FormGroup;
  readonly verificationForm: FormGroup;
  readonly universities = signal<UniversityModel[]>([]);
  readonly faculties = signal<FacultyModel[]>([]);
  readonly programs = signal<ProgramModel[]>([]);
  readonly variants = signal<VariantModel[]>([]);

  readonly statuses = STATUSES;
  readonly showVerification = signal(false);
  readonly isVerifying = signal(false);

  constructor() {
    this.verificationForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      verificationCode: ['', [Validators.required]]
    });

    // Profile form
    this.profileForm = this.fb.group({
      universityId: [null],
      facultyId: [null],
      studyProgramId: [null],
      studyProgramVariantId: [null, Validators.required],
      status: ['', Validators.required]
    });

    // Watch for university changes to load faculties
    this.profileForm.get('universityId')?.valueChanges.subscribe(universityId => {
      this.profileForm.patchValue({ facultyId: null, studyProgramId: null, studyProgramVariantId: null });
      this.faculties.set([]);
      this.programs.set([]);
      this.variants.set([]);
      if (universityId) {
        this.loadFaculties(universityId);
      }
    });

    // Watch for faculty changes to load programs
    this.profileForm.get('facultyId')?.valueChanges.subscribe(facultyId => {
      this.profileForm.patchValue({ studyProgramId: null, studyProgramVariantId: null });
      this.programs.set([]);
      this.variants.set([]);
      if (facultyId) {
        this.loadPrograms(facultyId);
      }
    });

    // Watch for program changes to load variants
    this.profileForm.get('studyProgramId')?.valueChanges.subscribe(programId => {
      this.profileForm.patchValue({ studyProgramVariantId: null });
      this.variants.set([]);
      if (programId) {
        this.loadVariants(programId);
      }
    });
  }

  ngOnInit(): void {
    // Check if we need to show verification (e.g., from query params)
    this.route.queryParams.subscribe(params => {
      if (params['verify'] === 'true' && params['email']) {
        this.showVerification.set(true);
        this.verificationForm.patchValue({ email: params['email'] });
      }
    });

    this.loadUniversities();
    this.loadSavedProfile();
  }

  onVerify(): void {
    if (this.verificationForm.valid) {
      this.isVerifying.set(true);
      const { email, verificationCode } = this.verificationForm.value;

      this.authService.verify(email, verificationCode).subscribe({
        next: (response) => {
          this.isVerifying.set(false);
          this.showVerification.set(false);

          // Set auth state (user is now logged in after verification)
          localStorage.setItem('authUser', JSON.stringify({ id: response.id, email: response.email, role: response.role }));

          this.snackBar.open('Account verified successfully! You can now complete your profile.', 'Close', {
            duration: 5000,
            horizontalPosition: 'end',
            verticalPosition: 'top'
          });
          // Clear query params and reload to update auth state
          this.router.navigate([], {
            relativeTo: this.route,
            queryParams: {}
          }).then(() => {
            // Reload to update parent component's auth state
            window.location.reload();
          });
        },
        error: (error) => {
          this.isVerifying.set(false);
          const errorMessage = error.error || 'Verification failed. Please check your code and try again.';
          this.snackBar.open(errorMessage, 'Close', {
            duration: 5000,
            horizontalPosition: 'end',
            verticalPosition: 'top'
          });
        }
      });
    } else {
      this.verificationForm.markAllAsTouched();
    }
  }

  getVerificationErrorMessage(field: string): string {
    const control = this.verificationForm.get(field);

    if (control?.hasError('required')) {
      return 'This field is required';
    }

    if (control?.hasError('email')) {
      return 'Please enter a valid email address';
    }

    return '';
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

  private loadVariants(programId: number): void {
    this.universityService.getVariantsByProgram(programId).subscribe({
      next: (variants) => this.variants.set(variants),
      error: (error) => console.error('Failed to load variants:', error)
    });
  }

  private loadSavedProfile(): void {
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
      // Get user ID from localStorage
      const authUser = localStorage.getItem('authUser');
      if (!authUser) {
        this.snackBar.open('Please log in to save your profile', 'Close', {
          duration: 3000,
          horizontalPosition: 'end',
          verticalPosition: 'top'
        });
        return;
      }

      const { id: userId } = JSON.parse(authUser);
      const profileData: ProfileData = this.profileForm.value;

      // Prepare update request matching backend DTO structure
      const updateRequest: UpdateUserRequest = {
        studyProgramId: profileData.studyProgramId,
        studyProgramVariantId: profileData.studyProgramVariantId,
        status: profileData.status
      };

      console.log('Updating user with data:', updateRequest);

      // Call backend to update user
      this.userService.updateUser(userId, updateRequest).subscribe({
        next: (response) => {
          // Also save to localStorage for offline access
          localStorage.setItem('userProfile', JSON.stringify(profileData));

          this.snackBar.open('Profile saved successfully!', 'Close', {
            duration: 3000,
            horizontalPosition: 'end',
            verticalPosition: 'top'
          });
        },
        error: (error) => {
          const errorMessage = error.error || 'Failed to save profile. Please try again.';
          this.snackBar.open(errorMessage, 'Close', {
            duration: 5000,
            horizontalPosition: 'end',
            verticalPosition: 'top'
          });
        }
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
    this.profileForm.reset();
    this.faculties.set([]);
    this.programs.set([]);
    this.variants.set([]);
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
