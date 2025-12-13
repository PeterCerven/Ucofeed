import { Component, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { CommonModule } from '@angular/common';
import { TranslocoService, TranslocoDirective } from '@jsverse/transloco';
import { UniversityService } from '@services/university.service';
import { UniversityModel } from '@models/university.model';

export interface RegisterData {
  email: string;
  fullName: string;
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
        'uniba.sk': /^[a-z]+\d+$/,

        'stuba.sk': /^[a-z]+\d*$/,

        'student.tuke.sk': /^[a-z]+\d*$/,

        'student.upjs.sk': /^[a-z]+\d*$/,

        'stud.uniza.sk': /^[a-z]+\d+$/,

        'student.euba.sk': /^[a-z]+\d*$/
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
    MatSelectModule,
    TranslocoDirective
  ],
  templateUrl: './register-dialog.component.html',
  styleUrl: './register-dialog.component.scss'
})
export class RegisterDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<RegisterDialogComponent>);
  private readonly universityService = inject(UniversityService);
  private readonly translocoService = inject(TranslocoService);

  readonly registerForm: FormGroup;
  readonly universities = signal<UniversityModel[]>([]);
  readonly allowedDomains: string[] = [
    'uniba.sk',
    'stuba.sk',
    'student.tuke.sk',
    'student.upjs.sk',
    'stud.uniza.sk',
    'student.euba.sk'
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
      fullName: ['', [
        Validators.required,
        Validators.minLength(3) // Prípadne pridajte minLength validáciu
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
      // Použijeme deštrukturalizáciu pre vylúčenie confirmPassword
      const { confirmPassword, ...registerData } = this.registerForm.value;

      // registerData teraz obsahuje { email, fullName, password }
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
      return this.translocoService.translate('auth.validation.required');
    }

    // Spojenie minlength do jedného bloku (ak je definovaný)
    if (control?.hasError('minlength')) {
      const minLength = control.errors?.['minlength'].requiredLength;
      return `Must be at least ${minLength} characters`;
    }

    // Prehodenie emailu a patternu sem, sú to špecifické chyby
    // Spojenie minlength do jedného bloku (ak je definovaný)
    if (control?.hasError('minlength')) {
      const minLength = control.errors?.['minlength'].requiredLength;
      return `Must be at least ${minLength} characters`;
    }

    // Prehodenie emailu a patternu sem, sú to špecifické chyby
    if (control?.hasError('email')) {
      return this.translocoService.translate('auth.validation.emailInvalid');
    }

    if (control?.hasError('pattern')) {
      return 'Must contain uppercase, lowercase, number and special character';
    }

    if (control?.hasError('pattern')) {
      return 'Must contain uppercase, lowercase, number and special character';
    }

    // Špecifické chyby pre registráciu/validáciu emailu
    if (control?.hasError('invalidUniversityDomain')) {
      return this.translocoService.translate('auth.validation.invalidUniversityDomain', {
        domains: this.allowedDomains.join(', ')
      });
    }

    if (control?.hasError('invalidEmailFormat')) {
      const domain = control.errors?.['invalidEmailFormat'].domain;
      return this.translocoService.translate('auth.validation.invalidEmailFormat', { domain });
    }

    if (control?.hasError('minlength')) {
      const minLength = control.errors?.['minlength'].requiredLength;
      return this.translocoService.translate('auth.validation.minLength', { length: minLength });
    }

    if (control?.hasError('pattern')) {
      return this.translocoService.translate('auth.validation.passwordPattern');
    }

    // Chyba pri zhodnosti hesiel
    if (control?.hasError('passwordMismatch')) {
      return this.translocoService.translate('auth.validation.passwordMismatch');
    }

    return '';
  }

}
