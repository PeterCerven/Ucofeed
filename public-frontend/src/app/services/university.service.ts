import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UniversityModel } from '@models/university.model';
import { FacultyModel } from '@models/faculty.model';
import { ProgramModel } from '@models/program.model';
import { VariantModel } from '@models/variant.model';
import { StudyProgramDetailsModel } from '@models/program-details.model';
import { environment } from '@env/environment.production';

@Injectable({ providedIn: 'root' })
export class UniversityService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  getUniversities(): Observable<UniversityModel[]> {
    return this.http.get<UniversityModel[]>(`${this.baseUrl}/public/university`);
  }

  getUniversityById(id: number): Observable<UniversityModel> {
    return this.http.get<UniversityModel>(`${this.baseUrl}/public/university/${id}`);
  }

  getStudyProgramById(programId: number): Observable<StudyProgramDetailsModel> {
    return this.http.get<StudyProgramDetailsModel>(`${this.baseUrl}/public/university/program/${programId}`);
  }

  getFacultiesByUniversity(universityId: number): Observable<FacultyModel[]> {
    return this.http.get<FacultyModel[]>(`${this.baseUrl}/public/university/${universityId}/faculties`);
  }

  getFacultyById(id: number): Observable<FacultyModel> {
    return this.http.get<FacultyModel>(`${this.baseUrl}/public/university/faculty/${id}`);
  }

  getProgramsByFaculty(facultyId: number): Observable<ProgramModel[]> {
    return this.http.get<ProgramModel[]>(`${this.baseUrl}/public/university/faculty/${facultyId}/programs`);
  }

  getVariantsByProgram(programId: number): Observable<VariantModel[]> {
    return this.http.get<VariantModel[]>(`${this.baseUrl}/public/university/program/${programId}/variants`);
  }
}
