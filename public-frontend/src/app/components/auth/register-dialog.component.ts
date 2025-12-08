import { Component, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { CommonModule } from '@angular/common';
import { UniversityService } from '@services/university.service';
import { UniversityModel } from '@models/university.model';

export interface RegisterData {
  email: string;
  password: string;
}

// Custom Validators
export class CustomValidators {
  static passwordMatch(control: AbstractControl): ValidationErrors | null {
    const password = control.get('password');
    const confirmPassword = control.get('confirmPassword');

    if (!password || !confirmPassword) {
      return null;
    }

    const mismatch = password.value !== confirmPassword.value;

    if (mismatch) {
      confirmPassword.setErrors({ passwordMismatch: true });
      return { passwordMismatch: true };
    } else {
      const errors = confirmPassword.errors;
      if (errors) {
        delete errors['passwordMismatch'];
        confirmPassword.setErrors(Object.keys(errors).length > 0 ? errors : null);
      }
      return null;
    }
  }

  static universityEmail(allowedDomains: string[]) {
    return (control: AbstractControl): ValidationErrors | null => {
      if (!control.value) {
        return null;
      }

      const email = control.value.toLowerCase();
      const [localPart, domain] = email.split('@');

      if (!localPart || !domain) {
        return { invalidUniversityDomain: { allowedDomains } };
      }

      // University-specific validation patterns
      const universityPatterns: { [key: string]: RegExp } = {
        // UK Bratislava: last name with number + @uniba.sk
        'uniba.sk': /^[a-z]+\d+$/,

        // STU Bratislava: AIS login + @stuba.sk
        'stuba.sk': /^[a-z]+\d*$/,

        // TUKE Košice: first name.last name + @student.tuke.sk
        'student.tuke.sk': /^[a-z]+\.[a-z]+$/,

        // UPJŠ Košice: first name.last name + @student.upjs.sk OR aisID + @upjs.sk
        'student.upjs.sk': /^[a-z]+\.[a-z]+$/,
        'upjs.sk': /^[a-z]+\d*$/,

        // UNIZA Žilina: last name without diacritics with number + @stud.uniza.sk
        'stud.uniza.sk': /^[a-z]+\d+$/,

        // EUBA Bratislava: [letter][last name][number] + @euba.sk
        'euba.sk': /^[a-z][a-z]+\d+$/
      };

      // Check if the domain is valid
      if (!universityPatterns[domain]) {
        return { invalidUniversityDomain: { allowedDomains } };
      }

      // Check if the student specification matches the university's pattern
      if (!universityPatterns[domain].test(localPart)) {
        return { invalidEmailFormat: { domain } };
      }

      return null;
    };
  }
}

@Component({
  selector: 'app-register-dialog',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSelectModule
  ],
  templateUrl: './register-dialog.component.html',
  styleUrl: './register-dialog.component.scss'
})
export class RegisterDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<RegisterDialogComponent>);
  private readonly universityService = inject(UniversityService);

  readonly registerForm: FormGroup;
  readonly universities = signal<UniversityModel[]>([]);
  readonly allowedDomains: string[] = [
    'uniba.sk',
    'stuba.sk',
    'student.tuke.sk',
    'student.upjs.sk',
    'upjs.sk',
    'stud.uniza.sk',
    'euba.sk'
  ];

  hidePassword = true;
  hideConfirmPassword = true;

  constructor() {
    this.registerForm = this.fb.group({
      email: ['', [
        Validators.required,
        Validators.email,
        CustomValidators.universityEmail(this.allowedDomains)
      ]],
      password: ['', [
        Validators.required,
        Validators.minLength(8),
        Validators.pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/)
      ]],
      confirmPassword: ['', [Validators.required]]
    }, {
      validators: CustomValidators.passwordMatch
    });
  }

  ngOnInit(): void {
    this.loadUniversities();
  }

  private loadUniversities(): void {
    this.universityService.getUniversities().subscribe({
      next: (universities) => this.universities.set(universities),
      error: (error) => console.error('Failed to load universities:', error)
    });
  }

  onSubmit(): void {
    if (this.registerForm.valid) {
      const { confirmPassword, ...registerData } = this.registerForm.value;
      this.dialogRef.close(registerData as RegisterData);
    } else {
      this.registerForm.markAllAsTouched();
    }
  }

  onCancel(): void {
    this.dialogRef.close();
  }

  togglePasswordVisibility(field: 'password' | 'confirmPassword'): void {
    if (field === 'password') {
      this.hidePassword = !this.hidePassword;
    } else {
      this.hideConfirmPassword = !this.hideConfirmPassword;
    }
  }

  getErrorMessage(field: string): string {
    const control = this.registerForm.get(field);

    if (control?.hasError('required')) {
      return 'This field is required';
    }

    if (control?.hasError('email')) {
      return 'Please enter a valid email address';
    }

    if (control?.hasError('invalidUniversityDomain')) {
      return `Must be one of: ${this.allowedDomains.join(', ')}`;
    }

    if (control?.hasError('invalidEmailFormat')) {
      const domain = control.errors?.['invalidEmailFormat'].domain;
      return `Invalid email format for ${domain}`;
    }

    if (control?.hasError('minlength')) {
      const minLength = control.errors?.['minlength'].requiredLength;
      return `Must be at least ${minLength} characters`;
    }

    if (control?.hasError('pattern')) {
      return 'Must contain uppercase, lowercase, number and special character';
    }

    if (control?.hasError('passwordMismatch')) {
      return 'Passwords do not match';
    }

    return '';
  }

}
