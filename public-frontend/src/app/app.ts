import { Component, signal, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TranslocoService } from '@jsverse/transloco';
import { LoginDialogComponent, LoginData } from './components/auth/login-dialog.component';
import { RegisterDialogComponent, RegisterData } from './components/auth/register-dialog.component';

@Component({
  selector: 'app-root',
  imports: [
    MatToolbar,
    MatIcon,
    MatIconModule,
    MatButtonModule,
    MatSidenavModule,
    MatTooltipModule
    RouterOutlet  // Add RouterOutlet
  ],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App {
  private readonly translocoService = inject(TranslocoService);
  private readonly dialog = inject(MatDialog);
  private readonly snackBar = inject(MatSnackBar);

  readonly isDarkMode = signal(false);
  readonly currentLanguage = signal('sk');

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
        console.log('Login data:', result);
        this.snackBar.open('Login successful!', 'Close', {
          duration: 3000,
          horizontalPosition: 'end',
          verticalPosition: 'top'
        });
        // TODO: Call authentication service
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
        console.log('Register data:', result);
        this.snackBar.open('Registration successful! Please verify your email.', 'Close', {
          duration: 5000,
          horizontalPosition: 'end',
          verticalPosition: 'top'
        });
        // TODO: Call user registration service
      }
    });
  }
}
