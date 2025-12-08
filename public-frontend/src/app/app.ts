import { Component, signal, inject } from '@angular/core';
import { Router, RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TranslocoService } from '@jsverse/transloco';
import { LoginDialogComponent, LoginData } from '@components/auth/login-dialog.component';
import { RegisterDialogComponent, RegisterData } from '@components/auth/register-dialog.component';
import { AuthService } from '@services/auth.service';

@Component({
  selector: 'app-root',
  imports: [
    MatToolbar,
    MatIcon,
    MatIconModule,
    MatButtonModule,
    MatSidenavModule,
    MatTooltipModule,
    RouterOutlet
  ],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App {
  private readonly translocoService = inject(TranslocoService);
  private readonly dialog = inject(MatDialog);
  private readonly snackBar = inject(MatSnackBar);
  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);

  readonly isDarkMode = signal(false);
  readonly currentLanguage = signal('sk');
  readonly isLoggedIn = signal(false);
  readonly userEmail = signal<string | null>(null);

  constructor() {
    // Check if user is already logged in from localStorage
    const savedAuth = localStorage.getItem('authUser');
    if (savedAuth) {
      try {
        const authData = JSON.parse(savedAuth);
        this.isLoggedIn.set(true);
        this.userEmail.set(authData.email);
      } catch (error) {
        console.error('Failed to load auth state:', error);
      }
    }
  }

  toggleDarkMode(): void {
    this.isDarkMode.update(v => !v);

    if (this.isDarkMode()) {
      document.documentElement.classList.add('dark-mode');
    } else {
      document.documentElement.classList.remove('dark-mode');
    }
  }

  switchLanguage(): void {
    this.currentLanguage.set(this.currentLanguage() === 'sk' ? 'en' : 'sk');
    this.translocoService.setActiveLang(this.currentLanguage());
  }

  onLogin(): void {
    const dialogRef = this.dialog.open(LoginDialogComponent, {
      width: '500px',
      maxWidth: '95vw',
      disableClose: false,
      autoFocus: true,
      restoreFocus: true
    });

    dialogRef.afterClosed().subscribe((result: LoginData | undefined) => {
      if (result) {
        this.authService.login(result.email, result.password).subscribe({
          next: (response) => {
            // Set auth state
            this.isLoggedIn.set(true);
            this.userEmail.set(response.email);
            localStorage.setItem('authUser', JSON.stringify({ id: response.id, email: response.email, role: response.role }));

            this.snackBar.open('Login successful!', 'Close', {
              duration: 3000,
              horizontalPosition: 'end',
              verticalPosition: 'top'
            });
            this.router.navigate(['/profile']);
          },
          error: (error) => {
            const errorMessage = error.error || 'Login failed. Please try again.';
            this.snackBar.open(errorMessage, 'Close', {
              duration: 5000,
              horizontalPosition: 'end',
              verticalPosition: 'top'
            });
          }
        });
      }
    });
  }

  onRegister(): void {
    const dialogRef = this.dialog.open(RegisterDialogComponent, {
      width: '550px',
      maxWidth: '95vw',
      disableClose: false,
      autoFocus: true,
      restoreFocus: true
    });

    dialogRef.afterClosed().subscribe((result: RegisterData | undefined) => {
      if (result) {
        this.authService.register(result.email, result.password).subscribe({
          next: (response) => {
            // Set auth state immediately after registration (pending verification)
            this.isLoggedIn.set(true);
            this.userEmail.set(result.email);
            localStorage.setItem('authUser', JSON.stringify({ id: response.id, email: response.email, role: response.role }));

            this.snackBar.open('Registration successful! Please check your email for verification code.', 'Close', {
              duration: 5000,
              horizontalPosition: 'end',
              verticalPosition: 'top'
            });
            // Redirect to profile page with verification query params
            this.router.navigate(['/profile'], {
              queryParams: {
                verify: 'true',
                email: result.email
              }
            });
          },
          error: (error) => {
            const errorMessage = error.error || 'Registration failed. Please try again.';
            this.snackBar.open(errorMessage, 'Close', {
              duration: 5000,
              horizontalPosition: 'end',
              verticalPosition: 'top'
            });
          }
        });
      }
    });
  }

  onHome(): void {
    this.router.navigate(['/universities']);
  }

  onProfile(): void {
    this.router.navigate(['/profile']);
  }

  onLogout(): void {
    this.authService.logout().subscribe({
      next: () => {
        // Clear auth state
        this.isLoggedIn.set(false);
        this.userEmail.set(null);
        localStorage.removeItem('authUser');

        this.snackBar.open('Logged out successfully', 'Close', {
          duration: 3000,
          horizontalPosition: 'end',
          verticalPosition: 'top'
        });
        this.router.navigate(['/']);
      },
      error: (error) => {
        console.error('Logout error:', error);
        // Clear auth state even if server request fails
        this.isLoggedIn.set(false);
        this.userEmail.set(null);
        localStorage.removeItem('authUser');
        this.router.navigate(['/']);
      }
    });
  }
}
