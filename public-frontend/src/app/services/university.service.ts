import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { University } from '@models/university.model';
import { environmentProduction } from '@env/environment.production';

@Injectable({ providedIn: 'root' })
export class UniversityService {
  private baseUrl = environmentProduction.apiUrl;

  constructor(private http: HttpClient) {
  }

  getUniversities(): Observable<University[]> {
    return this.http.get<University[]>(`${this.baseUrl}/university`);
  }
}
