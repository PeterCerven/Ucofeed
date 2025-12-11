import { Injectable, signal } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class AuthStateService {
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
        this.isLoggedIn.set(true);
        this.userEmail.set(authData.email);
        this.userId.set(authData.id);
        this.userRole.set(authData.role);
      } catch (error) {
        console.error('Failed to load auth state:', error);
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
