import { Injectable, signal, inject } from '@angular/core';
import { AuthService } from './auth.service';

@Injectable({ providedIn: 'root' })
export class AuthStateService {
  private readonly authService = inject(AuthService);

  readonly isLoggedIn = signal(false);
  readonly userEmail = signal<string | null>(null);
  readonly userId = signal<string | null>(null);
  readonly userRole = signal<string | null>(null);

  constructor() {
    this.loadAuthState();
  }

  private loadAuthState() {
    const savedAuth = localStorage.getItem('authUser');
    if (savedAuth) {
      try {
        const authData = JSON.parse(savedAuth);
        // Validate session with backend
        this.authService.validateSession().subscribe({
          next: (response) => {
            if (response.valid && response.id && response.email && response.role) {
              // Session is valid, update state
              this.isLoggedIn.set(true);
              this.userEmail.set(response.email);
              this.userId.set(response.id);
              this.userRole.set(response.role);
            } else {
              // Session invalid, clear state
              this.clearAuthState();
            }
          },
          error: () => {
            // Session validation failed, clear state
            console.log('Session validation failed, clearing auth state');
            this.clearAuthState();
          }
        });
      } catch (error) {
        console.error('Failed to load auth state:', error);
        this.clearAuthState();
      }
    }
  }

  setAuthState(authData: { id: string; email: string; role: string }) {
    localStorage.setItem('authUser', JSON.stringify(authData));
    this.isLoggedIn.set(true);
    this.userEmail.set(authData.email);
    this.userId.set(authData.id);
    this.userRole.set(authData.role);
  }

  clearAuthState() {
    localStorage.removeItem('authUser');
    this.isLoggedIn.set(false);
    this.userEmail.set(null);
    this.userId.set(null);
    this.userRole.set(null);
  }

  isVerified(): boolean {
    // For now, if logged in = verified
    // Later: check separate verified flag
    return this.isLoggedIn();
  }
}
