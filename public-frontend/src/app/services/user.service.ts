import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '@env/environment.production';

export interface UpdateUserRequest {
  studyProgramId: number;
  studyProgramVariantId: number;
  status: string;
}

export interface UserEducationResponse {
  id: number;
  study_program_id: number;
  study_program_name: string;
  faculty_id: number;
  faculty_name: string;
  university_id: number;
  university_name: string;
  study_program_variant_id: number;
  study_format: string;
  language: string;
  title: string;
  status: string;
}

export interface UserResponse {
  id: string;
  full_name: string;
  email: string;
  educations: UserEducationResponse[];
}

@Injectable({ providedIn: 'root' })
export class UserService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  getUserById(userId: string): Observable<UserResponse> {
    return this.http.get<UserResponse>(`${this.baseUrl}/public/user/${userId}`, {
      withCredentials: true
    });
  }

  updateUser(userId: string, updateData: UpdateUserRequest): Observable<UserResponse> {
    return this.http.put<UserResponse>(
      `${this.baseUrl}/public/user/${userId}`,
      updateData,
      { withCredentials: true }
    );
  }

  getAllUsers(): Observable<UserResponse[]> {
    return this.http.get<UserResponse[]>(`${this.baseUrl}/public/user`, {
      withCredentials: true
    });
  }
}
