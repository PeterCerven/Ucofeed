import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '@env/environment.production';

export interface SignUpRequest {
  email: string;
  password: string;
}

export interface VerifyCodeRequest {
  email: string;
  verificationCode: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  message: string;
  id: string;
  email: string;
  role: string;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  register(email: string, password: string): Observable<AuthResponse> {
    const request: SignUpRequest = { email, password };
    return this.http.post<AuthResponse>(
      `${this.baseUrl}/public/auth/register`,
      request,
      { withCredentials: true }
    );
  }

  verify(
    email: string,
    verificationCode: string
  ): Observable<AuthResponse> {
    const request: VerifyCodeRequest = { email, verificationCode };
    return this.http.post<AuthResponse>(
      `${this.baseUrl}/public/auth/verify`,
      request,
      { withCredentials: true }
    );
  }

  login(email: string, password: string): Observable<AuthResponse> {
    const request: LoginRequest = { email, password };
    return this.http.post<AuthResponse>(
      `${this.baseUrl}/public/auth/login`,
      request,
      { withCredentials: true }
    );
  }

  logout(): Observable<string> {
    return this.http.post(`${this.baseUrl}/public/auth/logout`, null, {
      responseType: 'text',
      withCredentials: true
    });
  }

  validateSession(): Observable<{ valid: boolean; id?: string; email?: string; role?: string }> {
    return this.http.get<{ valid: boolean; id?: string; email?: string; role?: string }>(
      `${this.baseUrl}/public/auth/validate`,
      { withCredentials: true }
    );
  }
}
