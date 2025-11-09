import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UniversityModel } from '@models/university.model';
import { environment } from '@env/environment.production';

@Injectable({ providedIn: 'root' })
export class UniversityService {
  private http = inject(HttpClient);
  private baseUrl = environment.apiUrl;

  getUniversities(): Observable<UniversityModel[]> {
    return this.http.get<UniversityModel[]>(`${this.baseUrl}/university`);
  }
}
