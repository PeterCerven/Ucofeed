import { Component, signal, inject } from '@angular/core';
import { Router, RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TranslocoService, TranslocoDirective } from '@jsverse/transloco';
import { LoginDialogComponent, LoginData } from '@components/auth/login-dialog.component';
import { RegisterDialogComponent, RegisterData } from '@components/auth/register-dialog.component';
import { AuthService } from '@services/auth.service';
import { AuthStateService } from '@services/auth-state.service';

@Component({
  selector: 'app-root',
  imports: [
    MatToolbar,
    MatIcon,
    MatIconModule,
    MatButtonModule,
    MatSidenavModule,
    MatTooltipModule,
    RouterOutlet,
    TranslocoDirective
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
  private readonly authState = inject(AuthStateService);

  readonly isDarkMode = signal(false);
  readonly currentLanguage = signal('sk');

  // Delegate to auth state service
  readonly isLoggedIn = this.authState.isLoggedIn;
  readonly userEmail = this.authState.userEmail;

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
            // Update shared auth state
            this.authState.setAuthState({
              id: response.id,
              email: response.email,
              role: response.role
            });

            this.snackBar.open(
              this.translocoService.translate('app.snackbar.loginSuccess'),
              this.translocoService.translate('app.snackbar.close'),
              {
                duration: 3000,
                horizontalPosition: 'end',
                verticalPosition: 'top'
              }
            );
            this.router.navigate(['/profile']);
          },
          error: (error) => {
            const errorMessage = error.error || this.translocoService.translate('app.snackbar.loginFailed');
            this.snackBar.open(
              errorMessage,
              this.translocoService.translate('app.snackbar.close'),
              {
                duration: 5000,
                horizontalPosition: 'end',
                verticalPosition: 'top'
              }
            );
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

            this.snackBar.open(
              this.translocoService.translate('app.snackbar.registerSuccess'),
              this.translocoService.translate('app.snackbar.close'),
              {
                duration: 5000,
                horizontalPosition: 'end',
                verticalPosition: 'top'
              }
            );
            // Redirect to profile page with verification query params
            this.router.navigate(['/profile'], {
              queryParams: {
                verify: 'true',
                email: result.email
              }
            });
          },
          error: (error) => {
            const errorMessage = error.error || this.translocoService.translate('app.snackbar.registrationFailed');
            this.snackBar.open(
              errorMessage,
              this.translocoService.translate('app.snackbar.close'),
              {
                duration: 5000,
                horizontalPosition: 'end',
                verticalPosition: 'top'
              }
            );
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
        // Clear shared auth state
        this.authState.clearAuthState();

        this.snackBar.open(
          this.translocoService.translate('app.snackbar.logoutSuccess'),
          this.translocoService.translate('app.snackbar.close'),
          {
            duration: 3000,
            horizontalPosition: 'end',
            verticalPosition: 'top'
          }
        );
        this.router.navigate(['/']);
      },
      error: (error) => {
        console.error('Logout error:', error);
        // Clear auth state even if server request fails
        this.authState.clearAuthState();
        this.router.navigate(['/']);
      }
    });
  }
}
