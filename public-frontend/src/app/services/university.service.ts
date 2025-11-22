import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UniversityModel } from '@models/university.model';
import { FacultyModel } from '@models/faculty.model';
import { ProgramModel } from '@models/program.model';
import { environment } from '@env/environment.production';

@Injectable({ providedIn: 'root' })
export class UniversityService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  getUniversities(): Observable<UniversityModel[]> {
    return this.http.get<UniversityModel[]>(`${this.baseUrl}/public/university`);
  }

  getFacultiesByUniversity(universityId: number): Observable<FacultyModel[]> {
    return this.http.get<FacultyModel[]>(`${this.baseUrl}/public/university/${universityId}/faculties`);
  }

  getProgramsByFaculty(facultyId: number): Observable<ProgramModel[]> {
    return this.http.get<ProgramModel[]>(`${this.baseUrl}/public/university/faculty/${facultyId}/programs`);
  }
}
